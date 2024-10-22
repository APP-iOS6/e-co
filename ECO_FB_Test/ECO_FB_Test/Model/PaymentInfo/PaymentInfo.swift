//
//  OrderInfo.swift
//  ECO_FB_Test
//
//  Created by Jaemin Hong on 10/14/24.
// 

import Foundation

struct PaymentInfo: Identifiable, Equatable {
    let id: String
    let userID: String
    var deliveryRequest: String
    var paymentMethod: PaymentMethod
    var paymentMethodInfo: CardInfo?
    var addressInfos: [AddressInfo]
    /**
     각 배송정보가 삭제되었는지 확인하기 위한 배열입니다. **해당 배열은 직접 사용하지 말아주세요**
     */
    let originAddressInfos: [AddressInfo]
    
    init(id: String, userID: String, deliveryRequest: String, paymentMethod: PaymentMethod, paymentMethodInfo: CardInfo? = nil, addressInfos: [AddressInfo]) {
        self.id = id
        self.userID = userID
        self.deliveryRequest = deliveryRequest
        self.paymentMethod = paymentMethod
        self.paymentMethodInfo = paymentMethodInfo
        self.addressInfos = addressInfos
        self.originAddressInfos = addressInfos
    }
}
