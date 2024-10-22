//
//  ProductListView.swift
//  ECO_FB_Test
//
//  Created by 이소영 on 10/18/24.
//


import SwiftUI
import NukeUI

struct ProductListView: View {
    var cart: [CartElement]
    var usingPoint: Int
    
    var body: some View {
        VStack(alignment: .leading) {
            ForEach(cart) { element in
                HStack {
                    LazyImage(url: element.goods.thumbnailImageURL) { state in
                        if let image = state.image {
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 90, height: 90)
                        } else {
                            ProgressView()
                                .frame(minHeight: 80)
                        }
                        
                        if let error = state.error {
                            Text("Lazy Image Error: \(error)")
                        }
                    }
                    .priority(.high)
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 5) {
                        Text(element.goods.name)
                        Text("\(element.goodsCount)")
                        Text("\(element.goods.price) x \(element.goodsCount)")
                    }
                }
                .bold()
            }
        }
    }
}
