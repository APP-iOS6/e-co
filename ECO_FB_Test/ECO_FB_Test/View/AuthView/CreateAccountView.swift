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
    @Binding var showToast: Bool
    @State var userName: String = ""
    @State var userEmail: String = ""
    @State var userPassword: String = ""
    @State var checkUserPassword: String = ""
    @FocusState private var focusedField: Field?
    @FocusState private var isfocused: Bool //여기는 키보드 내리는거 위해
    @Environment(\.dismiss) private var dismiss
    @State var emailErrorMasage: String = ""
    private var isPasswordCount: Bool {
        userPassword.count <= 5
    }
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
            //이름영역
            VStack{
                Text("이름").textFieldStyle(paddingTop: 0, paddingLeading: -165, isFocused: focusedField == .name)
                HStack(spacing: -15) {
                    Image(systemName: "person")
                    UnderlineTextFieldView(
                        text: $userName,
                        textFieldView: nameView,
                        placeholder: "이름을 입력해주세요" ,
                        isFocused: focusedField == .name
                    )
                    .focused($focusedField, equals: .name)
                }
            }.frame(width: 370 , height: 75, alignment: .leading)
            //이메일 영역
            VStack{
                Text("이메일")
                    .textFieldStyle(paddingTop: 10, paddingLeading: -165, isFocused: focusedField == .email)
                HStack(spacing: -20) {
                    Image(systemName: "at")
                        .padding(.trailing, 5)
                    UnderlineTextFieldView(
                        text: $userEmail,
                        textFieldView: textView,
                        placeholder: " 이메일" ,
                        isFocused: focusedField == .email
                    )
                    .focused($focusedField, equals: .email)
                }
                HStack {
                    if !isEmailForm && !userEmail.isEmpty {
                        Image(systemName: "exclamationmark.triangle.fill").font(.caption2).foregroundColor(.red)
                        Text("이메일 형식으로 입력해주세요!")
                            .font(.caption)
                            .foregroundColor(.red)
                    } else if !emailErrorMasage.isEmpty {
                        Image(systemName: "exclamationmark.triangle.fill").font(.caption2).foregroundColor(.red)
                        Text(emailErrorMasage)
                            .font(.caption)
                            .foregroundColor(.red)
                    } else {
                        Text("")
                            .font(.caption2)
                            .foregroundColor(.clear)
                    }
                    Spacer()
                }
                .padding(.leading)
                .opacity(userEmail.isEmpty ? (focusedField == .email ? 1 : 0) : 1)
            }
            .frame(width: 370 , height: 60, alignment: .leading)
            
            //패스워드 영역
            VStack{
                Text("패스워드")
                    .textFieldStyle(paddingTop: 28, paddingLeading: -165, isFocused: focusedField == .password)
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
                HStack{
                    
                    Image(systemName: "exclamationmark.triangle.fill").font(.caption2)
                    Text("패스워드는 6자리 이상 입력해주세요!")
                        .font(.caption)
                    
                    Spacer()
                }
                .padding(.leading)
                .foregroundColor(isPasswordCount ? .red : .clear)
                .opacity(userPassword.isEmpty ? (focusedField == .password ? 1 : 0) : 1)
            }.frame(width: 370 , height: 60, alignment: .leading)
            
            //패스워드 확인영역
            VStack{
                Text("패스워드 확인")
                    .textFieldStyle(paddingTop: 28, paddingLeading: -165, isFocused: focusedField == .checkingPassword)
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
                        Text("비밀번호가 서로 다릅니다.")
                            .font(.caption)
                    }
                    Spacer()
                }
                .padding(.leading)
                .opacity(checkUserPassword.isEmpty ? (focusedField == .checkingPassword ? 1 : 0) : 1)
                //.foregroundColor(isPasswordUnCorrectError ? .red : .clear)
                .foregroundColor(.red)
            }.frame(width: 370 , height: 60, alignment: .leading)
            //회원가입 버튼
            Button(action: {
                signUp()
            }, label: {
                Text("회원가입").font(.headline)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }).disabled(!checkSignup() ? true : false)
                .frame(width: 280, height: 40)
                .background(checkSignup() ?Color.green :Color.gray)
                .cornerRadius(10)
                .foregroundColor(.white)
                .padding(.top, 40)
            
            Spacer()
            
        }
        .padding()
        .onTapGesture {
            isfocused = false
        }
    }
    
    
    private func signUp() {
        Task {
            //await signUpUser()
            do {
                try await AuthManager.shared.signUp(withEmail: userEmail, password: userPassword, name: userName)
                emailErrorMasage = ""
                showToast = true
                print("회원가입함")
                dismiss()
                
            }   catch {
                emailErrorMasage = "이미 사용중인 이메일 입니다."
                print("회원가입 실패: \(error.localizedDescription)") // 에러 처리
            }
        }
    }
    
    //조건에 맞지 않으면 버튼 비활성화, 즉 고로 이메일 중복 일때 제외하고 잘못된방법으로 회원가입 시도하였을때 회원가입 버튼을 비활성화함으로써 회원가입을 마금
    private func checkSignup() -> Bool {
        if userName.isEmpty || userEmail.isEmpty || userPassword.isEmpty || checkUserPassword.isEmpty || checkUserPassword != userPassword || isEmailForm != true || isPasswordCount {
            return false
        }
        
        return true
    }
    
}

extension CreateAccountView {
    
    private var nameView: some View {
        TextField("", text: $userName)
            .textContentType(.newPassword) // 기존 키체인 제안 방지
            .autocorrectionDisabled(true) // 자동 수정 비활성화
            .textInputAutocapitalization(.never) // 자동 대문자화 비활성화
            .foregroundColor(.black)
            .keyboardType(.emailAddress)
            .autocapitalization(.none)
            .onTapGesture {
                focusedField = .name
            }
            .focused($isfocused)
    }
    
    private var textView: some View {
        TextField("", text: $userEmail)
            .textContentType(.newPassword) // 기존 키체인 제안 방지
            .autocorrectionDisabled(true) // 자동 수정 비활성화
            .textInputAutocapitalization(.never) // 자동 대문자화 비활성화
            .foregroundColor(.black)
            .keyboardType(.emailAddress)
            .autocapitalization(.none)
            .onTapGesture {
                focusedField = .email
            }
            .focused($isfocused)
    }
    
    private var passwordView: some View {
        SecureField("", text: $userPassword)
            .textContentType(.newPassword) // 자동완성 비활성화
            .autocorrectionDisabled(true) // 자동 수정 비활성화
            .textInputAutocapitalization(.never)
            .foregroundColor(.black)
            .onTapGesture {
                focusedField = .password
            }
            .focused($isfocused)
    }
    private var checkPasswordView: some View {
        SecureField("", text: $checkUserPassword)
            .foregroundColor(.black)
            .textContentType(.newPassword) // 기존 키체인 제안 방지
            .autocorrectionDisabled(true) // 자동 수정 비활성화
            .textInputAutocapitalization(.never) // 자동 대문자화 비활성화
            .onTapGesture {
                focusedField = .checkingPassword
            }
            .focused($isfocused)
    }
}

#Preview {
    CreateAccountView(showToast: .constant(true))
}
