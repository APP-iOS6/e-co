//
//  DataType.swift
//  ECO_FB_Test
//
//  Created by Jaemin Hong on 10/11/24.
// 

import Foundation

enum DataType: Int, CaseIterable {
    case user = 0
    case goods
    case paymentInfo
    case cardInfo
    case addressInfo
    case orderDetail
    case announcement
    case oneToOneInquiry
    case review
    case zeroWasteShop
}
