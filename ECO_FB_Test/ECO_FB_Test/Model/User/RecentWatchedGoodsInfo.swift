//
//  RecentWatchedGoodsInfo.swift
//  ECO_FB_Test
//
//  Created by Jaemin Hong on 10/23/24.
// 

import Foundation

struct RecentWatchedGoodsInfo: Identifiable, Hashable {
    let id: String
    let goods: Goods
    let watchedDate: Date
    
    var formattedWatchedDate: String {
        watchedDate.getFormattedString("yyyy년 MM월 dd일 a hh시 mm분")
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(goods)
    }
    
    static func == (lhs: RecentWatchedGoodsInfo, rhs: RecentWatchedGoodsInfo) -> Bool {
        lhs.goods.id == rhs.goods.id
    }
}
