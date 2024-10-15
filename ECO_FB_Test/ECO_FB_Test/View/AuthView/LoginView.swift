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
    @State private var isLoggingIn = false // 로그인 중 상태 변수
    @State private var loginErrorMessage: String?
    var body: some View {
        NavigationView {
            
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
                        isLoggingIn = true // 로그인 시작 시 프로그래스 뷰 표시
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
                            isLoggingIn = false // 로그인 처리 완료 후 프로그래스 뷰 숨김
                        }
                    } label: {
                        if isLoggingIn {
                            ProgressView() // 로그인 중일 때 프로그래스 뷰 표시
                                .progressViewStyle(CircularProgressViewStyle(tint: .white)) // 프로그래스 뷰 스타일
                                .frame(maxWidth: .infinity, maxHeight: 10)
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
                    Divider()
                    //구글 공식 로그인버튼 이미지로 대체
                    Button {
                        Task {
                            await AuthManager.shared.login(type: .google)
                            isLoggedIn = true
                        }
                    } label: {
                        Image("googleLogin")
                    }
                    //카카오 공식 버튼 이미지로 대체
                    Button {
                        Task {
                            await AuthManager.shared.login(type: .kakao)
                            isLoggedIn = true
                        }
                    } label: {
                        Image("kakaoLogin")
                    }
                    //비회원 로그인
                    Button{
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
                //회원가입쪽
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
