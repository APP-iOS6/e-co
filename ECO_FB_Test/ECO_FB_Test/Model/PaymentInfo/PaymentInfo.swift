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
    var recipientName: String
    var phoneNumber: String
    var paymentMethod: PaymentMethod
    var paymentMethodInfo: CardInfo?
    var address: String
}
