//
//  GoodsStorageManager.swift
//  ECO_FB_Test
//
//  Created by Jaemin Hong on 10/15/24.
//

import Foundation
import FirebaseStorage

final class GoodsStorageManager: StorageControllable {
    static let shared: GoodsStorageManager = GoodsStorageManager()
    
    private init() {}
    
    func fetch(parameter: StorageParam) async throws -> StorageResult {
        do {
            if case let .goodsThumbnail(goodsID) = parameter {
                return try await getThumbnailURL(goodsID: goodsID)
            } else if case let .goodsContent(goodsID) = parameter {
                return try await getContentURLs(goodsID: goodsID)
            } else {
                throw DataError.fetchError(reason: "The StorageParam is not goods thumbnail or goods content")
            }
        } catch {
            throw error
        }
    }
    
    func upload(parameter: StorageParam) async throws {
        
    }
    
    private func getThumbnailURL(goodsID: String) async throws -> StorageResult {
        do {
            let goodsData = await DataManager.shared.fetchData(type: .goods, parameter: .goodsLoad(id: goodsID))
            guard case let .goods(result) = goodsData else {
                throw DataError.convertError(reason: "Can't get goods data from goods result")
            }
            
            let url = try await Storage.storage().reference(withPath: result.thumbnailImageName).downloadURL()
            return StorageResult.single(url)
        } catch {
            throw error
        }
    }
    
    private func getContentURLs(goodsID: String) async throws -> StorageResult {
        do {
            let goodsData = await DataManager.shared.fetchData(type: .goods, parameter: .goodsLoad(id: goodsID))
            guard case let .goods(result) = goodsData else {
                throw DataError.convertError(reason: "Can't get goods data from goods result")
            }
            
            var contentURLs: [URL] = []
            for contentImagePath in result.bodyImageNames {
                let url = try await Storage.storage().reference(withPath: contentImagePath).downloadURL()
                contentURLs.append(url)
            }
            
            return StorageResult.multiple(contentURLs)
        } catch {
            throw error
        }
    }
}
