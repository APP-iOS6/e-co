//
//  UserInquiryHistoryView.swift
//  ECO_FB_Test
//
//  Created by wonhoKim on 10/21/24.
//

import SwiftUI
//이제 셀러계정으로 로그인 했을때, 셀러계정과 문의의 셀러 id 가 같은 문의들만 가져오기 
struct UserInquiryHistoryView: View {
    @Environment(UserStore.self) private var userStore: UserStore
    @Environment(OneToOneInquiryStore.self) private var inquiryStore: OneToOneInquiryStore
    @State private var isLoading = true
    @State private var errorMessage: String?
    var body: some View {
        
        NavigationView {
            List(inquiryStore.oneToOneInquiries) { inquiry in
                    NavigationLink(destination: UserInquiryHistoryDetailView(inquiry: inquiry)) {
                        HStack {
                            Circle()
                                .fill(Color.accentColor)
                                .frame(width: 30, height: 30)
                                .overlay(
                                    Text("Q")
                                        .foregroundColor(.white)
                                )
                            VStack(alignment: .leading) {
                                
                                Text(inquiry.title)
                                    .font(.headline)
                                if inquiry.answer.isEmpty {
                                    Text("답변 대기중")
                                        .font(.caption)
                                        .foregroundStyle(.red)
                                } else {
                                    Text("답변 완료")
                                        .font(.caption)
                                }
                                
                            }
                            .padding()
                        }
                    }
            }
            .navigationTitle("내 문의 내역")
            .task {
                loadInquiries()
            }
            .onDisappear {
                inquiryStore.removeAll()
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
                isLoading = true
                _ = try await inquiryStore.fetchData(parameter: .oneToOneInquiryAll(sellerID: user.id, limit: 10))
                isLoading = false
            } catch {
                errorMessage = "Failed to load inquiries: \(error.localizedDescription)"
                isLoading = false // 로딩 상태 종료
            }
        }
    }
}

#Preview {
    UserInquiryHistoryView()
}

