//
//  MyPageView.swift
//  ECO_FB_Test
//
//  Created by Hwang_Inyoung on 10/14/24.
//

import SwiftUI

struct MyPageView: View {
    @Environment(UserStore.self) private var userStore: UserStore
    
    @State private var showLogoutAlert: Bool = false // 로그아웃 알림 표시 여부
    @State private var navigateToLogin: Bool = false // 로그인 화면으로 이동 여부
    @State private var isNeedLogin: Bool = false
    @State private var isBought: Bool = false
    
    var body: some View {
        AppNameView()
            .padding(.top)
        
        VStack {
            HStack {
                NavigationLink {
                    if userStore.userData == nil {
                        LoginView()
                            .environment(AuthManager.shared)
                    } else {
                        UserInformationView()
                    }
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
                        Text("주문내역")
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
                    CartView(isBought: $isBought)
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
        
        ZStack {
            List {
                Section(header:
                            Text("지원")
                    .font(.headline)
                    .foregroundColor(.gray)
                ) {
                    NavigationLink("공지사항", destination: NoticeView())  // NoticeView로 이동
                    NavigationLink("FAQ", destination: FAQView())
                    NavigationLink("개인정보 고지", destination: PrivacyPolicyView())
                    NavigationLink("도움말", destination: HealthHelpView())
                }
            }
            .listStyle(.inset)
            VStack {
                Spacer()
                SignUpToastView(isVisible: $isBought, message: "물품 구매가 완료되었습니다.")
            }
        }
        
    }
}

#Preview {
    NavigationStack {
        MyPageView()
            .environment(UserStore.shared)
    }
}
