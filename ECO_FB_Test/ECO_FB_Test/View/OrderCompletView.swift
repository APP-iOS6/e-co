//
//  OrderCompletView.swift
//  ECO_FB_Test
//
//  Created by 이소영 on 10/19/24.
//

import SwiftUI

struct OrderCompleteView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(UserStore.self) private var userStore: UserStore
    @Binding var isCredit: Bool
    @Binding var isZeroWaste: Bool
    var usingPoint: Int
    var productsPrice: Int
    var deliveryPrice: Int = 3000
    private var totalPrice: Int {
        isZeroWaste ? productsPrice - usingPoint : productsPrice + deliveryPrice - usingPoint
    }
    @Binding var requestMessage: String
    @State private var isShowToast: Bool = false
    
    var body: some View {
        VStack {
            ZStack {
                ScrollView {
                    LazyVStack(alignment: .center, pinnedViews: [.sectionHeaders]) {
                        Text("주문완료")
                            .font(.title2)
                            .bold()
                        
                        Divider()
                        
                        // 결제 완료 뷰이기 때문에 isComplete 항상 true
                        DeliveryInfo(name: "김민수", address: "철수구 철수동 철수로 11 철수 아파트 120동 1202호       ", isComplete: true, requestMessage: $requestMessage)
                        
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
                .padding([.horizontal, .top])
                .scrollIndicators(.hidden)
            }
            
            if isShowToast {
                SignUpToastView(isVisible: $isShowToast, message: "결제가 완료되었습니다.")
            }
            
            Button {
                // TODO: 홈으로 이동하는 로직 구현
                dismiss()
            } label: {
                Text("홈으로")
                    .foregroundStyle(.white)
                    .font(.title2)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, maxHeight: 50)
                    .background {
                        RoundedRectangle(cornerRadius: 5)
                            .foregroundStyle(.accent)
                    }
            }
        }
    }
}
