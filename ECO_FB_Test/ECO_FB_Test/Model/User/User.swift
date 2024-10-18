//
//  User.swift
//  ECO_FB_Test
//
//  Created by Jaemin Hong on 10/11/24.
//

import Foundation

struct User: Identifiable {
    let id: String
    let loginMethod: String
    let isSeller: Bool
    let name: String
    let profileImageName: String
    var pointCount: Int
    var cart: Set<Goods>
    var goodsRecentWatched: Set<Goods>
    
    var arrayCart: [Goods] {
        let sortOrder: [KeyPathComparator] = [
            KeyPathComparator(\Goods.name),
            KeyPathComparator(\Goods.price),
            KeyPathComparator(\Goods.id)
        ]
        
        return cart.map(\.self).sorted(using: sortOrder)
    }
    
    var recentWatchedArray: [Goods] {
        let sortOrder: [KeyPathComparator] = [
            KeyPathComparator(\Goods.name),
            KeyPathComparator(\Goods.price),
            KeyPathComparator(\Goods.id)
        ]
        
        return goodsRecentWatched.map(\.self).sorted(using: sortOrder)
    }
}
