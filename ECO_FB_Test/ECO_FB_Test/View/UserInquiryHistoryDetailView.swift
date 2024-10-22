//
//  UserInquiryHistoryDetailView.swift
//  ECO_FB_Test
//
//  Created by wonhoKim on 10/21/24.
//

import SwiftUI

struct UserInquiryHistoryDetailView: View {
    
    let inquiry: OneToOneInquiry
    var body: some View {
        VStack(alignment: .leading){
            HStack{
                Text("제목:")
                Text(inquiry.title)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
          
            HStack {
                Text("날짜:")
                Text(inquiry.creationDate, style: .date)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            HStack {
                Text("셀러:")
                Text(inquiry.seller.name)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
           
            Text("질문:")
                .frame(maxWidth: .infinity, alignment: .leading)
            Text(inquiry.question)
                .frame(maxWidth: .infinity, alignment: .leading)
                .lineLimit(nil)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(5)
                .padding(.bottom)
                
            Text("답변:")
            
            if inquiry.answer.isEmpty {
                Text("답변 대기중입니다.")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .lineLimit(nil)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(5)
                    .padding(.bottom)
                    .padding(.top, -0)
            } else {
                Text(inquiry.answer)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .lineLimit(nil)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(5)
                    .padding(.bottom)
                    .padding(.top, -0)
           
        }
        
                //가능하면 답변 수정도 추가
                Spacer()

        }
        .padding()
        .navigationTitle("상세 문의 내역")
    }
    
  
}

//#Preview {
//    UserInquiryHistoryDetailView(inquiry: .init(id: "1", title: "배송이 너무 안와요", question: "주문이 안되요 주문 너무 많아요 힘들어요 하렉 많아요 하하하하하하 메롱 약오르지 너무 안오고 너무 안오고", answer: "", date: Date()))
//}
