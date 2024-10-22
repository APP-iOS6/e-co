//
//  Address.swift
//  ECO_FB_Test
//
//  Created by Jaemin Hong on 10/23/24.
// 

import Foundation

struct Address: Codable {
    let addressName: String
    let mainAddressNumber: String
    let subAddressNumber: String
    
    enum CodingKeys: String, CodingKey {
        case addressName = "address_name"
        case mainAddressNumber = "main_address_no"
        case subAddressNumber = "sub_address_no"
    }
}
