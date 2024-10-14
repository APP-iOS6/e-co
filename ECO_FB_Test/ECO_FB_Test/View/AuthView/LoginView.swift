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
    
    @State private var showCreateAccountPasge = false
    
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
            }
            
            VStack{
                Button {
                    //일반 로그인
                } label: {
                    Text("로그인")
                        .frame(maxWidth: .infinity, maxHeight: 10)
                        .padding(.vertical, 18)
                        .foregroundStyle(.black)
                        .font(.headline)
                        .background(Color.blue)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                Button {
                    Task {
                        await AuthManager.shared.login(type: .google)
                    }
                } label: {
                    Text("구글아이디로 로그인")
                        .frame(maxWidth: .infinity, maxHeight: 10)
                        .padding(.vertical, 18)
                        .foregroundStyle(.black)
                        .font(.headline)
                        .background(Color.blue)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                
                Button {
                    Task {
                        await AuthManager.shared.login(type: .kakao)
                    }
                } label: {
                    Text("카카오톡아이디로 로그인")
                        .frame(maxWidth: .infinity, maxHeight: 10)
                        .padding(.vertical, 18)
                        .foregroundStyle(.black)
                        .font(.headline)
                        .background(Color.blue)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                Button{
                    
                } label: {
                    Text("비회원으로 로그인")
                        .underline()
                }
            }
            .padding(.top, 10)
            
            Spacer()
            
            HStack(alignment: .bottom) {
                Text("계정이 없으신가요?")
                    .foregroundStyle(.gray)
                
                Button("회원가입하러 가기") {
                    showCreateAccountPasge = true
                }
            }
        }
        .padding()
        .sheet(isPresented: $showCreateAccountPasge) {
            CreateAccountView()
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
