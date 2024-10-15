//
//  CartView.swift
//  ECO_FB_Test
//
//  Created by Jaemin Hong on 10/14/24.
//

import SwiftUI

struct CartView: View {
    @Environment(UserStore.self) private var userStore: UserStore
    @Environment(GoodsStore.self) private var goodsStore: GoodsStore
    @State private var selectedGoods: [Goods] = []
    @State private var totalPrice: Int = 0
    @State private var isSelectedAll: Bool = false
    
    var body: some View {
        VStack(alignment: .center) {
            HStack {
                CheckBox(isOn: $isSelectedAll) {
                    
                }
                
                Text("전체선택")
            }
            .alignmentGuide(HorizontalAlignment.center) { _ in
                190
            }
            
            GeometryReader { geometry in
                ScrollView {
                    LazyVStack {
                        ForEach(goodsStore.goodsList) { goods in
                            CartGoodsInfoView(totalSelected: $isSelectedAll, goods: goods, screenWidth: geometry.size.width) { isOn, goods in
                                if isOn {
                                    selectedGoods.append(goods)
                                } else {
                                    selectedGoods.removeAll(where: { $0.id == goods.id })
                                }
                            }
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
        .environment(UserStore.shared)
        .environment(GoodsStore.shared)
}
