//
//  MyPageView.swift
//  ECO_FB_Test
//
//  Created by Hwang_Inyoung on 10/14/24.
//

import SwiftUI
import AuthenticationServices

struct MyPageView: View {
    
    @State private var loggedInUser: String? = "admin@example.com"
    @State private var points: Int = 1200
    @State private var cartItems: Int = 3
    @State private var orderStatus: String = "처리 중"
    
    // 관리자 여부를 확인하는 상태 변수
    @State private var isAdmin: Bool = false
    
    var body: some View {
        NavigationView {
            List {
                // 로그인 된 아이디 표시
                if let user = loggedInUser {
                    Section {
                        Text("로그인된 사용자: \(user)")
                            .font(.headline)
                    }
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
                    
                    HStack {
                        Text("주문 현황:")
                        Spacer()
                        Text(orderStatus)
                    }
                    
                    // 결제 취소, 교환, 반품
                    NavigationLink("주문 관리", destination: OrderManagementView())
                }
                
                // 최근 본 상품, 찜한 상품 보기
                Section(header: Text("나의 상품")) {
                    NavigationLink("최근 본 상품", destination: RecentlyViewedView())
                    NavigationLink("찜한 상품", destination: LikedProductsView())
                }
                
                // 관리자 섹션: 관리자인 경우에만 상품 추가 기능 표시
                if isAdmin {
                    Section(header: Text("관리자")) {
                        NavigationLink("상품 추가", destination: AddProductView())
                    }
                }
                
                // 공지사항, 1:1 문의, 상품 문의, 개인정보 고지, 설정, 로그아웃
                Section(header: Text("지원")) {
                    NavigationLink("공지사항", destination: NoticesView())
                    NavigationLink("1:1 문의", destination: InquiriesView())
                    NavigationLink("상품 문의", destination: ProductQuestionsView())
                    NavigationLink("개인정보 고지", destination: PrivacyPolicyView())
                    NavigationLink("설정", destination: SettingsView())
                    Button("로그아웃", action: handleLogout)
                        .foregroundColor(.red)
                }
            }
            .navigationTitle("마이 페이지")
            .onAppear {
                // 여기에서 관리자 여부를 확인하는 로직을 추가
                checkIfAdmin()
            }
        }
    }
    
    // 로그아웃 기능
    func handleLogout() {
        // 로그아웃 처리 로직 (예: Firebase Authentication 로그아웃)
        loggedInUser = nil
        isAdmin = false
    }
    
    // 관리자 여부를 확인하는 함수
    func checkIfAdmin() {
        // 실제 구현에서는 사용자 정보를 기반으로 관리자 여부를 확인하는 로직을 추가
        // 예: Firebase에서 role 필드를 확인하거나, 사용자 이메일을 체크
        if loggedInUser == "admin@example.com" {
            isAdmin = true
        } else {
            isAdmin = false
        }
    }
}

// Placeholder Views for Navigation Links
struct CartView: View { var body: some View { Text("장바구니") } }
struct OrderManagementView: View { var body: some View { Text("주문 관리") } }
struct RecentlyViewedView: View { var body: some View { Text("최근 본 상품") } }
struct LikedProductsView: View { var body: some View { Text("찜한 상품") } }
struct AddProductView: View { var body: some View { Text("상품 추가") } }
struct NoticesView: View { var body: some View { Text("공지사항") } }
struct InquiriesView: View { var body: some View { Text("1:1 문의") } }
struct ProductQuestionsView: View { var body: some View { Text("상품 문의") } }
struct PrivacyPolicyView: View { var body: some View { Text("개인정보 고지") } }
struct SettingsView: View { var body: some View { Text("설정") } }

#Preview {
    MyPageView()
}
