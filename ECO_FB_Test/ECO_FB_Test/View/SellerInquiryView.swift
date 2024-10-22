//  SellerInquiryView.swift
//  ECO_FB_Test
//
//  Created by wonhoKim on 10/21/24.
//

import SwiftUI


struct SellerInquiryView: View {
    @Environment(UserStore.self) private var userStore: UserStore
    @Environment(OneToOneInquiryStore.self) private var inquiryStore: OneToOneInquiryStore
    @State private var dataFetchFlow: DataFetchFlow = .loading
    //프로그레스뷰 만들예정
    @State private var isLoading = true
    @State private var errorMessage: String?
    var body: some View {
        NavigationView {
            List(inquiryStore.oneToOneInquiries) { inquiry in
                NavigationLink(destination: SellerInquiryDetailView(inquiry: inquiry)) {
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
                                    Text("답변 미완료")
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
            .navigationTitle("현재 들어온 문의 내역")
            .task {
                
                loadInquiries()
                print("로드성공")
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
             //   _ = try await inquiryStore.fetchData(parameter: .oneToOneInquiryAll(sellerID: user.id, limit: 10))
                _ = await DataManager.shared.fetchData(type: .oneToOneInquiry, parameter: .oneToOneInquiryAll(sellerID: user.id, limit: 10)) { _ in
                    
                }
                
                print("불렷나?")
//                try await DataManager.shared.fetchData(type:.user, parameter: .oneToOneInquiryAll(sellerID: user.id, limit: 10){ _ in
//                    
//                }
                isLoading = false
            } catch {
                errorMessage = "Failed to load inquiries: \(error.localizedDescription)"
                isLoading = false // 로딩 상태 종료
            }
        }
    }
}
