//
//  ContentView.swift
//  ECO_FB_Test
//
//  Created by Jaemin Hong on 10/11/24.
//

import SwiftUI

struct UserTestView: View {
    @Environment(UserStore.self) private var userStore: UserStore
    @Environment(AuthManager.self) private var authManager: AuthManager
    @Environment(DataManager.self) private var dataManager: DataManager
    @State private var goods: [Goods] = []
    @State private var dataFetchFlow: DataFlow = .none
    
    var body: some View {
        VStack {
            Button("Log Out") {
                AuthManager.shared.logout()
            }
            
            Button("Google Login") {
                Task {
                    try await AuthManager.shared.login(type: .google)
                }
            }
            .buttonStyle(.bordered)
            
            Button("KaKao Login") {
                Task {
                    try await AuthManager.shared.login(type: .kakao)
                }
            }
            .buttonStyle(.bordered)
            
            Button("상품 더미 추가") {
                let seller: User = User(id: UUID().uuidString, loginMethod: LoginMethod.google.rawValue, isSeller: true, name: "hi", profileImageURL: URL(string: "https://firebasestorage.googleapis.com/v0/b/e-co-4f9aa.appspot.com/o/user%2Fdefault_profile.png?alt=media&token=afe3a2fd-d85b-49c8-8d4d-dcf773e928ef")!, pointCount: 0, cart: [], goodsRecentWatched: [], goodsFavorited: [])
                let price = Int.random(in: 100...15000)
                
                let goodsDummy: Goods = Goods(id: UUID().uuidString, name: "Dummy Goods", category: .passion, thumbnailImageURL: URL(string: "https://png.pngtree.com/png-vector/20190704/ourmid/pngtree-leaf-graphic-icon-design-template-vector-illustration-png-image_1538440.jpg")!, bodyContent: "it's bag it's bag it's bag it's bag it's bag it's bag it's bag", bodyImageNames: ["test.png", "bag.png", "bag23232.png", "bag_final.png"], price: price, seller: seller)
                
                goods.append(goodsDummy)
                
                Task {
                    _ = try await DataManager.shared.updateData(type: .goods, parameter: .goodsUpdate(id: goodsDummy.id, goods: goodsDummy))
                }
            }
            
            if let emailError = authManager.emailExistErrorMessage {
                Text(emailError)
                    .font(.title)
                    .fontWeight(.bold)
            }
            
            if var user = userStore.userData {
                Button("현재까지 생성된 상품 더미 장바구니에 담기") {
                    for goods in goods {
                        let cartElement = CartElement(id: UUID().uuidString, goods: goods, goodsCount: 1)
                        user.cart.insert(cartElement)
                    }
                    Task {
                        _ = try await DataManager.shared.updateData(type: .user, parameter: .userUpdate(id: user.id, user: user))
                    }
                }
                
                VStack(spacing: 10) {
                    Group {
                        Text("id: \(user.id)")
                        Text("login method: \(user.loginMethod)")
                        Text("is admin: \(user.isSeller)")
                        Text("name: \(user.name)")
                        Text("profile image name: \(user.profileImageURL)")
                        Text("point count: \(user.pointCount)")
                    }
                    .font(.title2)
                    
                    ScrollView {
                        LazyVStack(spacing: 10) {
                            ForEach(user.arrayCart) { element in
                                GroupBox {
                                    Text("썸네일: \(element.goods.thumbnailImageURL)")
                                    Text("상품이름: \(element.goods.name)")
                                    Text("가격: \(element.goods.formattedPrice)")
                                    Text("판매자: \(element.goods.seller.name)")
                                    Text("카테고리: \(element.goods.category)")
                                    Text("본문: \(element.goods.bodyContent)")
                                    Text("본문사진: \(element.goods.bodyImageNames)")
                                }
                            }
                        }
                    }
                    .font(.title2)
                    .refreshable {
                        Task {
                            _ = try await DataManager.shared.fetchData(type: .user, parameter: .userLoad(id: user.id, shouldReturnUser: false))
                        }
                    }
                }
            }
            
            if dataFetchFlow == .loading {
                Text("데이터 로딩중...")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                ProgressView()
            }
        }
    }
}

#Preview {
    UserTestView()
        .environment(UserStore.shared)
        .environment(AuthManager.shared)
        .environment(DataManager.shared)
}
