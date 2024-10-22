//
//  SellerInquiryDetailView.swift
//  ECO_FB_Test
//
//  Created by wonhoKim on 10/21/24.
//

import SwiftUI

//임시 상세 페이지
struct SellerInquiryDetailView: View {
    
    @State private var answer: String = ""
    let inquiryStore = OneToOneInquiryStore.shared
    let inquiry: OneToOneInquiry
    var body: some View {
        VStack(spacing: 40){            
            LazyVGrid(columns: [GridItem(.fixed(40)), GridItem(.flexible())], spacing: 10) {
                Text("제목:")
                //.font(.headline)
                Text(inquiry.title)
                //.font(.title3)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("셀러:")
                Text(inquiry.seller.name)
                Text("질문:")
                // .font(.headline)
                Text(inquiry.question)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("날짜:")
                //.font(.headline)
                Text(inquiry.creationDate, style: .date)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("답변:")
            }
            
            
            if inquiry.answer.isEmpty {
                TextEditor(text: $answer)
                    .frame(height: 300)
                    .border(Color.gray, width: 1)
                    .padding(.top, -40)
                Button(action: {
                    
                    submitAnswer()
                }) {
                    Text("답변 제출")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.accentColor)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding(.bottom)
            } else {
                Text(inquiry.answer)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .lineLimit(nil)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(5)
                    .padding(.bottom)
                    .padding(.top, -40)
            }
            
            Spacer()
        }
        .padding()
        .navigationTitle("상세 문의 내역")
    }
    
    private func submitAnswer() {
        //답변 업데이트 될 로직 이 와야할곳
        guard !answer.isEmpty else {
            print("답변이 비어 있습니다.")
            return
        }
        Task {
            do {
                let inquiryID = inquiry.id // 업데이트할 문의의 ID
                try await inquiryStore.updateInquiryAnswer(inquiryID: inquiryID, answer: answer)
                print("답변이 성공적으로 업데이트되었습니다.")
                answer = ""
            } catch {
                
                print("업데이트문서 ID: \(inquiry.id)")
                print("답변 업데이트 실패: \(error.localizedDescription)")
            }
        }
        
    }
}

//#Preview {
//    SellerInquiryDetailView(inquiry: .init(id: "1", title: "배송이 너무 안와요", question: "주문이 안되요", answer: "님알아서 기다리세요", date: Date()))
//}
