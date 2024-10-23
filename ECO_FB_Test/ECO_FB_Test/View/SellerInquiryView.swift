//  SellerInquiryView.swift
//  ECO_FB_Test
//
//  Created by wonhoKim on 10/21/24.
//

import SwiftUI

import SwiftUI

struct SellerInquiryView: View {
    @Environment(UserStore.self) private var userStore: UserStore
    @Environment(OneToOneInquiryStore.self) private var inquiryStore: OneToOneInquiryStore
    @State private var isLoading = true  // 로딩 상태
    @State private var errorMessage: String?
    
    var body: some View {
        NavigationView {
            ZStack {
                if !isLoading {
                    List(inquiryStore.oneToOneInquiryList) { inquiry in
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
                    .navigationBarTitleDisplayMode(.inline)
                } else {
                    // 로딩 중일 때 프로그레스뷰 표시
                    ProgressView("로딩 중...")
                        .progressViewStyle(CircularProgressViewStyle(tint: .accentColor))
                        .scaleEffect(1.5)
                }
            }
            .task {
                inquiryStore.removeALL()
                await loadInquiries()
                print("로드 성공")
            }
        }
    }
    
    private func loadInquiries() async {
        do {
            guard let user = userStore.userData else {
                print("유저 정보가 없습니다.")
                isLoading = false  // 에러 발생 시 로딩 종료
                return
            }
            isLoading = true  // 로딩 시작
            _ = try await DataManager.shared.fetchData(
                type: .oneToOneInquiry,
                parameter: .oneToOneInquiryAllWithSeller(sellerID: user.id, limit: 10)
            )
            print("불렀나?")
            isLoading = false  // 로딩 종료
        } catch {
            errorMessage = "데이터를 불러오는데 실패했습니다."
            isLoading = false
        }
    }
}

#Preview {
    SellerInquiryView()
}
