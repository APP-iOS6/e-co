//
//  CartGoodsInfoView.swift
//  ECO_FB_Test
//
//  Created by Jaemin Hong on 10/14/24.
//

import SwiftUI

struct CartGoodsInfoView: View {
    var goods: Goods
    var screenWidth: CGFloat
    @State private var isOn: Bool = false
    
    var body: some View {
        HStack(alignment: .top) {
            Image(systemName: "clipboard.fill")
                .frame(width: 100, height: 100)
                .background {
                    Rectangle()
                        .foregroundStyle(.gray)
                }
            
            VStack(alignment: .leading) {
                Text("\(goods.seller.name)")
                    .font(.title3)
                Text("\(goods.name)")
                    .font(.title)
                    .fontWeight(.bold)
                Text("\(goods.formattedPrice)")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Button {
                    
                } label: {
                    Text("바로 구매")
                        .foregroundStyle(.black)
                        .fontWeight(.bold)
                        .frame(width: 250, height: 35)
                        .background {
                            RoundedRectangle(cornerRadius: 5)
                                .foregroundStyle(.white)
                                .border(.gray)
                        }
                }
                
                Divider()
                    .frame(width: screenWidth)
            }
            
            CheckBox(isOn: $isOn) {
                
            }
        }
    }
}
