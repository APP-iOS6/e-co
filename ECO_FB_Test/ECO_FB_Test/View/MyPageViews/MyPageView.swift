//
//  MyPageView.swift
//  ECO_FB_Test
//
//  Created by Hwang_Inyoung on 10/14/24.
//

import SwiftUI
import AuthenticationServices

struct MyPageView: View {
    
    @StateObject private var store = NoticeStore() // NoticeStore를 관리
    
    @State private var loggedInUser: String? = "admin@example.com"
    @State private var points: Int = 1200
    @State private var cartItems: Int = 3
    @State private var orderStatus: String = "처리 중"
    
    // 관리자 여부를 확인하는 상태 변수
    @State private var isAdmin: Bool = false
    @State private var showLoginView: Bool = false  // 로그인 화면으로 이동 여부
    
    var body: some View {
        NavigationView {
            List {
                // 로그인 상태일 경우
                if let user = loggedInUser {
                    Section {
                        Text("ID: \(user)")
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
                        
                        NavigationLink("주문 관리: \(orderStatus)", destination: OrderStatusView()) // 주문 현황 네비게이션
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
                    NavigationLink("공지사항", destination: NoticeView().environmentObject(store)) // NoticeView에 store 전달
                    NavigationLink("1:1 문의", destination: InquiriesView())
                    NavigationLink("상품 문의", destination: ProductQuestionsView())
                    NavigationLink("개인정보 고지", destination: PrivacyPolicyView())
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("마이 페이지")
            .onAppear {
                // 관리자 여부를 확인하는 로직
                checkIfAdmin()
            }
            .sheet(isPresented: $showLoginView) {
                // 로그인 화면 표시 (여기서는 LoginView를 가정)
                LoginView()
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
        // 실제 구현에서는 사용자 정보를 기반으로 관리자 여부를 확인하는 로직 추가
        if loggedInUser == "admin@example.com" {
            isAdmin = true
        } else {
            isAdmin = false
        }
    }
}

// Placeholder Views for Navigation Links
struct CartView: View { var body: some View { Text("장바구니") } }
struct OrderStatusView: View { var body: some View { Text("주문 현황") } } // 주문 현황 뷰
struct RecentlyViewedView: View { var body: some View { Text("최근 본 상품") } }
struct LikedProductsView: View { var body: some View { Text("찜한 상품") } }
struct AddProductView: View { var body: some View { Text("상품 추가") } }

struct InquiriesView: View { var body: some View { Text("1:1 문의") } }
struct ProductQuestionsView: View { var body: some View { Text("상품 문의") } }
struct PrivacyPolicyView: View { var body: some View { Text("개인정보 고지") } }

// Placeholder for LoginView
struct LoginView: View {
    var body: some View {
        Text("로그인 화면")
            .font(.largeTitle)
    }
}

#Preview {
    MyPageView()
}
