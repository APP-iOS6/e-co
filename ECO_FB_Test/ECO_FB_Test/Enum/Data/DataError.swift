//
//  DataError.swift
//  ECO_FB_Test
//
//  Created by Jaemin Hong on 10/11/24.
// 

import Foundation

enum DataError: Error {
    case fetchError(reason: String)
    case convertError(reason: String)
}
