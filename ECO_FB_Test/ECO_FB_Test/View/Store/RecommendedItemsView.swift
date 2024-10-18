//
//  RecommendedItemsView.swift
//  ECO_FB_Test
//
//  Created by 이소영 on 10/17/24.
//

import SwiftUI
import Nuke
import NukeUI
import UIKit

struct RecommendedItemsView: View {
    @Binding var index: Int
    var goodsByCategories: [GoodsCategory : [Goods]]
    var imageURL: URL
    
    var body: some View {
        HStack {
            Text("이런 상품은 어때요?")
                .font(.system(size: 18, weight: .semibold))
            Spacer()
        }
        .padding(.horizontal)
        
        ScrollView(.horizontal) {
            LazyHStack(spacing: 8) {
                ForEach(Array(goodsByCategories.keys), id: \.self) { category in
                    if let goods = goodsByCategories[category]?.randomElement() {
                        NavigationLink {
                            GoodsDetailView(goods: goods, thumbnail: imageURL)
                        } label: {
                            LazyImage(url: imageURL) { state in
                                if let image = state.image {
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: UIScreen .main.bounds.width - 32, height: 400)
                                        .scrollTransition { content, phase in
                                            content
                                                .opacity(phase.isIdentity ?  1 : 0.5 )
                                                .scaleEffect(y: phase.isIdentity ?  1 : 0.7 )
                                        }
                                } else {
                                    ProgressView()
                                }
                            }
                        }
                    }
                }
            }
            .scrollTargetLayout()
        }
        .contentMargins(16, for: .scrollContent)
        .scrollTargetBehavior(.viewAligned)
        .scrollTargetBehavior(.paging)
        .scrollIndicators(.hidden)
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width*2/3)
    }
}

#Preview {
    let sampleGoods = Goods(
        id: "1",
        name: "멋진 에코백",
        category: .passion,
        thumbnailImageName: "ecoBags",
        bodyContent: """
"자연을 닮은 친환경 에코백"
가볍고 실용적인 디자인으로 일상에서 언제나 손쉽게 사용할 수 있는 에코백입니다. 내구성이 뛰어나며, 다양한 용도로 활용 가능해 장보기, 출퇴근, 여행 등 어디서든 편리하게 사용할 수 있습니다. 이 에코백은 단순한 가방 그 이상으로, 우리의 작은 실천이 지구를 지키는 데 큰 역할을 한다는 메시지를 담고 있습니다. 자연을 생각하는 당신의 선택, 친환경 에코백과 함께 더 나은 미래를 만들어가세요. 더불어, 이 에코백은 세탁이 가능해 오래도록 깨끗하게 사용할 수 있으며, 심플한 디자인으로 다양한 스타일에 잘 어울립니다. 플라스틱 사용을 줄이고 환경 보호를 실천하는 첫걸음으로, 작은 선택이 큰 변화를 만듭니다. 환경을 지키기 위한 실용적인 선택, 지금부터 함께 시작하세요. 우리의 미래는 여러분의 손에 달려 있습니다.
""",
        bodyImageNames: [],
        price: 15000,
        seller: Seller(id: "seller1", name: "(주) 멋사 ", profileImageName: "dd")
    )
    RecommendedItemsView(index: .constant(1), goodsByCategories: [.passion:[sampleGoods, sampleGoods, sampleGoods], .food:[sampleGoods, sampleGoods, sampleGoods], .beauty:[sampleGoods, sampleGoods, sampleGoods]], imageURL: URL(string: "https://firebasestorage.googleapis.com/v0/b/e-co-4f9aa.appspot.com/o/Goods%2F07AE6761-E5D0-4546-847D-48098E47393E%2FThumbnail%2FsconeLaptopPouch.jpg?alt=media&token=5789a9ac-984a-4828-857c-d0e066fc6851")!)
}
