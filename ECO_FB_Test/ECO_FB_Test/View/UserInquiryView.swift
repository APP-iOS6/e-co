//
//  UserInquiryView.swift
//  ECO_FB_Test
//
//  Created by wonhoKim on 10/21/24.
//

import SwiftUI

struct UserInquiryView: View {
    @Environment(UserStore.self) private var userStore: UserStore
    @State private var title: String = ""
    @State private var message: String = ""
    @State private var isSubmitted: Bool = false  
    let inquiryStore = OneToOneInquiryStore.shared
    var body: some View {
        VStack(spacing: 10) {
            
            TextField("제목을 입력하세요.", text: $title)
                .frame(height: 10)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)
            
            TextEditor(text: $message)
                .frame(height: 400)
                .padding(4)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                )
            
            Button(action: {
                print("전송 버튼 클릭")
                isSubmitted = true
                //inquiryStore.saveInquiry(inquiry: )
                guard let user = userStore.userData else {
                    print("유저 정보가 없습니다.")
                    return
                }
                
                let newInquiry = OneToOneInquiry(
                    id: UUID().uuidString,
                    creationDate: Date(),
                    user: user,
                    seller: user, // 셀러를 일단은 로그인한 유저로 지정
                    title: title,
                    question: message,
                    answer: ""
                )
                Task {
                    do {
                        try await inquiryStore.saveInquiry(inquiry: newInquiry)
                        isSubmitted = true
                        // 필드 초기화
                        title = ""
                        message = ""
                    } catch {
                        print("파베 업로드 안됌")
                    }
                }
            }) {
                Text("전송하기")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .cornerRadius(8)
            }
            .alert(isPresented: $isSubmitted) {
                Alert(title: Text("문의 완료"), message: Text("1:1 문의가 성공적으로 전송되었습니다."), dismissButton: .default(Text("확인")))
            }
            Spacer()
        }
        .padding()
        
        .frame(maxHeight: .infinity, alignment: .top)
        .navigationTitle("1:1 문의하기")
        .navigationBarTitleDisplayMode(.inline)
        
    }
    
}

#Preview {
    UserInquiryView()
        .environment(UserStore.shared)
}
