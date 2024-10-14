//
//  ContentView.swift
//  ECO_FB_Test
//
//  Created by Jaemin Hong on 10/11/24.
//

import SwiftUI

struct UserTestView: View {
    @EnvironmentObject private var userStore: UserStore
    @StateObject private var dataManager = DataManager.shared
    @StateObject private var authManager = AuthManager.shared
    @State private var goods: [Goods] = []
    
    var body: some View {
        VStack {
            Button("Log Out") {
                AuthManager.shared.logout()
            }
            
            Button("Google Login") {
                Task {
                    await AuthManager.shared.login(type: .google)
                }
            }
            .buttonStyle(.bordered)
            
            Button("KaKao Login") {
                Task {
                    await AuthManager.shared.login(type: .kakao)
                }
            }
            .buttonStyle(.bordered)
            
            Button("상품 더미 추가") {
                let seller: Seller = Seller(id: "Q6awSoN6OCHcbUDeMxyd", name: "Seller", profileImageName: "It will be replace to id matches seller")
                let price = Int.random(in: 100...15000)
                
                let goodsDummy: Goods = Goods(id: UUID().uuidString, name: "Dummy Goods", category: .passion, thumbnailImageName: "test.png", bodyContent: "it's bag it's bag it's bag it's bag it's bag it's bag it's bag", bodyImageNames: ["test.png", "bag.png", "bag23232.png", "bag_final.png"], price: price, seller: seller)
                
                goods.append(goodsDummy)
                
                Task {
                    await DataManager.shared.updateData(type: .goods, parameter: .goodsUpdate(id: goodsDummy.id, goods: goodsDummy))
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
                        user.cart.insert(goods)
                    }
                    
                    Task {
                        await DataManager.shared.updateData(type: .user, parameter: .userUpdate(id: user.id, user: user))
                    }
                }
                
                VStack(spacing: 10) {
                    Group {
                        Text("id: \(user.id)")
                        Text("login method: \(user.loginMethod)")
                        Text("name: \(user.name)")
                        Text("profile image name: \(user.profileImageName)")
                        Text("point count: \(user.pointCount)")
                    }
                    .font(.title2)
                    
                    ScrollView {
                        LazyVStack(spacing: 10) {
                            ForEach(user.arrayCart) { goods in
                                GroupBox {
                                    Text("썸네일: \(goods.thumbnailImageName)")
                                    Text("상품이름: \(goods.name)")
                                    Text("가격: \(goods.formattedPrice)")
                                    Text("판매자: \(goods.seller.name)")
                                    Text("카테고리: \(goods.category)")
                                    Text("본문: \(goods.bodyContent)")
                                    Text("본문사진: \(goods.bodyImageNames)")
                                }
                            }
                        }
                    }
                    .font(.title2)
                    .refreshable {
                        Task {
                            await DataManager.shared.fetchData(type: .user, parameter: .userLoad(id: user.id))
                        }
                    }
                }
            }
            
            if dataManager.dataFetchFlow == .loading {
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
        .environmentObject(UserStore.shared)
}
