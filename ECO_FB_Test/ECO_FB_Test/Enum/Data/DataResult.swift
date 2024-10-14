//
//  DataResult.swift
//  ECO_FB_Test
//
//  Created by Jaemin Hong on 10/12/24.
// 

import Foundation

enum DataResult {
    case none
    case user(result: User)
    case admin(result: Admin)
    case seller(result: Seller)
    case goods(result: Goods)
    case error(reason: String)
}
