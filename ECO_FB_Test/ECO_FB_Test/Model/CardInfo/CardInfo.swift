//
//  CardInfo.swift
//  ECO_FB_Test
//
//  Created by Jaemin Hong on 10/19/24.
// 

import Foundation

struct CardInfo: Identifiable, Equatable {
    let id: String
    let cvc: String
    let ownerName: String
    let cardNumber: String
    let cardPassword: String
    let expirationDate: Date
}
