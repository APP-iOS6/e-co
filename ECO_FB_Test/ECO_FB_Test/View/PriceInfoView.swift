//
//  ProductsAndDeliveryPriceView.swift
//  ECO_FB_Test
//
//  Created by 이소영 on 10/19/24.
//


import SwiftUI

struct PriceInfoView: View {
    var productsPrice: Int
    var deliveryPrice: Int
    var usingPoint: Int
    var vSpacing: CGFloat = 11
    var isZeroWaste: Bool
    
    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: vSpacing) {
                Text("총 상품가격")
                Text("배송비")
                Text("친환경포장 할인")
                Text("사용 포인트")
            }
            .foregroundStyle(Color(uiColor: .darkGray))
            .fontWeight(.bold)
            .padding(.vertical)
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: vSpacing) {
                Text("\(productsPrice)원")
                Text("\(deliveryPrice)원")
                Text("-\(isZeroWaste ? deliveryPrice : 0)원")
                    .fontWeight(.semibold)
                Text("-\(usingPoint)")
                    .fontWeight(.semibold)
            }
            .padding(.vertical)
        }
    }
}
