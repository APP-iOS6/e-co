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
        AppNameView()
        
        VStack {
            HStack {
                NavigationLink {
                    // 로그인 안돼있을땐 LoginView 띄우기
                    // 되어있을땐 유저정보 수정 뷰
                    LoginView()
                        .environment(AuthManager.shared)
                } label: {
                    HStack {
                        Text(userStore.userData?.name ?? "로그인 해주세요")
                            .font(.system(size: 20, weight: .semibold))
                        Image(systemName: "chevron.right")
                    }
                }
                .foregroundStyle(.black)
                
                Spacer()
                
                VStack(alignment: .leading) {
                    Text("보유 포인트")
                        .foregroundStyle(.gray)
                    Text("\(userStore.userData?.pointCount ?? 0)")
                }
            }
            .padding()
            
            Divider()
                .padding(.horizontal)
            
            HStack {
                NavigationLink {
                    OrderStatusView()
                } label: {
                    VStack {
                        Image(systemName: "list.bullet.clipboard")
                            .padding(.bottom, 2)
                        Text("주문관리")
                    }
                }
                Spacer()
                NavigationLink {
                    RecentlyViewedView()
                } label: {
                    VStack {
                        Image(systemName: "doc.text.magnifyingglass")
                            .padding(.bottom, 2)
                        Text("최근 본 상품")
                    }
                }
                Spacer()
                NavigationLink {
                    CartView()
                } label: {
                    VStack {
                        Image(systemName: "bag")
                            .padding(.bottom, 2)
                        Text("장바구니")
                    }
                }
                Spacer()
                NavigationLink {
                    InquiriesView()
                } label: {
                    VStack {
                        Image(systemName: "questionmark.circle")
                            .padding(.bottom, 2)
                        Text("문의하기")
                    }
                }
            }
            .foregroundStyle(Color(uiColor: .darkGray))
            .padding()
            
            Divider()
                .padding(.horizontal)
        }
        
        List {
            Section(header:
                        Text("지원")
                .font(.headline)
                .foregroundColor(.gray)
            ) {
                NavigationLink("공지사항", destination: NoticeView())  // NoticeView로 이동
                NavigationLink("1:1 문의", destination: InquiriesView())
                NavigationLink("상품 문의", destination: ProductQuestionsView())
                NavigationLink("개인정보 고지", destination: PrivacyPolicyView())
            }
            
            // 로그아웃 섹션: 로그인 상태일 경우만 표시
            if userStore.userData != nil {
                Section(header: Text("로그아웃")) {
                    Button("로그아웃") {
                        showLogoutAlert = true // 알림 표시
                    }
                    .foregroundColor(.red)
                }
                .alert("로그아웃", isPresented: $showLogoutAlert, actions: {
//                    NavigationLink {
//                        LoginView()
//                            .environment(AuthManager.shared)
//                    } label: {
                        Button("로그아웃", role: .destructive) {
                            handleLogout()
                        }
//                    }
                    
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
