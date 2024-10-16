//
//  MyPageView.swift
//  ECO_FB_Test
//
//  Created by Hwang_Inyoung on 10/14/24.
//

import SwiftUI

struct MyPageView: View {
    @Environment(UserStore.self) private var userStore: UserStore
    
    @State private var cartItems: Int = 3
    @State private var orderStatus: String = "처리 중"
    @State private var showLogoutAlert: Bool = false // 로그아웃 알림 표시 여부
    @State private var navigateToLogin: Bool = false // 로그인 화면으로 이동 여부
    @State private var isNeedLogin: Bool = false 
    var body: some View {
        HStack {
            Text("이코")
                .font(.system(size: 25, weight: .bold))
            Image(systemName: "leaf.fill")
            Spacer()
        }
        .foregroundStyle(.green)
        .padding([.leading, .top])
        
        List {
            
            // 로그인 상태일 경우
            if let user = userStore.userData {
                Section {
                    Text("이름: \(user.name)")
                        .font(.headline)
                }
                
                // 포인트 현황, 장바구니, 주문 현황 / 배송 조회
                Section(header: Text("계정 정보")) {
                    HStack {
                        Text("포인트 현황:")
                        Spacer()
                        Text("\(user.pointCount)점")
                            .foregroundColor(.green)
                    }
                    
                    NavigationLink("장바구니: \(cartItems)개", destination: CartView())
                    NavigationLink("주문 관리: \(orderStatus)", destination: OrderStatusView())
                }
                
                // 최근 본 상품, 찜한 상품 보기
                Section(header: Text("나의 상품")) {
                    NavigationLink("최근 본 상품", destination: RecentlyViewedView())
                }
                
                // 관리자 섹션: 관리자인 경우에만 상품 추가 기능 표시
                if user.isAdmin {
                    Section(header: Text("관리자")) {
                        NavigationLink("상품 추가", destination: AddProductView())
                    }
                }
            } else {
                Section {
                    if AuthManager.shared.tryToLoginNow {
                        Text("로그인 중...")
                    } else {
//                        NavigationLink {
//                            LoginView()
//                                .environment(AuthManager.shared)
                        Button {
                            isNeedLogin = true
                        } label: {
                            Text("로그인 해주세요")
                                .foregroundStyle(.blue)
                        }
                        .fullScreenCover(isPresented: $isNeedLogin) {
                            LoginView()
                        }
                    }
                }
            }
            
            // 공지사항, 1:1 문의, 상품 문의, 개인정보 고지, 설정
            Section(header: Text("지원")) {
                NavigationLink("도움이 필요하신가요", destination: HelpView())
            }
        }
        .listStyle(.inset)
        .alert("로그아웃", isPresented: $showLogoutAlert, actions: {
                Button("로그아웃", role: .destructive) {
                    handleLogout()
                }
        })
            
            // 로그아웃 섹션: 로그인 상태일 경우만 표시
            if userStore.userData != nil {
                Section(header: Text("로그아웃")) {
                    Button("로그아웃") {
                        showLogoutAlert = true // 알림 표시
                    }
                    .foregroundColor(.red)
                }
                .alert("로그아웃", isPresented: $showLogoutAlert, actions: {
                    NavigationLink {
                        LoginView()
                            .environment(AuthManager.shared)
                    } label: {
                        Button("로그아웃", role: .destructive) {
                            handleLogout()
                        }
                    }
                    
                    Button("취소", role: .cancel) { }
                }, message: {
                    Text("로그아웃 하시겠습니까?")
                })
            }
        }
        .listStyle(.inset)
    }
    
    func handleLogout() {
        AuthManager.shared.logout()
    }
}


struct OrderStatusView: View { var body: some View { Text("주문 현황") } }
struct AddProductView: View { var body: some View { Text("상품 추가") } }

#Preview {
    NavigationStack {
        MyPageView()
            .environment(UserStore.shared)
    }
}
