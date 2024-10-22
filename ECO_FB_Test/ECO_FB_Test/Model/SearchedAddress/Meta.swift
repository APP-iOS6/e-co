//
//  Meta.swift
//  ECO_FB_Test
//
//  Created by Jaemin Hong on 10/23/24.
// 

import Foundation

struct Meta: Codable {
    let totalCount: Int
    let pageableCount: Int
    let isEnd: Bool
    
    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case pageableCount = "pageable_count"
        case isEnd = "is_end"
    }
}
