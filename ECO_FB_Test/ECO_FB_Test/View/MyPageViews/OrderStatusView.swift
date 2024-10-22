//
//  OrderStatusView.swift
//  ECO_FB_Test
//
//  Created by 이소영 on 10/17/24.
//


import SwiftUI

struct OrderStatusView: View {
    @Environment(UserStore.self) private var userStore: UserStore
    
    @Binding var isCredit: Bool
    @Binding var isZeroWaste: Bool
    var usingPoint: Int
    var productsPrice: Int
    @Binding var requestMessage: String
    
    var body: some View {
        VStack {
            if userStore.userData == nil {
                Text("로그인이 필요합니다")
            } else {
                NavigationLink {
                    OrderDetailView(isCredit: $isCredit, isZeroWaste: $isZeroWaste, usingPoint: usingPoint, productsPrice: productsPrice, requestMessage: $requestMessage)
                } label: {
                    HStack {
                        Text("주문상세 보기")
                        Image(systemName: "chevron.right")
                    }
                }
            }
        }
    }
}
