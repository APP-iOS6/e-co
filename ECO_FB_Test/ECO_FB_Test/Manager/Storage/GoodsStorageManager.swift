//
//  GoodsStorageManager.swift
//  ECO_FB_Test
//
//  Created by Jaemin Hong on 10/15/24.
//

import Foundation
import SwiftUI
import FirebaseStorage

final class GoodsStorageManager: StorageControllable {
    static let shared: GoodsStorageManager = GoodsStorageManager()
    
    private init() {}

    func upload(parameter: StorageParam) async throws -> StorageResult {
        do {
            if case let .uploadGoodsThumbnail(id, image) = parameter {
                
                guard let imageData = image.jpegData(compressionQuality: 0.8) else {
                    throw DataError.fetchError(reason: "Can't convert image to jpeg data")
                }
                
                let imageName = id + "_thumbnail" + ".jpg"
                let metaData = StorageMetadata()
                
                metaData.contentType = "image/jpeg"
                
                let result = try await Storage.storage().reference(withPath: "goods/\(id)/Thumbnail/\(imageName)").putDataAsync(imageData, metadata: metaData)
                
                guard let path = result.path else {
                    throw DataError.fetchError(reason: "Can't get data path")
                }
                
                let urlResult = try await getThumbnailURL(path: path)
                
                guard case let .single(url) = urlResult else {
                    throw DataError.fetchError(reason: "The generated url is not valid")
                }
                
                return StorageResult.single(url)
            } else {
                throw DataError.fetchError(reason: "The StorageParam is not goods thumbnail or goods content")
            }
        } catch {
            throw error
        }
    }
    
    private func getThumbnailURL(path: String) async throws -> StorageResult {
        do {
            let url = try await Storage.storage().reference(withPath: path).downloadURL()
            return StorageResult.single(url)
        } catch {
            throw error
        }
    }
    
    private func getContentURLs(goodsID: String) async throws -> StorageResult {
        do {
            let goodsData = try await DataManager.shared.fetchData(type: .goods, parameter: .goodsLoad(id: goodsID))
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
