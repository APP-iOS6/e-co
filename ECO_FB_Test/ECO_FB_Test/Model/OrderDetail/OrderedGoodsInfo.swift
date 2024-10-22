//
//  OrderedGoodsInfo.swift
//  ECO_FB_Test
//
//  Created by Jaemin Hong on 10/22/24.
// 

import Foundation

struct OrderedGoodsInfo: Identifiable {
    let id: String
    let deliveryStatus: DeliveryStatus
    let goodsList: [OrderedGoods]
}
