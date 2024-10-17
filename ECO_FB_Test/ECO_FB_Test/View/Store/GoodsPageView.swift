//
//  GoodsPageView.swift
//  ECO_FB_Test
//
//  Created by 이소영 on 10/17/24.
//

import SwiftUI
import Nuke
import NukeUI

struct GoodsPageView: View {
    var itemRange: Range<Int>
    var imageURL: URL
    var category: GoodsCategory
    @Binding var index: Int
    @Environment(GoodsStore.self) private var goodsStore: GoodsStore
    
    var body: some View {
        VStack {
            if let filteredGoods = goodsStore.filteredGoodsByCategories[category] {
                List(filteredGoods[itemRange]) { goods in
                    NavigationLink {
                        GoodsDetailView(goods: goods, thumbnail: imageURL)
                    } label: {
                        HStack(spacing: 15) {
                            LazyImage(url: imageURL) { state in
                                if let image = state.image {
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(height: 80)
                                } else if state.isLoading {
                                    ProgressView()
                                }
                            }
                            
                            VStack(alignment: .leading) {
                                Text(goods.name)
                                    .font(.system(size: 20, weight: .semibold))
                                Text("\(goods.formattedPrice)")
                                    .font(.system(size: 15))
                            }
                        }
                        .foregroundStyle(.black)
                    }
                }
                .listStyle(.plain)
                .padding(.top)
            }
        }
    }
}
