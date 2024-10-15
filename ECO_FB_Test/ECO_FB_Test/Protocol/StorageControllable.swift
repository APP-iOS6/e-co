//
//  StorageControllable.swift
//  ECO_FB_Test
//
//  Created by Jaemin Hong on 10/15/24.
//

import Foundation

@MainActor
protocol StorageControllable {
    func fetch(parameter: StorageParam) async throws -> URL
    func upload(parameter: StorageParam) async throws
}
