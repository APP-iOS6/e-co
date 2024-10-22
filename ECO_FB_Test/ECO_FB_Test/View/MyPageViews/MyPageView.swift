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
    
    // TODO: 파이어 스토어 데이터 연결하기
    @State private var isCredit: Bool = true
    @State private var isZeroWaste: Bool = true // 친환경 앱이기 때문에 친환경 포장방식을 기본값으로 했습니다.
    @State private var usingPoint: Int = 0
    @State private var productsPrice: Int = 16000
    @State private var requestMessage = "문앞에 놔주세요"
    
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
                    if let user = userStore.userData {
                        LikeView(category: GoodsCategory.none, allGoods: user.arrayGoodsFavorited)
                    }
                } label: {
                    VStack {
                        Image(systemName: "heart")
                            .padding(.bottom, 2)
                        Text("찜목록")
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
                NavigationLink("문의하기", destination: InquiriesView())
                NavigationLink("FAQ", destination: FAQView())
                NavigationLink("개인정보 고지", destination: PrivacyPolicyView())
                NavigationLink("도움말", destination: HealthHelpView())
            }
        }
        .listStyle(.inset)
    }
}

#Preview {
    NavigationStack {
        MyPageView()
            .environment(UserStore.shared)
    }
}
