//
//  StorageResult.swift
//  ECO_FB_Test
//
//  Created by Jaemin Hong on 10/15/24.
// 

import Foundation

enum StorageResult {
    case single(URL)
    case multiple([URL])
    case error(result: String)
}
