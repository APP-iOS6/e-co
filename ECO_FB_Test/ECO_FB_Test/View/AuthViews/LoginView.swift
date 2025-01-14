//
//  LoginView.swift
//  ECO_FB_Test
//
//  Created by wonhoKim on 10/14/24.
//

import SwiftUI

struct LoginView: View {
    
    enum Field {
        case email
        case password
        case checkingPassword
        case name
    }
    
    @Environment(\.dismiss) var dismiss
    @Environment(AuthManager.self) var authManager: AuthManager
    @State var userEmail: String = ""
    @State var userPassword: String = ""
    @FocusState private var focusedField: Field?
    @State private var showCreateAccountPage = false
    @State private var goMainView: Bool = false
    @State private var loginErrorMessage: String?
    @State private var showToast = false
    @FocusState private var isfocused: Bool // 여기는 키보드 내리는거 위해
    
    var body: some View {
        ZStack {
            VStack {
                Spacer()
                AppNameView()
                    .frame(width: 125 ,alignment: .center)
                
                Spacer()
                Text("Login")
                    .font(.title)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                //이메일영역
                VStack(){
                    Text("이메일")
                        .textFieldStyle(paddingTop: 10, paddingLeading: -165, isFocused: focusedField == .email)
                    HStack(spacing: -10){
                        Image(systemName: "at")
                        UnderlineTextFieldView(
                            text: $userEmail,
                            textFieldView: textView,
                            placeholder: "이메일",
                            isFocused: focusedField == .email
                        )
                        .focused($focusedField, equals: .email)
                    }
                    //패스워드 영역
                    Text("패스워드")
                        .textFieldStyle(paddingTop: 20, paddingLeading: -165, isFocused: focusedField == .password)
                    HStack(spacing: -10){
                        Image(systemName: "lock")
                        UnderlineTextFieldView(
                            text: $userPassword,
                            textFieldView: passwordView,
                            placeholder: "패스워드",
                            isFocused: focusedField == .password
                        )
                        .focused($focusedField, equals: .password)
                    }
                    if let message = loginErrorMessage {
                        Text(message)
                            .foregroundColor(.red) // 빨간색 텍스트
                            .padding(.top, 5)
                    }
                }
                .padding(.horizontal)
                .padding(.top, -10)
                
                VStack{
                    Button {
                        Login(with: .email)
                    } label: {
                        if authManager.tryToLoginNow {
                            ProgressView() // 로그인 중일 때 프로그래스 뷰 표시
                                .progressViewStyle(CircularProgressViewStyle(tint: .white)) // 프로그래스 뷰 스타일
                                .frame(maxWidth: 190, maxHeight: 10)
                                .padding(.vertical, 18)
                                .background(Color.green)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        } else {
                            Text("로그인") // 로그인 중이 아닐 때 텍스트 표시
                                .frame(maxWidth: 190, maxHeight: 10)
                                .padding(.vertical, 18)
                                .foregroundStyle(.white)
                                .font(.headline)
                                .background(Color.green)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                    }
                    .disabled(authManager.tryToLoginNow)
                    
                    TextDivider(text: "or")
                    //구글 공식 로그인버튼 이미지로 대체
                    Button {
                        Login(with: .google)
                    } label: {
                        Image("googleLogin2")
                        
                    }
                    .disabled(authManager.tryToLoginNow)
                    
                    //카카오 공식 버튼 이미지로 대체
                    Button {
                        Login(with: .kakao)
                    } label: {
                        Image("kakaoLogin")
                    }
                    .disabled(authManager.tryToLoginNow)
                    
                }
                .padding(.top, 40)
                
                
                Spacer()
                //회원가입쪽
                
                HStack(alignment: .bottom) {
                    Text("계정이 없으신가요?")
                        .foregroundStyle(.gray)
                        .frame(height: 30)
                    
                    Button("회원가입하러 가기") {
                        showCreateAccountPage = true
                    }
                    .frame(height: 30)
                    .foregroundStyle(Color.green)
                }
            }
            .padding()
            .sheet(isPresented: $showCreateAccountPage) {
                CreateAccountView(showToast: $showToast)
            }
            .onTapGesture {
                isfocused = false
            }
            
            SignUpToastView(isVisible: $showToast, message: "회원가입에 성공하셨습니다")
                .padding([.horizontal, .bottom])
        }
        
    }
    
    private func Login(with type: LoginType) {
        Task {
            if type == .email {
                do {
                    try await AuthManager.shared.login(type: .email, parameter: .email(email: userEmail, password: userPassword))
                    print("로그인 성공")
                    loginErrorMessage = nil
                    dismiss()
                } catch {
                    print("로그인 실패: \(error.localizedDescription)")
                    loginErrorMessage = "이메일 또는 패스워드를 확인해주세요"
                }
            } else {
                try await AuthManager.shared.login(type: type)
                dismiss()
            }
            
        }
        
    }
}

extension LoginView {
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
            .textContentType(.newPassword) // 기존 키체인 제안 방지
            .autocorrectionDisabled(true) // 자동 수정 비활성화
            .textInputAutocapitalization(.never) // 자동 대문자화 비활성화
            .textInputAutocapitalization(.never)
            .foregroundColor(.black)
            .onTapGesture {
                focusedField = .password
            }
            .focused($isfocused)
    }
}

#Preview {
    LoginView()
        .environment(AuthManager.shared)
}
