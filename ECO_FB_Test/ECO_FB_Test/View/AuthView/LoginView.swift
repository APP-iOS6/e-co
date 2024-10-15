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
    
    @Environment(AuthManager.self) var authManager: AuthManager
    @State var userEmail: String = ""
    @State var userPassword: String = ""
    @FocusState private var focusedField: Field?
    @AppStorage("isLoggedIn") private var isLoggedIn: Bool = false
    @State private var showCreateAccountPasge = false
    @State private var loginErrorMessage: String?
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Text("이코 E-co")
                        .font(.system(size: 25, weight: .bold))
                    Image(systemName: "leaf.fill")
                }
                .foregroundStyle(.green)
                
                Spacer()
                
                Text("Login")
                    .font(.title)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                // 이메일 입력 필드
                VStack {
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
                    
                    // 패스워드 입력 필드
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
                            .foregroundColor(.red)
                            .padding(.top, 5)
                            .font(.footnote)
                    }
                }
                
                // 로그인 및 소셜 로그인 버튼들
                VStack {
                    Button {
                        Task {
                            do {
                                try await AuthManager.shared.EmailLogin(withEmail: userEmail, password: userPassword)
                                isLoggedIn = true
                                print("로그인 성공")
                                loginErrorMessage = nil
                            } catch {
                                print("로그인 실패: \(error.localizedDescription)")
                                loginErrorMessage = "이메일 또는 패스워드를 확인해주세요"
                            }
                        }
                    } label: {
                        Text("로그인")
                            .frame(maxWidth: .infinity, maxHeight: 10)
                            .padding(.vertical, 18)
                            .foregroundStyle(.white)
                            .font(.headline)
                            .background(Color.green)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    
                    Divider()
                    
                    // 구글 로그인 버튼
                    Button {
                        Task {
                            await AuthManager.shared.login(type: .google)
                            isLoggedIn = true
                        }
                    } label: {
                        Image("googleLogin")
                    }
                    
                    // 카카오 로그인 버튼
                    Button {
                        Task {
                            await AuthManager.shared.login(type: .kakao)
                            isLoggedIn = true
                        }
                    } label: {
                        Image("kakaoLogin")
                    }
                    
                    // 비회원 로그인 버튼
                    Button {
                        Task {
                            do {
                                try await authManager.guestLogin()
                                isLoggedIn = true
                            } catch {
                                print("로그인 실패: \(error.localizedDescription)")
                            }
                        }
                    } label: {
                        Text("비회원으로 로그인")
                            .underline()
                    }
                    .foregroundStyle(Color.green)
                }
                .padding(.top, 40)
                
                Spacer()
                
                // 회원가입 링크
                HStack(alignment: .bottom) {
                    Text("계정이 없으신가요?")
                        .foregroundStyle(.gray)
                    
                    Button("회원가입하러 가기") {
                        showCreateAccountPasge = true
                    }
                    .foregroundStyle(Color.green)
                }
            }
            .padding()
            .sheet(isPresented: $showCreateAccountPasge) {
                CreateAccountView()
            }
        }
    }
}

extension LoginView {
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
}

#Preview {
    LoginView()
        .environment(AuthManager.shared)
}
