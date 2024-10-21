//
//  CartElement.swift
//  ECO_FB_Test
//
//  Created by Jaemin Hong on 10/19/24.
// 

import Foundation

struct CartElement: Identifiable, Hashable {
    let id: String
    let goods: Goods
    var goodsCount: Int
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(goods)
    }
    
    static func == (lhs: CartElement, rhs: CartElement) -> Bool {
        lhs.goods.id == rhs.goods.id
    }
}
