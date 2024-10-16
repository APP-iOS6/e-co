//
//  GoodsStore.swift
//  ECO_FB_Test
//
//  Created by Jaemin Hong on 10/12/24.
//

import Foundation
import FirebaseFirestore

@Observable
final class GoodsStore: DataControllable {
    static let shared: GoodsStore = GoodsStore()
    private let db: Firestore = DataManager.shared.db
    private(set) var goodsList: [Goods] = []
    private(set) var selectedCategory: GoodsCategory = GoodsCategory.none
    private(set) var goodsByCategories: [GoodsCategory: [Goods]] = [:]
    private(set) var filteredGoodsByCategories: [GoodsCategory: [Goods]] = [:]
    
    private init() {}
    
    /**
     카테고리 선택시 해당하는 상품만 필터링 해준다
     */
    func categorySelectAction(_ category: GoodsCategory) {
        if selectedCategory == category {
            selectedCategory = GoodsCategory.none
        } else {
            selectedCategory = category
        }
        
        filteredGoodsByCategories = if selectedCategory == GoodsCategory.none {
            goodsByCategories
        } else {
            [selectedCategory : goodsByCategories[selectedCategory] ?? []]
        }
    }
    
    /**
     검색 키워드에 따라 상품을 필터링 해준다 (선택된 카테고리가 있을땐 해당 카테고리 안에서 검색)
     */
    func searchAction(_ text: String) {
        if text == "" {
            filteredGoodsByCategories = if selectedCategory == GoodsCategory.none {
                goodsByCategories
            } else {
                [selectedCategory : goodsByCategories[selectedCategory] ?? []]
            }
            return
        }
        
        var newGoodsByCategories: [GoodsCategory: [Goods]] = [:]
        
        let filteredGoods: [Goods] = goodsList.filter {
            $0.name.contains(text) || $0.bodyContent.contains(text) || $0.category.rawValue.contains(text)
        }
        
        for goods in filteredGoods {
            if newGoodsByCategories[goods.category] != nil {
                newGoodsByCategories[goods.category]?.append(goods)
            } else {
                newGoodsByCategories[goods.category] = [goods]
            }
        }
        
        filteredGoodsByCategories = if selectedCategory != GoodsCategory.none {
            [selectedCategory : newGoodsByCategories[selectedCategory] ?? []]
        } else {
            newGoodsByCategories
        }
    }
    
    func fetchData(parameter: DataParam) async throws -> DataResult {
        do {
            var result: DataResult = .none
            
            if case .goodsAll = parameter {
                result = try await getGoodsAll()
                goodsByCategories.removeAll()
                
                for goods in goodsList {
                    if goodsByCategories[goods.category] != nil {
                        goodsByCategories[goods.category]?.append(goods)
                    } else {
                        goodsByCategories[goods.category] = [goods]
                    }
                }
                filteredGoodsByCategories = goodsByCategories
                
            } else if case .goodsLoad(let id) = parameter {
                result = try await getGoodsByID(id)
            } else {
                throw DataError.fetchError(reason: "The DataParam is not a goods load or goods all")
            }
            
            return result
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
                "category": goods.category.rawValue,
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
    
    private func getGoodsByID(_ id: String) async throws -> DataResult {
        do {
            let snapshot = try await db.collection("Goods").document(id).getDocument()
            
            guard let docData = snapshot.data() else {
                throw DataError.fetchError(reason: "The Document Data is nil")
            }
            
            let id = snapshot.documentID
           
            let goods = try await getData(id: id, docData: docData)
            return DataResult.goods(result: goods)
        } catch {
            throw error
        }
    }
    
    private func getGoodsAll() async throws -> DataResult {
        goodsList.removeAll()
        
        do {
            let snapshots = try await db.collection("Goods").getDocuments()
            
            for document in snapshots.documents {
                let docData = document.data()
                let id = document.documentID
                
                let goods = try await getData(id: id, docData: docData)
                goodsList.append(goods)
            }
            
            return DataResult.none
        } catch {
            throw error
        }
    }
    
    private func getData(id: String, docData: [String: Any]) async throws -> Goods {
        let name = docData["name"] as? String ?? "none"
        let category = try stringToCategoryEnum(docData["category"] as? String ?? "none")
        let thumbnailImageName = docData["thumbnail"] as? String ?? "none"
        let bodyContent = docData["body_content"] as? String ?? "none"
        let bodyImageNames = docData["body_images"] as? [String] ?? []
        let price = docData["price"] as? Int ?? 0
        
        let sellerID = docData["seller_id"] as? String ?? "none"
        let seller = await DataManager.shared.fetchData(type: .seller, parameter: .sellerLoad(id: sellerID)) { _ in
            
        }
        
        guard case let .seller(result) = seller else {
            throw DataError.convertError(reason: "DataResult is not a seller")
        }
        
        let goods = Goods(id: id, name: name, category: category, thumbnailImageName: thumbnailImageName, bodyContent: bodyContent, bodyImageNames: bodyImageNames, price: price, seller: result)
        return goods
    }
    
    private func stringToCategoryEnum(_ string: String) throws -> GoodsCategory {
        switch string {
        case GoodsCategory.refill.rawValue:
            return .refill
        case GoodsCategory.electronics.rawValue:
            return .electronics
        case GoodsCategory.passion.rawValue:
            return .passion
        case GoodsCategory.beauty.rawValue:
            return .beauty
        case GoodsCategory.food.rawValue:
            return .food
        default:
            throw DataError.convertError(reason: "Can't find matched string")
        }
        
    }
}
