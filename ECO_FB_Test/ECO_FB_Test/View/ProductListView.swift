//
//  ProductListView.swift
//  ECO_FB_Test
//
//  Created by 이소영 on 10/18/24.
//


import SwiftUI

struct ProductListView: View {
    var goodsList: [Goods]
    var usingPoint: Int
    
    var body: some View {
        VStack(alignment: .leading) {
            ForEach(0..<4) { _ in
//            ForEach(goodsList, id: \.self) { goods in
                HStack {
                    Image(.ecoBags)
                        .resizable()
                        .frame(width: 90, height: 90)
                        .aspectRatio(contentMode: .fit)
                    
                    Spacer()
                    
                    // TODO: 지금은 수량 저장 못하게 되어있음
                    VStack(alignment: .trailing, spacing: 5) {
                        Text("에코백") // goods.name
                        Text("2개")
                        Text("2,000 x 2") //\(goods.price)
                    }
                }
                .bold()
            }
        }
    }
}
