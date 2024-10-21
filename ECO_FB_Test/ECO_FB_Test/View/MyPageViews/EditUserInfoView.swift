//
//  EditUserInfoView.swift
//  ECO_FB_Test
//
//  Created by Hwang_Inyoung on 10/21/24.
//

import SwiftUI
import FirebaseAuth

struct EditUserInfoView: View {
    @Environment(UserStore.self) private var userStore: UserStore
    @Environment(\.dismiss) private var dismiss
    @State private var newPassword: String = ""
    @State private var confirmPassword: String = ""
    
    // 상태 관리를 위한 변수들
    @State private var passwordTooShort: Bool = false
    @State private var passwordMismatch: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("회원정보 수정")
                .font(.title)
                .fontWeight(.bold)
                .padding(.vertical)

            // 이름 섹션
            HStack {
                Text("이름")
                Spacer()
                Text(userStore.userData?.name ?? "알 수 없음")
            }
            .padding(.top, 10)

            // 이메일 섹션
            HStack {
                Text("이메일")
                Spacer()
                Text(userStore.userData?.id ?? "알 수 없음")
            }
            .padding(.vertical, 10)

            Divider() // 이메일 아래 디바이더

            // 비밀번호 변경 섹션
            Text("비밀번호 변경")
                .font(.headline)

            passwordInputSection(
                title: "새 비밀번호 입력",
                text: $newPassword
            )

            passwordInputSection(
                title: "비밀번호 확인",
                text: $confirmPassword
            )

            if passwordTooShort {
                warningMessage("비밀번호는 6자리 이상 입력해주세요!")
            }

            if passwordMismatch {
                warningMessage("비밀번호가 일치하지 않습니다.")
            }
            
            // 비밀번호 변경 저장 버튼
            Button(action: {
                Task {
                    try await updatePassword(newPassword)
                    dismiss()
                }
            }) {
                Text("비밀번호 변경 저장")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(.accent)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .disabled(passwordTooShort || passwordMismatch)
            .padding(.top, 10)
            
            Divider() // 회원탈퇴 섹션 위의 디바이더

            // 회원탈퇴 섹션
            Text("회원탈퇴")
                .font(.headline)
            
            Button(action: {
                // 회원탈퇴 로직 추가 예정
            }) {
                Text("회원탈퇴")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(.gray)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.top, 10)
            
            Spacer()
        }
        .padding()
        .onChange(of: newPassword) { _ in validatePasswords() }
        .onChange(of: confirmPassword) { _ in validatePasswords() }
    }

    // 비밀번호 입력 필드 섹션
    private func passwordInputSection(title: String, text: Binding<String>) -> some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)

            HStack(spacing: 10) {
                Image(systemName: "lock")
                    .foregroundColor(.gray)

                SecureField(title, text: text)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.vertical, 5)
            }
        }
    }

    // 경고 메시지 뷰
    private func warningMessage(_ message: String) -> some View {
        HStack {
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundColor(.red)
            Text(message)
                .foregroundColor(.red)
                .font(.caption)
        }
        .padding(.leading)
    }

    // 비밀번호 유효성 검사
    private func validatePasswords() {
        passwordTooShort = newPassword.count < 6
        passwordMismatch = newPassword != confirmPassword
    }

    private func updatePassword(_ newPassword: String) async throws {
        try await Auth.auth().currentUser?.updatePassword(to: newPassword)
    }
}
