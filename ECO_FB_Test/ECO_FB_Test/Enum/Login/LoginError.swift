//
//  LoginError.swift
//  ECO_FB_Test
//
//  Created by Jaemin Hong on 10/12/24.
// 

import Foundation

enum LoginError: Error {
    case tokenError(reason: String)
    case emailError(reason: String)
    case userError(reason: String)
}
