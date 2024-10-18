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
    
    private init() {}
    
    /**
     데이터 업로드 함수
     
     - parameters:
        - type: 업로드 할 대상, 예) 상품이라면 .goods
        - parameter: 업로드 시 필요한 인자
     
     - returns: 해당 이미지의 다운로드 URL, 반환받은 URL은 데이터 베이스에 직접 넣어주셔야 합니다.
     */
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
