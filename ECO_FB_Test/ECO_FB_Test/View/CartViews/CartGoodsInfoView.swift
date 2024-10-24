//
//  CartGoodsInfoView.swift
//  ECO_FB_Test
//
//  Created by Jaemin Hong on 10/14/24.
//

import SwiftUI
import NukeUI

struct CartGoodsInfoView: View {
    @Environment(UserStore.self) private var userStore: UserStore
    @Binding var totalSelected: Bool
    var cartElement: CartElement
    var selectEvent: (Bool, CartElement) -> Void
    @State private var isOn: Bool = false
    @State private var isSelected: Bool = false
    
    private var goods: Goods {
        cartElement.goods
    }
    
    private var count: Int {
        if let user = userStore.userData {
            if let i = user.arrayCart.firstIndex(of: cartElement) {
                return user.arrayCart[i].goodsCount
            }
        }
        return 1
    }
    @State private var dataUpdateFlow: DataFlow = .none
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    CheckBox(isOn: $isOn) {
                        selectEvent(isOn, cartElement)
                    }
                    
                    LazyImage(url: goods.thumbnailImageURL) { state in
                        if let image = state.image {
                            image
                                .resizable()
                                .frame(width: 100, height: 100)
                        } else {
                            ProgressView()
                        }
                    }
                    
                    VStack(alignment: .trailing) {
                        Text("\(goods.seller.name)")
                            .font(.footnote)
                        Text("\(goods.name)")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Text("\(goods.formattedPrice)")
                            .font(.headline)
                        
                        Stepper {
                            HStack {
                                Spacer()
                                Text("총 \(count)개")
                            }
                        } onIncrement: {
                            if var user = userStore.userData {
                                Task {
                                    user.updateCartGoodsCount(cartElement, count: 1)
                                    let _ = try await DataManager.shared.updateData(type: .user, parameter: .userUpdate(id: user.id, user: user), flow: $dataUpdateFlow)
                                }
                            }
                        } onDecrement: {
                            if cartElement.goodsCount != 1 {
                                if var user = userStore.userData {
                                    Task {
                                        user.updateCartGoodsCount(cartElement, count: -1)
                                        let _ = try await DataManager.shared.updateData(type: .user, parameter: .userUpdate(id: user.id, user: user), flow: $dataUpdateFlow)
                                    }
                                }
                            }
                        }
                    }
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
            if dataUpdateFlow == .loading {
                ProgressView()
            }
        }
        .disabled(dataUpdateFlow == .loading)
    }
}
