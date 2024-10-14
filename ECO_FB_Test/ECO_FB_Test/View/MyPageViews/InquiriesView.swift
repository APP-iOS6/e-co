//
//  InquiriesView.swift
//  ECO_FB_Test
//
//  Created by Hwang_Inyoung on 10/14/24.
//

import SwiftUI

struct InquiriesView: View {
    @State private var inquiryTitle: String = ""  // 제목
    @State private var inquiryContent: String = ""  // 내용
    @State private var isSubmitted: Bool = false  // 전송 상태

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {
                
                // 제목 입력 필드
                TextField("제목을 입력하세요", text: $inquiryTitle)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                
                // 내용 입력 필드
                TextEditor(text: $inquiryContent)
                    .frame(height: 300)
                    .border(Color.gray, width: 1)
                    .padding(.horizontal)
                
                // 제출 버튼
                Button(action: {
                    // 문의 내용 전송 처리
                    isSubmitted = true
                }) {
                    Text("전송하기")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
                .alert(isPresented: $isSubmitted) {
                    Alert(title: Text("문의 완료"), message: Text("1:1 문의가 성공적으로 전송되었습니다."), dismissButton: .default(Text("확인")))
                }

                Spacer()
            }
            .padding(.vertical)
            .navigationTitle("1:1 문의하기")
        }
    }
}

#Preview {
    InquiriesView()
}
