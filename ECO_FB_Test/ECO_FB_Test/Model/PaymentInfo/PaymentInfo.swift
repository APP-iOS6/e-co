//
//  OrderInfo.swift
//  ECO_FB_Test
//
//  Created by Jaemin Hong on 10/14/24.
// 

import Foundation

struct PaymentInfo: Identifiable {
    let id: String
    let userID: String
    let address: String
    let paymentMethod: [String]
}
