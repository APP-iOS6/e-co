//
//  MyPageView.swift
//  ECO_FB_Test
//
//  Created by Hwang_Inyoung on 10/14/24.
//

//
//  MyPageView.swift
//  ECO_FB_Test
//
//  Created by Hwang_Inyoung on 10/14/24.
//

import SwiftUI
import AuthenticationServices

struct MyPageView: View {
    @EnvironmentObject var authManager: AuthManager  // AuthManager를 환경 객체로 받아옴
    @StateObject private var store = NoticeStore() // NoticeStore를 관리
    
    @State private var points: Int = 1200
    @State private var cartItems: Int = 3
    @State private var orderStatus: String = "처리 중"
    
    @State private var showLoginView: Bool = false  // 로그인 화면으로 이동 여부
    
    var body: some View {
        NavigationView {
            List {
                // 로그인 상태일 경우
                if let userName = authManager.loggedInUserName {
                    Section {
                        Text("이름: \(userName)")
                            .font(.headline)
                    }
                    
                    // 포인트 현황, 장바구니, 주문 현황 / 배송 조회
                    Section(header: Text("계정 정보")) {
                        HStack {
                            Text("포인트 현황:")
                            Spacer()
                            Text("\(points)점")
                                .foregroundColor(.green)
                        }
                        
                        NavigationLink("장바구니: \(cartItems)개", destination: CartView())
                        NavigationLink("주문 관리: \(orderStatus)", destination: OrderStatusView())
                    }
                    
                    // 최근 본 상품, 찜한 상품 보기
                    Section(header: Text("나의 상품")) {
                        NavigationLink("최근 본 상품", destination: RecentlyViewedView())
                        NavigationLink("찜한 상품", destination: LikedProductsView())
                    }
                    
                    // 관리자 섹션: 관리자인 경우에만 상품 추가 기능 표시
                    if isAdmin() {
                        Section(header: Text("관리자")) {
                            NavigationLink("상품 추가", destination: AddProductView())
                        }
                    }
                    
                    // 로그아웃 섹션
                    Section(header: Text("로그아웃")) {
                        Button("로그아웃", action: handleLogout)
                            .foregroundColor(.red)
                    }
                    
                } else {
                    // 로그아웃 상태일 때 로그인 안내 메시지
                    Section {
                        Text("로그인 해주세요")
                            .foregroundColor(.blue)
                            .onTapGesture {
                                showLoginView.toggle()  // 로그인 뷰로 이동
                            }
                    }
                }
                
                // 공지사항, 1:1 문의, 상품 문의, 개인정보 고지, 설정
                Section(header: Text("지원")) {
                    NavigationLink("공지사항", destination: NoticeView().environmentObject(store))
                    NavigationLink("1:1 문의", destination: InquiriesView())
                    NavigationLink("상품 문의", destination: ProductQuestionsView())
                    NavigationLink("개인정보 고지", destination: PrivacyPolicyView())
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("마이 페이지")
            .sheet(isPresented: $showLoginView) {
                // 로그인 화면 표시
                LoginView()
            }
        }
    }
    
    // 로그아웃 기능
    func handleLogout() {
        authManager.logout()  // AuthManager의 로그아웃 호출
    }
    
    // 관리자 여부를 확인하는 함수
    func isAdmin() -> Bool {
        if let userName = authManager.loggedInUserName {
            return userName == "admin"  // 관리자로 설정한 경우
        }
        return false
    }
}

// Placeholder Views for Navigation Links
struct CartView: View { var body: some View { Text("장바구니") } }
struct OrderStatusView: View { var body: some View { Text("주문 현황") } }
struct RecentlyViewedView: View { var body: some View { Text("최근 본 상품") } }
struct LikedProductsView: View { var body: some View { Text("찜한 상품") } }
struct AddProductView: View { var body: some View { Text("상품 추가") } }



struct LoginView: View {
    var body: some View {
        Text("로그인 화면")
            .font(.largeTitle)
    }
}

#Preview {
    MyPageView()
        .environmentObject(AuthManager.shared)  // AuthManager 객체 주입
}
