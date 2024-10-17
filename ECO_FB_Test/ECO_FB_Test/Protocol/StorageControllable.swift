//
//  StorageControllable.swift
//  ECO_FB_Test
//
//  Created by Jaemin Hong on 10/15/24.
//

import Foundation

@MainActor
protocol StorageControllable {
    /// **바로 사용 금지.** StorageManager의 fetch를 호출해 사용해주세요.
    func fetch(parameter: StorageParam) async throws -> StorageResult
    /// **바로 사용 금지.** StorageManager의 upload를 호출해 사용해주세요.
    func upload(parameter: StorageParam) async throws
}
