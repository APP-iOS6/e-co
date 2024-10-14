//
//  ProductQuestionsView.swift
//  ECO_FB_Test
//
//  Created by Hwang_Inyoung on 10/14/24.
//

import SwiftUI

struct ProductQuestionsView: View {
    @State private var questionTitle: String = ""  // 문의 제목
    @State private var questionContent: String = ""  // 문의 내용
    @State private var isSubmitted: Bool = false  // 전송 상태

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {
                
                // 문의 제목 입력 필드
                TextField("제목을 입력하세요", text: $questionTitle)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                
                // 문의 내용 입력 필드
                TextEditor(text: $questionContent)
                    .frame(height: 300)
                    .border(Color.gray, width: 1)
                    .padding(.horizontal)
                
                // 전송 버튼
                Button(action: {
                    // 문의 내용 전송 처리
                    isSubmitted = true
                }) {
                    Text("문의하기")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
                .alert(isPresented: $isSubmitted) {
                    Alert(title: Text("문의 완료"), message: Text("상품 문의가 성공적으로 전송되었습니다."), dismissButton: .default(Text("확인")))
                }

                Spacer()
            }
            .padding(.vertical)
            .navigationTitle("상품 문의하기")
        }
    }
}

#Preview {
    ProductQuestionsView()
}
