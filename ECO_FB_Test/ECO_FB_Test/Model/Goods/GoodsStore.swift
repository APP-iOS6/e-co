//
//  GoodsStore.swift
//  ECO_FB_Test
//
//  Created by Jaemin Hong on 10/12/24.
// 

import Foundation
import FirebaseFirestore

final class GoodsStore: ObservableObject, DataControllable {
    static let shared: GoodsStore = GoodsStore()
    private let db: Firestore = DataManager.shared.db
    @Published private var goodsList: [Goods] = []
    
    private init() {}
    
    func fetchData(parameter: DataParam) async throws -> DataResult {
        do {
            if case .goodsAll = parameter {
                return try await getGoodsAll()
            } else if case .goodsLoad(let id) = parameter {
                return try await getGoodsByID(parameter)
            } else {
                throw DataError.fetchError(reason: "The DataParam is not a goods load or goods all")
            }
        } catch {
            throw error
        }
    }
    
    func updateData(parameter: DataParam) async throws {
        guard case let .goodsUpdate(id, goods) = parameter else {
            throw DataError.fetchError(reason: "The DataParam is not a goods update")
        }
        
        do {
            try await db.collection("Goods").document(id).setData([
                "name": goods.name,
                "category": goods.category,
                "thumbnail": goods.thumbnailImageName,
                "body_content": goods.bodyContent,
                "body_images": goods.bodyImageNames,
                "price": goods.price,
                "seller_id": goods.seller.id
            ])
        } catch {
            throw error
        }
    }
    
    func deleteData() {
        
    }
    
    private func getGoodsByID(_ parameter: DataParam) async throws -> DataResult {
        guard case let .goodsLoad(id) = parameter else {
            throw DataError.fetchError(reason: "The DataParam is not a goods load")
        }
        
        do {
            let snapshot = try await db.collection("Goods").document(id).getDocument()
            
            guard let docData = snapshot.data() else {
                throw DataError.fetchError(reason: "The Document Data is nil")
            }
            
            let id = snapshot.documentID
            let name = docData["name"] as? String ?? "none"
            let category = docData["category"] as? String ?? "none"
            let thumbnailImageName = docData["thumbnail"] as? String ?? "none"
            let bodyContent = docData["body_content"] as? String ?? "none"
            let bodyImageNames = docData["body_images"] as? [String] ?? []
            let price = docData["price"] as? Int ?? 0
            
            let sellerID = docData["seller_id"] as? String ?? "none"
            let seller = await DataManager.shared.fetchData(type: .seller, parameter: .sellerLoad(id: sellerID))
            
            guard case let .seller(result) = seller else {
                throw DataError.convertError(reason: "DataResult is not a seller")
            }
            
            let goods: Goods = Goods(id: id, name: name, category: category, thumbnailImageName: thumbnailImageName, bodyContent: bodyContent, bodyImageNames: bodyImageNames, price: price, seller: result)
            
            return DataResult.goods(result: goods)
        } catch {
            throw error
        }
    }
    
    func getGoodsAll() async throws -> DataResult {
        goodsList.removeAll()
        
        do {
            let snapshot = try await db.collection("Goods").getDocuments()
            
            for document in snapshot.documents {
                let docData = document.data()
                let id = document.documentID
                
                let name = docData["name"] as? String ?? "none"
                let category = docData["category"] as? String ?? "none"
                let thumbnailImageName = docData["thumbnail"] as? String ?? "none"
                let bodyContent = docData["body_content"] as? String ?? "none"
                let bodyImageNames = docData["body_images"] as? [String] ?? []
                let price = docData["price"] as? Int ?? 0
                
                let sellerID = docData["seller_id"] as? String ?? "none"
                let seller = await DataManager.shared.fetchData(type: .seller, parameter: .sellerLoad(id: sellerID))
                
                guard case let .seller(result) = seller else {
                    throw DataError.convertError(reason: "DataResult is not a seller")
                }
                
                let goodsData = Goods(id: id, name: name, category: category, thumbnailImageName: thumbnailImageName, bodyContent: bodyContent, bodyImageNames: bodyImageNames, price: price, seller: result)
                goodsList.append(goodsData)
            }
            
            return DataResult.none
        } catch {
            throw error
        }
    }
}
