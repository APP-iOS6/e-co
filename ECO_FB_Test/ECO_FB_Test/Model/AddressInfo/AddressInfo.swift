//
//  AddressInfo.swift
//  ECO_FB_Test
//
//  Created by Jaemin Hong on 10/22/24.
// 

import Foundation

struct AddressInfo: Identifiable, Equatable {
    let id: String
    var recipientName: String
    var phoneNumber: String
    var address: String
    var detailAddress: String
}
