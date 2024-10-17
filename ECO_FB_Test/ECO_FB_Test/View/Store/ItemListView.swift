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
    @Binding var index: Int
    var imageURL: URL
    var category: GoodsCategory
    var allGoods: [Goods]
    var gridItems: [GridItem] = [
        GridItem(),
        GridItem()
    ]
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(category.rawValue)
                    .font(.system(size: 20, weight: .semibold))
                Spacer()
                
                NavigationLink(destination: AllGoodsOfCategoryView(index: $index, imageURL: imageURL, category: category, allGoods: allGoods).environment(GoodsStore.shared)) {
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
            ForEach(0..<4) { index in
                if allGoods.count > index {
                    NavigationLink {
                        GoodsDetailView(goods: allGoods[index], thumbnail: imageURL)
                    } label: {
                        VStack(alignment: .leading) {
                            LazyImage(url: imageURL) { state in
                                if let image = state.image {
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(minHeight: 80)
                                } else if state.isLoading {
                                    ProgressView()
                                }
                                
                                if let error = state.error {
                                    Text("Lazy Image Error: \(error)")
                                }
                            }
                            
                            HStack {
                                Text(allGoods[index].name)
                                    .font(.system(size: 14, weight: .semibold))
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

