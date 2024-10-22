//
//  CartView.swift
//  ECO_FB_Test
//
//  Created by Jaemin Hong on 10/14/24.
//

import SwiftUI

struct CartView: View {
    @Environment(UserStore.self) private var userStore: UserStore
    @State private var selectedGoods: [CartElement] = []
    @State private var dataUpdateFlow: DataUpdateFlow = .didUpdate
    @State private var totalPrice: Int = 0
    @State private var isSelectedAll: Bool = false
    
    var body: some View {
        VStack {
            Spacer()
            
            if var userData = userStore.userData {
                HStack {
                    CheckBox(isOn: $isSelectedAll) {
                        
                    }
                    
                    Text("전체선택")
                    
                    Spacer()
                    
                    if !selectedGoods.isEmpty || dataUpdateFlow == .updating {
                        Button(dataUpdateFlow == .didUpdate ? "선택 상품 삭제" : "삭제중...") {
                            for goods in selectedGoods {
                                userData.cart.remove(goods)
                                selectedGoods.removeAll(where: { $0.id == goods.id })
                            }
                            
                            Task {
                                await DataManager.shared.updateData(type: .user, parameter: .userUpdate(id: userData.id, user: userData)) { flow in
                                    dataUpdateFlow = flow
                                    
                                    if flow == .didUpdate {
                                        isSelectedAll = false
                                    }
                                }
                            }
                        }
                        .foregroundStyle(.red)
                        .disabled(dataUpdateFlow == .updating)
                    }
                }
                
                ScrollView {
                    VStack {
                        if userData.arrayCart.count == 0 {
                            Text("장바구니가 비어있습니다")
                        } else {
                            ForEach(userData.arrayCart) { element in
                                CartGoodsInfoView(totalSelected: $isSelectedAll, cartElement: element) { isOn, element in
                                    if isOn {
                                        selectedGoods.append(element)
                                    } else {
                                        selectedGoods.removeAll(where: { $0.id == element.id })
                                    }
                                }
                            }
                        }
                    }
                }
            } else {
                Text("로그인이 필요합니다")
            }
            
            Spacer()
            
            NavigationLink {
                OrderView()
            } label: {
                Text("주문하기")
                    .foregroundStyle(.white)
                    .font(.title2)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, maxHeight: 50)
                    .background {
                        RoundedRectangle(cornerRadius: 5)
                            .foregroundStyle(userStore.userData == nil ? .gray : .accent)
                    }
            }
            .disabled(userStore.userData == nil)
        }
        .padding()
    }
}

#Preview {
    CartView()
        .environment(UserStore.shared)
        .environment(GoodsStore.shared)
}
