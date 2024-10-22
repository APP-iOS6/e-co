//
//  CartGoodsInfoView.swift
//  ECO_FB_Test
//
//  Created by Jaemin Hong on 10/14/24.
//

import SwiftUI
import NukeUI

struct CartGoodsInfoView: View {
    @Binding var totalSelected: Bool
    var cartElement: CartElement
    var selectEvent: (Bool, CartElement) -> Void
    @State private var isOn: Bool = false
    @State private var isSelected: Bool = false
    
    private var goods: Goods {
        cartElement.goods
    }
    
    var body: some View {
        VStack {
            HStack(alignment: .center) {
                CheckBox(isOn: $isOn) {
                    selectEvent(isOn, cartElement)
                }
                
                LazyImage(url: goods.thumbnailImageURL) { state in
                    if let image = state.image {
                        image
                            .resizable()
                            .frame(width: 80, height: 80)
                    } else {
                        ProgressView()
                    }
                }
                
                VStack(alignment: .leading) {
                    Text("\(goods.seller.name)")
                        .font(.footnote)
                    Text("\(goods.name)")
                        .font(.title2)
                        .fontWeight(.bold)
                }
                
                Spacer()
                
                Text("\(goods.formattedPrice)")
                    .font(.headline)
            }
            
            Divider()
        }
        .onChange(of: totalSelected) {
            isOn = totalSelected
            selectEvent(isOn, cartElement)
        }
        .onTapGesture {
            isSelected = true
        }
    }
}
