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

    var width = 0
    
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
                            GoodsDetailView(goods: goods, thumbnail: goods.thumbnailImageURL)
                        } label: {
                            LazyImage(url: goods.thumbnailImageURL) { state in
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
