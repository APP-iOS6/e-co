//
//  UserInformationView.swift
//  ECO_FB_Test
//
//  Created by 이소영 on 10/17/24.
//

import SwiftUI
import NukeUI

struct UserInformationView: View {

    @State private var showReauthAlert: Bool = false
    @State private var showEditView: Bool = false
    @State private var passwordInput: String = ""
    @State private var showToast: Bool = false // 토스트 표시 여부

    @State private var showLogoutAlert: Bool = false // 로그아웃 알림 표시 여부
    @State private var showDeleteAlert:Bool = false  // 회원탈퇴 알림 표시 여부

    @Environment(\.dismiss) var dismiss
    @Environment(UserStore.self) private var userStore: UserStore

    var body: some View {
        VStack(alignment: .leading) {
            if let user = userStore.userData {
                userInfoSection(user: user)
                Divider()
                memberInfoSection(user: user)
                Divider()
                shippingInfoSection()
            } else {
                Text("사용자 정보를 불러오는 중입니다...")
                    .font(.headline)
                    .padding()
                Spacer()
            }

            Spacer()

            logoutButton()
        }
        .padding()
        .navigationTitle("회원 정보")
        .navigationBarTitleDisplayMode(.inline)
        .alert("비밀번호 재인증", isPresented: $showReauthAlert) {
            SecureField("비밀번호", text: $passwordInput)
            Button("확인", action: reauthenticateAndProceed)
            Button("취소", role: .cancel) { }
        } message: {
            Text("회원정보 수정을 위해 비밀번호를 입력해주세요.")
        }
        .sheet(isPresented: $showEditView) {
            EditUserInfoView()
        }
        .overlay(toastView(), alignment: .bottom) // 토스트 오버레이 추가
        .animation(.easeInOut, value: showToast) // 애니메이션 적용
    }

    private func userInfoSection(user: User) -> some View {
        HStack(alignment: .center, spacing: 10) {
            LazyImage(url: user.profileImageURL) { state in
                if let image = state.image {
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50, height: 50)
                        .background(Color(uiColor: .lightGray), in: Circle())
                } else {
                    ProgressView()
                }
            }
            Text(user.name)
                .font(.title2)
                .fontWeight(.semibold)
            Spacer()
        }
        .padding(.bottom)
    }

    private func memberInfoSection(user: User) -> some View {
        VStack(alignment: .leading) {
            sectionHeader(title: "회원정보", buttonTitle: "회원정보 수정") {
                showReauthAlert = true
            }

            HStack {
                VStack(alignment: .leading, spacing: 15) {
                    Text("이름")
                    Text("이메일")
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 15) {
                    Text(user.name)
                    Text(user.id)
                }
            }
            .font(.system(size: 17))
            .foregroundStyle(Color(uiColor: .darkGray))
            .padding(.vertical)
        }
    }

    private func shippingInfoSection() -> some View {
        VStack(alignment: .leading) {
            sectionHeader(title: "배송지정보", buttonTitle: "배송지 수정") {
                // 배송지 수정 로직 추가 예정
            }

            HStack {
                VStack(alignment: .leading, spacing: 15) {
                    Text("수령인")
                    Text("주소")
                    Text("연락처")
                }
                .font(.system(size: 17))
                .foregroundStyle(Color(uiColor: .darkGray))
                .padding(.vertical)
                Spacer()
                VStack(alignment: .trailing, spacing: 15) {
                    Text("김민수") // 예시
                    Text("서울시 강남구 역삼동 12-1")
                    Text("010-1234-5678") // 예시 번호
                }
            }
        }
    }

    private func logoutButton() -> some View {
        HStack {
            Spacer()
            Button {
                showLogoutAlert = true
            } label: {
                Text("로그아웃")
                    .foregroundColor(.red)
            }
            .alert("로그아웃", isPresented: $showLogoutAlert) {
                Button("로그아웃", role: .destructive) {
                    AuthManager.shared.logout()
                    dismiss()
                }
                Button("취소", role: .cancel) { }
            } message: {
                Text("로그아웃 하시겠습니까?")
            }
            Spacer()
        }
    }

    private func reauthenticateAndProceed() {
        EmailLoginManager.shared.reauthenticateUser(password: passwordInput) { result in
            switch result {
            case .success:
                showEditView = true
            case .failure:
                showToastMessage("비밀번호가 틀렸습니다. 다시 입력해주세요.")
            }
        }
    }

    // 토스트 메시지 표시 함수
    private func showToastMessage(_ message: String) {
        showToast = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            showToast = false
        }
    }

    // 토스트 메시지 뷰
    private func toastView() -> some View {
        Group {
            if showToast {
                Text("비밀번호가 틀렸습니다. 다시 입력해주세요.")
                    .foregroundColor(.black)
                    .padding()
                    .background(Color.gray.opacity(0.5))
                    .cornerRadius(8)
                    .shadow(radius: 10)
                    .padding(.bottom, 50)
            }
        }
    }

    private func sectionHeader(title: String, buttonTitle: String, action: @escaping () -> Void) -> some View {
        HStack {
            Text(title)
                .font(.system(size: 14))
                .padding(.vertical, 5)
                .foregroundStyle(Color(uiColor: .darkGray))

            Spacer()

            Button(action: action) {
                HStack {
                    Text(buttonTitle)
                    Image(systemName: "chevron.right")
                }
                .foregroundStyle(.black)
            }
            .bold()
        }
        .padding()
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    showDeleteAlert.toggle()
                } label : {
                    Text("회원 탈퇴")
                        .foregroundStyle(.red)
                }
                .alert("회원 탈퇴", isPresented: $showDeleteAlert, actions: {
                    Button("탈퇴 하기", role: .destructive) {
                        Task{
                            // User컬렉션의 user삭제
                            try await UserStore.shared.deleteUserData()
                            // Autentication의 계정 삭제
                            try AuthManager.shared.deleteUser()
                            AuthManager.shared.logout()
                        }
                        dismiss()
                    }
                    Button("취소", role: .cancel) { }
                }, message: {
                    Text("정말 계정을 탈퇴하시겠습니까?")
                })
            }
        }
    }
}
