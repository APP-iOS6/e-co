//
//  MyPageView.swift
//  ECO_FB_Test
//
//  Created by Hwang_Inyoung on 10/14/24.
//

import SwiftUI

struct MyPageView: View {
    @Environment(UserStore.self) private var userStore: UserStore
    @State private var cartItems: Int = UserStore.shared.userData?.cart.count ?? 0
    @State private var orderStatus: String = "처리 중"
    @State private var showLogoutAlert: Bool = false

    var body: some View {
        VStack {
            HeaderView()
            List {
                if let user = userStore.userData {
                    userInfoSection(user: user)
                    accountInfoSection()
                    myProductsSection()
                    if user.isAdmin { adminSection() }
                } else {
                    loginPromptSection()
                }
              
                helpSection()
                
                if userStore.userData != nil {
                    logoutSection()
                }
            }
            .listStyle(.inset)
            .alert("로그아웃 하시겠습니까?", isPresented: $showLogoutAlert) {
                logoutAlertActions()
            } 
        }
    }

    // MARK: - Sections

    @ViewBuilder
    private func userInfoSection(user: User) -> some View {
        Section {
            Text("이름: \(user.name)")
                .font(.headline)
        }
    }

    @ViewBuilder
    private func accountInfoSection() -> some View {
        Section(header: Text("계정 정보")) {
            infoRow(title: "포인트 현황:", value: "\(userStore.userData?.pointCount ?? 0)점")
            NavigationLink("장바구니: \(cartItems)개", destination: CartView())
            NavigationLink("주문 내역: \(orderStatus)", destination: OrderStatusView())
        }
    }

    @ViewBuilder
    private func myProductsSection() -> some View {
        Section(header: Text("나의 상품")) {
            NavigationLink("최근 본 상품", destination: RecentlyViewedView())
        }
    }

    @ViewBuilder
    private func adminSection() -> some View {
        Section(header: Text("관리자")) {
            NavigationLink("상품 추가", destination: AddProductView())
        }
    }

    @ViewBuilder
    private func logoutSection() -> some View {
        Section(header: Text("")) {
            Button("로그아웃") {
                showLogoutAlert = true
            }
            .foregroundColor(.red)
        }
    }

    @ViewBuilder
    private func loginPromptSection() -> some View {
        Section {
            if AuthManager.shared.tryToLoginNow {
                Text("로그인 중...")
            } else {
                NavigationLink("로그인 해주세요", destination: LoginView().environment(AuthManager.shared))
                    .foregroundStyle(.blue)
            }
        }
    }

    @ViewBuilder
    private func helpSection() -> some View {
        Section(header: Text("지원")) {
            NavigationLink("도움이 필요하신가요", destination: HelpView())
        }
    }

    // MARK: - Helper Views

    private func infoRow(title: String, value: String) -> some View {
        HStack {
            Text(title)
            Spacer()
            Text(value).foregroundColor(.green)
        }
    }

    private func logoutAlertActions() -> some View {
        Group {
            Button("로그아웃", role: .destructive) {
                handleLogout()
            }
            Button("취소", role: .cancel) { }
        }
    }

    private func handleLogout() {
        AuthManager.shared.logout()
    }
}

// MARK: - Header View

struct HeaderView: View {
    var body: some View {
        HStack {
            Image(systemName: "leaf.fill")
                .foregroundStyle(.accent)
                .font(.system(size: 20))
            Text("이코")
                .font(.title3)
                .fontWeight(.bold)
        }
        .padding(.top)
    }
}

// MARK: - Placeholder Views

struct OrderStatusView: View { var body: some View { Text("주문 현황") } }
struct AddProductView: View { var body: some View { Text("상품 추가") } }

#Preview {
    NavigationStack {
        MyPageView()
            .environment(UserStore.shared)
    }
}
