//
//  CreateAccountView.swift
//  ECO_FB_Test
//
//  Created by wonhoKim on 10/14/24.
//

import SwiftUI

enum Field{
    
    case email
    case password
    case checkingPassword
    case name
    
}

struct CreateAccountView: View {
    @State var userName: String = ""
    @State var userEmail: String = ""
    @State var userPassword: String = ""
    @State var checkUserPassword: String = ""
    @FocusState private var focusedField: Field?
    @Environment(\.dismiss) private var dismiss
    
    private var isEmailForm: Bool {
        let emailRegex = "^[A-Z0-9a-z._%+-]+@[A-Z0-9a-z.-]+\\.[A-Za-z]{2,}$"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: userEmail)
    }
    var body: some View {
        VStack {
            Text("SignUp")
                .font(.title)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.vertical, 30)
            VStack{
               
                Text("이름").textFieldStyle(paddingTop: 0, paddingLeading: -165, isFocused: focusedField == .name)
                HStack(spacing: -10) {
                    Image(systemName: "at")
                    UnderlineTextFieldView(
                        text: $userName,
                        textFieldView: nameView,
                        placeholder: "이름을 입력해주세요" ,
                        isFocused: focusedField == .name
                    )
                    .focused($focusedField, equals: .name)
                }
            }
            
            VStack{
                
                Text("이메일")
                    .textFieldStyle(paddingTop:20, paddingLeading: -165, isFocused: focusedField == .email)
                HStack(spacing: -10) {
                    Image(systemName: "person")
                    UnderlineTextFieldView(
                        text: $userEmail,
                        textFieldView: textView,
                        placeholder: "이메일" ,
                        isFocused: focusedField == .email
                    )
                    .focused($focusedField, equals: .email)
                }
                HStack {
                    Image(systemName: "exclamationmark.triangle.fill").font(.caption2)
                    Text("이메일 형식으로 입력해주세요!")
                        .font(.caption2)
                    Spacer()
                }
                .padding(.leading)
                .foregroundColor(isEmailForm ? .clear : .red)
                .opacity(userEmail.isEmpty ? (focusedField == .email ? 1 : 0) : 1)
            }
            VStack{
                
                Text("패스워드")
                    .textFieldStyle(paddingTop: 2, paddingLeading: -165, isFocused: focusedField == .password)
                HStack(spacing: -10) {
                    Image(systemName: "lock")
                    UnderlineTextFieldView(
                        text: $userPassword,
                        textFieldView: passwordView,
                        placeholder: "패스워드",
                        isFocused: focusedField == .password
                    )
                    .focused($focusedField, equals: .password)
                }
            }
            
            VStack{
                
                Text("패스워드 확인")
                    .textFieldStyle(paddingTop: 20, paddingLeading: -165, isFocused: focusedField == .checkingPassword)
                HStack(spacing: -10) {
                    Image(systemName: "lock")
                    UnderlineTextFieldView(
                        text: $checkUserPassword,
                        textFieldView: checkPasswordView,
                        placeholder: "패스워드를 다시 입력해주세요",
                        isFocused: focusedField == .checkingPassword
                    )
                    .focused($focusedField, equals: .checkingPassword)
                }
                HStack{
                    
                    if checkUserPassword != userPassword {
                        Image(systemName: "exclamationmark.triangle.fill").font(.caption2)
                        Text("비밀번호가 서로 달라용!")
                            .font(.caption2)
                    }
                    Spacer()
                }
                .padding(.leading)
                .opacity(checkUserPassword.isEmpty ? (focusedField == .checkingPassword ? 1 : 0) : 1)
                //.foregroundColor(isPasswordUnCorrectError ? .red : .clear)
                .foregroundColor(.red)
                
            }
            
            Button(action: {
                //
               
                Task {
                    //await signUpUser()
                    do {
                        try await AuthManager.shared.signUp(withEmail: userEmail, password: userPassword, name: userName)
                        print("회원가입함")
                    }   catch {
                        print("회원가입 실패: \(error.localizedDescription)") // 에러 처리
                    }
                    dismiss()
                }
            }, label: {
                Text("회원가입").font(.headline)
            }).disabled(!checkSignup() ? true : false)
                .frame(width: 280, height: 40)
                .background(checkSignup() ?Color.green :Color.gray)
                .cornerRadius(10)
                .foregroundColor(.white)
            
            Spacer()
            
        }.padding()
    }
    private func checkSignup() -> Bool {
        if userName.isEmpty || userEmail.isEmpty || userPassword.isEmpty || checkUserPassword.isEmpty || checkUserPassword != userPassword || isEmailForm != true {
            return false
        }
        
        return true
    }
    
}

extension CreateAccountView {
    
    private var nameView: some View {
        TextField("", text: $userName)
            .foregroundColor(.black)
            .keyboardType(.emailAddress)
            .autocapitalization(.none)
            .onTapGesture {
                focusedField = .name
            }
    }
    
    private var textView: some View {
        TextField("", text: $userEmail)
            .foregroundColor(.black)
            .keyboardType(.emailAddress)
            .autocapitalization(.none)
            .onTapGesture {
                focusedField = .email
            }
    }
    
    private var passwordView: some View {
        SecureField("", text: $userPassword)
            .foregroundColor(.black)
            .onTapGesture {
                focusedField = .password
            }
        
    }
    private var checkPasswordView: some View {
        SecureField("", text: $checkUserPassword)
            .foregroundColor(.black)
            .onTapGesture {
                focusedField = .checkingPassword
            }
        
    }
}

#Preview {
    CreateAccountView()
}
