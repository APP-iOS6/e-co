//
//  DataInfo.swift
//  ECO_FB_Test
//
//  Created by Jaemin Hong on 10/11/24.
// 

import Foundation

enum DataParam {
    // Load(fetch) 작업이 필요하거나 id만 필요한 상황에 사용
    case userLoad(id: String)
    case adminLoad(id: String)
    case sellerLoad(id: String)
    case goodsLoad(id: String)
    
    // Update(기존 데이터 갱신), Add(새로운 데이터 추가) 작업이 필요할 때 사용
    case userUpdate(id: String, user: User)
    case adminUpdate(id: String, admin: Admin)
    case sellerUpdate(id: String, seller: Seller)
    case goodsUpdate(id: String, goods: Goods)
}
