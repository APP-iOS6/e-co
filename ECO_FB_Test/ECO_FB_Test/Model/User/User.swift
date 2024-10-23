//
//  User.swift
//  ECO_FB_Test
//
//  Created by Jaemin Hong on 10/11/24.
//

import Foundation

struct User: Identifiable, Hashable {
    let id: String
    let loginMethod: String
    let isSeller: Bool
    let name: String
    let profileImageURL: URL
    var pointCount: Int
    var cart: Set<CartElement>
    var goodsRecentWatched: Set<RecentWatchedGoodsInfo>
    var goodsFavorited: Set<Goods>
    
    var arrayCart: [CartElement] {
        let sortOrder: [KeyPathComparator] = [
            KeyPathComparator(\CartElement.goods.name)
        ]
        
        return cart.map(\.self).sorted(using: sortOrder)
    }
    
    var arrayRecentWatched: [Goods] {
        let sortOrder: [KeyPathComparator] = [
            KeyPathComparator(\Goods.name),
            KeyPathComparator(\Goods.price),
        ]
        
        return goodsRecentWatched.map(\.self).sorted(using: sortOrder)
    }
    
    var arrayGoodsFavorited: [Goods] {
        let sortOrder: [KeyPathComparator] = [
            KeyPathComparator(\Goods.name),
            KeyPathComparator(\Goods.price)
        ]
        
        return goodsFavorited.map(\.self).sorted(using: sortOrder)
    }
    
    /**
     장바구니에 이미 있는 물건의 개수를 변경하는 메소드
     
     - parameters:
        - cartElement: 변경할 물건
        - count: 추가할 개수
     */
    mutating func updateCartGoodsCount(_ cartElement: CartElement, count: Int) {
        if var removeResult = cart.remove(cartElement) {
            removeResult.goodsCount += count
            cart.insert(removeResult)
        }
    }
}
