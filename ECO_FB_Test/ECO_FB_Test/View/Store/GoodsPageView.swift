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
    var category: GoodsCategory
    @Environment(GoodsStore.self) private var goodsStore: GoodsStore
    
    var body: some View {
        VStack {
            if let filteredGoods = goodsStore.filteredGoodsByCategories[category] {
                List(filteredGoods[itemRange]) { goods in
                    NavigationLink {
                        GoodsDetailView(goods: goods, thumbnail: goods.thumbnailImageURL)
                    } label: {
                        HStack(spacing: 15) {
                            LazyImage(url: goods.thumbnailImageURL	) { state in
                                if let image = state.image {
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(height: 80)
                                } else if state.isLoading {
                                    ProgressView()
                                        .frame(height: 80)
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
