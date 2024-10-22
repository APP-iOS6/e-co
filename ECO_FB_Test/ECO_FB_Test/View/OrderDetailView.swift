//
//  OrderDetailView.swift
//  ECO_FB_Test
//
//  Created by 이소영 on 10/19/24.
//

import SwiftUI

struct OrderDetailView: View {
    @Binding var isCredit: Bool
    @Binding var isZeroWaste: Bool
    var usingPoint: Int
    var productsPrice: Int
    var deliveryPrice: Int = 3000
    private var totalPrice: Int {
        isZeroWaste ? productsPrice - usingPoint : productsPrice + deliveryPrice - usingPoint
    }
    @Binding var requestMessage: String
    
    var body: some View {
        ScrollView {
            LazyVStack(alignment: .center, pinnedViews: [.sectionHeaders]) {
                Text("주문상세")
                    .font(.title2)
                    .bold()
                
                Divider()
                
                // 주문이 완료 된 경우에만 OrderDetailView를 확인할 수 있음 -> isComplete 항사 true
                DeliveryInfo(name: "김민수", address: "철수구 철수동 철수로 11 철수 아파트 120동 1202호       ", isComplete: true, requestMessage: $requestMessage)
                
                Divider()
                
                // 결제 방법 선택 부분
                ChooseMethodView(isCredit: $isCredit, isZeroWaste: $isZeroWaste, isPaymentView: true)
                    .disabled(true)
                
                Divider()
                
                ProductListView(cart: [], usingPoint: usingPoint)
                
                Divider()
                
                // 포장 방법 선택 부분
                ChooseMethodView(isCredit: $isCredit, isZeroWaste: $isZeroWaste, isPaymentView: false)
                    .disabled(true)
                
                Divider()
                
                PriceInfoView(productsPrice: productsPrice, deliveryPrice: deliveryPrice, usingPoint: usingPoint, isZeroWaste: isZeroWaste)
                
                Divider()
                
                HStack {
                    Text("총 결제 금액")
                    Spacer()
                    Text("\(totalPrice)원")
                }
                .bold()
                .padding(.vertical)
            }
        }
        .scrollIndicators(.hidden)
        .padding()
    }
}

//#Preview {
//    OrderDetailView()
//}
