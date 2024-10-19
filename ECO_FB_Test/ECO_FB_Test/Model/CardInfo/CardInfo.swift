//
//  CardInfo.swift
//  ECO_FB_Test
//
//  Created by Jaemin Hong on 10/19/24.
// 

import Foundation

struct CardInfo: Identifiable, Equatable {
    let id: String
    var cvc: String
    var ownerName: String
    var cardNumber: String
    var cardPassword: String
    var expirationDate: Date
}
