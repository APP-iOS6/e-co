//
//  Goods.swift
//  ECO_FB_Test
//
//  Created by Jaemin Hong on 10/12/24.
// 

import Foundation

struct Goods: Identifiable, Hashable {
    let id: String
    let name: String
    let category: String
    let thumbnailImageName: String
    let bodyContent: String
    let bodyImageNames: [String]
    let price: Int
    let seller: Seller
    
    var formattedPrice: String {
        return "₩\(price.formatted())"
    }
}
