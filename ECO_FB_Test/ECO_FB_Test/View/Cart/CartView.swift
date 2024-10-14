//
//  CartView.swift
//  ECO_FB_Test
//
//  Created by Jaemin Hong on 10/14/24.
//

import SwiftUI

struct CartView: View {
    @EnvironmentObject private var userStore: UserStore
    @EnvironmentObject private var goodsStore: GoodsStore
    @State private var totalPrice: Int = 0
    @State private var isOn: Bool = false
    
    var body: some View {
        VStack(alignment: .center) {
            HStack {
                CheckBox(isOn: $isOn) {
                    
                }
                
                Text("전체선택")
            }
            .alignmentGuide(HorizontalAlignment.center) { _ in
                195
            }
            
            GeometryReader { geometry in
                ScrollView {
                    LazyVStack {
                        ForEach(goodsStore.goodsList) { goods in
                            CartGoodsInfoView(goods: goods, screenWidth: geometry.size.width)
                                .frame(width: geometry.size.width - 15)
                        }
                    }
                }
            }
            
            Button {
                
            } label: {
                Text("주문하기")
                    .foregroundStyle(.white)
                    .font(.title2)
                    .fontWeight(.bold)
                    .frame(width: 250, height: 50)
                    .background {
                        RoundedRectangle(cornerRadius: 5)
                            .foregroundStyle(.red)
                    }
            }
        }
        .onAppear {
            Task {
                await _ = DataManager.shared.fetchData(type: .goods, parameter: .goodsAll)
            }
        }
    }
}

#Preview {
    CartView()
        .environmentObject(UserStore.shared)
        .environmentObject(GoodsStore.shared)
}
