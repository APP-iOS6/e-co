//
//  StorageManager.swift
//  ECO_FB_Test
//
//  Created by Jaemin Hong on 10/15/24.
//

import Foundation

@MainActor
final class StorageManager {
    static let shared: StorageManager = StorageManager()
    private let storageManagers: [StorageControllable] = [
        GoodsStorageManager.shared
    ]
    
    func upload(type: StorageType, parameter: StorageParam) async throws -> StorageResult{
        do {
            let result = try await storageManagers[type.rawValue].upload(parameter: parameter)
            return result
        } catch {
            print("Error: \(error)")
            throw error
        }
    }
}
