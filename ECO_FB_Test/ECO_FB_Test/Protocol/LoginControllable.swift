//
//  LoginControllable.swift
//  ECO_FB_Test
//
//  Created by Jaemin Hong on 10/12/24.
// 

import Foundation

@MainActor
protocol LoginControllable {
    /// **바로 사용 금지.** AuthManager의 login을 호출해 사용해주세요.
    func login() async throws
}
