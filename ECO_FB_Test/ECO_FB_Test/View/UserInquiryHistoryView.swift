//
//  UserInquiryHistoryView.swift
//  ECO_FB_Test
//
//  Created by wonhoKim on 10/21/24.
//

import SwiftUI

struct UserInquiryHistoryView: View {
    @Environment(UserStore.self) private var userStore: UserStore
    @Environment(OneToOneInquiryStore.self) private var inquiryStore: OneToOneInquiryStore
    
    @State private var dataFetchFlow: DataFlow = .none
    @State private var errorMessage: String?
    
    var body: some View {
        NavigationView {
            ZStack {
                if dataFetchFlow == .loading {
                    ProgressView("로딩 중...")
                        .progressViewStyle(CircularProgressViewStyle(tint: .accentColor))
                        .scaleEffect(1.5, anchor: .center)
                } else {
                    List(inquiryStore.oneToOneInquiryList) { inquiry in
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
                    
                }
            }
            .onAppear {
                Task {
                    inquiryStore.removeALL()
                    await loadInquiries()
                    print("로드 성공")
                }
            }
            
        }
        
    }
    
    private func loadInquiries() async {
        do {
            guard let user = userStore.userData else {
                print("유저 정보가 없습니다.")
                return
            }
            _ = try await DataManager.shared.fetchData(
                type: .oneToOneInquiry,
                parameter: .oneToOneInquiryAllWithUser(userID: user.id, limit: 10),
                flow: $dataFetchFlow
            )
        } catch {
            errorMessage = "데이터를 불러오는데 실패했습니다."
        }
    }
    
}

#Preview {
    UserInquiryHistoryView()
}
