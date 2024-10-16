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
    
    var body: some View {
            VStack{
                HStack{
                    Text("이코 E-co")
                        .font(.system(size: 25, weight: .bold))
                    Image(systemName: "leaf.fill")
                }
                Spacer()
                Text("Login")
                    .font(.title)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                //이메일영역
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
                            .font(.footnote)
                    }
                }
                
                VStack{
                    Button {
                        Task {
                            do {
                                try await AuthManager.shared.EmailLogin(withEmail: userEmail, password: userPassword)
                                print("로그인 성공")
                                loginErrorMessage = nil
//                                goMainView = true
                                dismiss()
                            } catch {
                                print("로그인 실패: \(error.localizedDescription)")
                                loginErrorMessage = "이메일 또는 패스워드를 확인해주세요"
                            }
                        }
                    } label: {
                        if authManager.tryToLoginNow {
                            ProgressView() // 로그인 중일 때 프로그래스 뷰 표시
                                .progressViewStyle(CircularProgressViewStyle(tint: .white)) // 프로그래스 뷰 스타일
                                .frame(maxWidth: .infinity, maxHeight: 30)
                                .padding(.vertical, 18)
                                .background(Color.green)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        } else {
                            Text("로그인") // 로그인 중이 아닐 때 텍스트 표시
                                .frame(maxWidth: .infinity, maxHeight: 10)
                                .padding(.vertical, 18)
                                .foregroundStyle(.white)
                                .font(.headline)
                                .background(Color.green)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                    }
                    .disabled(authManager.tryToLoginNow)
                    
                    Divider()
                    //구글 공식 로그인버튼 이미지로 대체
                    Button {
                        Task {
                            await AuthManager.shared.login(type: .google)
//                            goMainView = true
                            dismiss()
                        }
                    } label: {
                        Image("googleLogin")
                        
                    }
                    .disabled(authManager.tryToLoginNow)
                    
                    //카카오 공식 버튼 이미지로 대체
                    Button {
                        Task {
                            await AuthManager.shared.login(type: .kakao)
//                            goMainView = true
                            dismiss()
                        }
                    } label: {
                        Image("kakaoLogin")
                    }
                    .disabled(authManager.tryToLoginNow)
                    
                    //비회원 로그인
                    Button{
                        Task {
                            do {
                                try await authManager.guestLogin()
//                                goMainView = true
                                dismiss()
                            } catch {
                                print("로그인 실패: \(error.localizedDescription)")
                            }
                        }
                    } label: {
                        Text("비회원으로 로그인")
                            .underline()
                    }
                    .foregroundStyle(Color.green)
                    .disabled(authManager.tryToLoginNow)
                }
                .padding(.top, 40)
                
                Spacer()
                //회원가입쪽
                HStack(alignment: .bottom) {
                    Text("계정이 없으신가요?")
                        .foregroundStyle(.gray)
                    
                    Button("회원가입하러 가기") {
                        showCreateAccountPage = true
                    }
                    .foregroundStyle(Color.green)
                }
            }
            .padding()
            .sheet(isPresented: $showCreateAccountPage) {
                CreateAccountView()
                
            }
//            .navigationDestination(isPresented: $goMainView, destination: {
//                ContentView()
//                    .navigationBarBackButtonHidden()
//            })
            .navigationBarBackButtonHidden()
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
