//
//  RoadAddress.swift
//  ECO_FB_Test
//
//  Created by Jaemin Hong on 10/23/24.
// 

import Foundation

struct RoadAddress: Codable {
    let addressName: String
    let buildingName: String?
    let mainBuildingNumber: String
    let region1DepthName: String
    let region2DepthName: String
    let region3DepthName: String
    let roadName: String
    let zoneNumber: String
    
    enum CodingKeys: String, CodingKey {
        case addressName = "address_name"
        case buildingName = "building_name"
        case mainBuildingNumber = "main_building_no"
        case region1DepthName = "region_1depth_name"
        case region2DepthName = "region_2depth_name"
        case region3DepthName = "region_3depth_name"
        case roadName = "road_name"
        case zoneNumber = "zone_no"
    }
}
