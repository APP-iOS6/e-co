//
//  OrderDetail.swift
//  ECO_FB_Test
//
//  Created by Jaemin Hong on 10/20/24.
// 

import Foundation

struct OrderDetail: Identifiable {
    let id: String
    let userID: String
    let paymentInfo: PaymentInfo
    let orderedGoodsInfos: [OrderedGoodsInfo]
    let orderDate: Date
}
