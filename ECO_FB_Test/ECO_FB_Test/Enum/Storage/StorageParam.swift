//
//  StorageParam.swift
//  ECO_FB_Test
//
//  Created by Jaemin Hong on 10/15/24.
//

import Foundation
import SwiftUI

enum StorageParam {
    case uploadGoodsThumbnail(goodsID: String, image: UIImage)
    case uploadGoodsContent(goodsID: String, image: UIImage)
}
