//
//  CartGoodsInfoView.swift
//  ECO_FB_Test
//
//  Created by Jaemin Hong on 10/14/24.
//

import SwiftUI

struct CartGoodsInfoView: View {
    @Binding var totalSelected: Bool
    var goods: Goods
    var selectEvent: (Bool, Goods) -> Void
    @State private var isOn: Bool = false
    @State private var isSelected: Bool = false
    @State private var thumbnailURL: URL? = nil
    
    var body: some View {
        VStack {
            HStack(alignment: .center) {
                CheckBox(isOn: $isOn) {
                    selectEvent(isOn, goods)
                }
                
                Image(systemName: "clipboard.fill")
                    .frame(width: 80, height: 80)
                    .background {
                        Rectangle()
                            .foregroundStyle(.gray)
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
            selectEvent(isOn, goods)
        }
        .onTapGesture {
            isSelected = true
        }
        .navigationDestination(isPresented: $isSelected) {
            GoodsDetailView(goods: goods, thumbnail: thumbnailURL ?? URL(string: "https://png.pngtree.com/png-vector/20230407/ourlarge/pngtree-leaves-leaves-green-leaves-transparent-png-image_6693859.png")!)
        }
    }
}
