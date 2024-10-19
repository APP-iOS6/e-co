//
//  DataResult.swift
//  ECO_FB_Test
//
//  Created by Jaemin Hong on 10/12/24.
// 

import Foundation

enum DataResult {
    case none
    case user(result: User)
    case goods(result: Goods)
    case paymentInfo(result: PaymentInfo)
    case error(reason: String)
}
