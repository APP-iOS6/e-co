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
    let recipientName: String
    let phoneNumber: String
    let paymentMethodName: PaymentMethod
    let paymentMethod: CardInfo?
    let address: String
}
