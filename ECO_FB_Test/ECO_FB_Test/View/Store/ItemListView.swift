//
//  ItemListView.swift
//  ECO_FB_Test
//
//  Created by 이소영 on 10/17/24.
//

import SwiftUI
import Nuke
import NukeUI

struct ItemListView: View {
    @Environment(UserStore.self) private var userStore: UserStore
    var category: GoodsCategory
    var allGoods: [Goods]
    var gridItems: [GridItem] = [
        GridItem(),
        GridItem()
    ]
    @Binding var dataUpdateFlow: DataFlow
    @Binding var isNeedLogin: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(category.rawValue)
                    .font(.system(size: 20, weight: .semibold))
                Spacer()
                
                NavigationLink(destination: AllGoodsOfCategoryView(category: category, allGoods: allGoods).environment(GoodsStore.shared)) {
                    HStack {
                        Text("더보기")
                        Image(systemName: "chevron.right")
                    }
                    .foregroundStyle(.black)
                }
                .bold()
            }
            .font(.footnote)
            .padding(.top)
            Divider()
        }
        .padding(.horizontal)
        
        LazyVGrid(columns: gridItems) {
            ForEach(0 ..< 4) { index in
                if allGoods.count > index {
                    NavigationLink {
                        GoodsDetailView(goods: allGoods[index], thumbnail: allGoods[index].thumbnailImageURL)
                    } label: {
                        VStack(alignment: .center) {
                            LazyImage(url: allGoods[index].thumbnailImageURL) { state in
                                if let image = state.image {
                                    ZStack {
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(height: 150)
                                            .clipped()
                                        
                                        
                                        VStack(alignment: .trailing) {
                                            Spacer()
                                            HStack(alignment: .bottom) {
                                                Spacer()
                                                Button {
                                                    if var user = UserStore.shared.userData {
                                                        Task {
                                                            if user.goodsFavorited.contains(allGoods[index]) {
                                                                user.goodsFavorited.remove(allGoods[index])
                                                            } else {
                                                                user.goodsFavorited.insert(allGoods[index])
                                                            }
                                                            
                                                            _ = try await DataManager.shared.updateData(type: .user, parameter: .userUpdate(id: user.id, user: user))
                                                        }
                                                    } else {
                                                        isNeedLogin = true
                                                    }
                                                } label: {
                                                    if let user = userStore.userData {
                                                        if user.goodsFavorited.contains(allGoods[index]) {
                                                            Image(systemName: "heart.fill")
                                                                .resizable()
                                                                .aspectRatio(contentMode: .fit)
                                                                .frame(width: 25, height: 25)
                                                                .foregroundStyle(.pink)
                                                                .shadow(color: .black, radius: 1)
                                                        } else {
                                                            Image(systemName: "heart")
                                                                .resizable()
                                                                .aspectRatio(contentMode: .fit)
                                                                .frame(width: 25, height: 25)
                                                                .foregroundStyle(.white)
                                                                .shadow(color: .black, radius: 1)
                                                        }
                                                    } else {
                                                        Image(systemName: "heart")
                                                            .resizable()
                                                            .aspectRatio(contentMode: .fit)
                                                            .frame(width: 25, height: 25)
                                                            .foregroundStyle(.white)
                                                            .shadow(color: .black, radius: 1)
                                                    }
                                                }
                                                .padding([.bottom, .trailing], 8)
                                            }
                                        }
                                    }
                                } else {
                                    ProgressView()
                                        .frame(minHeight: 80)
                                }
                                
                                if let error = state.error {
                                    Text("Lazy Image Error: \(error)")
                                }
                            }
                            .priority(.high)
                            
                            HStack {
                                Text(allGoods[index].name)
                                    .font(.system(size: 14, weight: .semibold))
                                    .lineLimit(1)
                                Spacer()
                                Text("\(allGoods[index].price)원")
                                    .font(.system(size: 14, weight: .semibold))
                            }
                            .padding(.bottom)
                            .foregroundStyle(.black)
                        }
                        .padding(5)
                    }
                }
            }
            .padding(.bottom)
        }
        .padding(.horizontal, 10)
    }
}
/*
#Preview {
    let sampleGoods = Goods(
        id: "1",
        name: "멋진 에코백",
        category: .passion,
        thumbnailImageURL: URL(string: "https://png.pngtree.com/png-vector/20190704/ourmid/pngtree-leaf-graphic-icon-design-template-vector-illustration-png-image_1538440.jpg")!,
        bodyContent: """
"자연을 닮은 친환경 에코백"
가볍고 실용적인 디자인으로 일상에서 언제나 손쉽게 사용할 수 있는 에코백입니다. 내구성이 뛰어나며, 다양한 용도로 활용 가능해 장보기, 출퇴근, 여행 등 어디서든 편리하게 사용할 수 있습니다. 이 에코백은 단순한 가방 그 이상으로, 우리의 작은 실천이 지구를 지키는 데 큰 역할을 한다는 메시지를 담고 있습니다. 자연을 생각하는 당신의 선택, 친환경 에코백과 함께 더 나은 미래를 만들어가세요. 더불어, 이 에코백은 세탁이 가능해 오래도록 깨끗하게 사용할 수 있으며, 심플한 디자인으로 다양한 스타일에 잘 어울립니다. 플라스틱 사용을 줄이고 환경 보호를 실천하는 첫걸음으로, 작은 선택이 큰 변화를 만듭니다. 환경을 지키기 위한 실용적인 선택, 지금부터 함께 시작하세요. 우리의 미래는 여러분의 손에 달려 있습니다.
""",
        bodyImageNames: [],
        price: 15000,
        seller: UserStore.shared.userData ?? User(id: UUID().uuidString, loginMethod: LoginMethod.google.rawValue, isSeller: true, name: "Lucy", profileImageName: "Hi.png", pointCount: 0, cart: [], goodsRecentWatched: [])
    )
    
    ItemListView(category: GoodsCategory.none, allGoods: [sampleGoods, sampleGoods, sampleGoods])
}
*/
