import SwiftUI


//테스트용뷰
struct InquiryListView: View {
    @Environment(UserStore.self) private var userStore: UserStore
    @Environment(OneToOneInquiryStore.self) private var inquiryStore: OneToOneInquiryStore
    @State private var isLoading = true
    @State private var errorMessage: String?
    
    var body: some View {
        NavigationView {
            Group {
                if isLoading {
                    ProgressView("Loading inquiries...")
                } else if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                } else {
                    List(inquiryStore.oneToOneInquiries, id: \.id) { inquiry in
                        InquiryRowView(inquiry: inquiry)
                    }
                }
            }
            .navigationTitle("Inquiries")
            .onAppear {
                loadInquiries()
            }
            .refreshable {
                loadInquiries()
            }
        }
    }

    private func loadInquiries() {
        Task {
            do {
                guard let user = userStore.userData else {
                    print("유저 정보가 없습니다.")
                    return
                }
                isLoading = true // 로딩 상태 시작
                _ = try await inquiryStore.fetchData(parameter: .oneToOneInquiryAll(sellerID: user.id, limit: 10))
                isLoading = false // 로딩 상태 종료
            } catch {
                errorMessage = "Failed to load inquiries: \(error.localizedDescription)"
                isLoading = false // 로딩 상태 종료
            }
        }
    }
}

struct InquiryRowView: View {
    let inquiry: OneToOneInquiry

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(inquiry.title)
                .font(.headline)
            Text("Question: \(inquiry.question)")
                .font(.subheadline)
            if !inquiry.answer.isEmpty {
                Text("Answer: \(inquiry.answer)")
                    .font(.body)
                    .foregroundColor(.green)
            }
            Text("Asked by: \(inquiry.user.id)")
                .font(.footnote)
                .foregroundColor(.gray)
            Text(inquiry.creationDate, style: .date)
                .font(.footnote)
                .foregroundColor(.gray)
        }
        .padding()
    }
}
