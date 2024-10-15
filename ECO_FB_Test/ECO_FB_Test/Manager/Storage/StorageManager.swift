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
    
    func fetch(type: StorageType, parameter: StorageParam) async -> StorageResult {
        do {
            let result = try await storageManagers[type.rawValue].fetch(parameter: parameter)
            return result
        } catch {
            print("Error: \(error)")
        }
        
        return StorageResult.error(result: "Can't fetch image from storage")
    }
    
    func upload() async throws {
        
    }
}
