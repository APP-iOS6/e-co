//
//  CartGoodsInfoView.swift
//  ECO_FB_Test
//
//  Created by Jaemin Hong on 10/14/24.
//

import SwiftUI

struct CartGoodsInfoView: View {
    @State private var isOn: Bool = false
    @Binding var totalSelected: Bool
    var goods: Goods
    var screenWidth: CGFloat
    var selectEvent: (Bool, Goods) -> Void
    
    var body: some View {
        VStack {
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
                        .font(.title2)
                        .fontWeight(.bold)
                    Text("\(goods.formattedPrice)")
                        .font(.title3)
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
                }
                .frame(width: 255)
                
                CheckBox(isOn: $isOn) {
                    selectEvent(isOn, goods)
                }
            }
            
            Divider()
        }
        .onChange(of: totalSelected) {
            isOn = totalSelected
            selectEvent(isOn, goods)
        }
    }
}
