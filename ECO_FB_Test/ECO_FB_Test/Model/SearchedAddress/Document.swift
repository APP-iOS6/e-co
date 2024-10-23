//
//  Document.swift
//  ECO_FB_Test
//
//  Created by Jaemin Hong on 10/23/24.
// 

import Foundation

struct Document: Codable {
    let address: Address?
    let roadAddress: RoadAddress
    let addressName: String
    let addressType: String
    let x: String
    let y: String
    
    enum CodingKeys: String, CodingKey {
        case address
        case roadAddress = "road_address"
        case addressName = "address_name"
        case addressType = "address_type"
        case x
        case y
    }
}
