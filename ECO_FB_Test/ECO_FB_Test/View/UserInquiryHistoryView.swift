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
        }
    }
}

#Preview {
    UserInquiryHistoryView()
}

