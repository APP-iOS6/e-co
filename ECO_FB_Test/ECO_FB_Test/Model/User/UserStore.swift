//
//  UserStore.swift
//  ECO_FB_Test
//
//  Created by Jaemin Hong on 10/11/24.
//

import Foundation
import Combine
import FirebaseFirestore

@Observable
final class UserStore: DataControllable {
    static let shared: UserStore = UserStore()
    private let db: Firestore = DataManager.shared.db
    private let collectionName: String = "User"
    private(set) var userData: User? = nil
    
    private init() {}
    
    func checkIfUserExists(parameter: DataParam) async throws -> Bool {
        guard case let .userSearch(id) = parameter else {
            throw DataError.fetchError(reason: "The DataParam is not a user search")
        }
        
        do {
            let snapshot = try await db.collection(collectionName).document(id).getDocument()
            
            return snapshot.exists
        } catch {
            throw error
        }
    }
    
    func getUserLoginMethod(parameter: DataParam) async throws -> String {
        guard case let .userSearch(id) = parameter else {
            throw DataError.fetchError(reason: "The DataParam is not a user search")
        }
        
        do {
            let snapshot = try await db.collection(collectionName).document(id).getDocument()
            
            guard let docData = snapshot.data() else {
                throw DataError.fetchError(reason: "The Document Data is nil")
            }
            let loginMethod = docData["login_method"] as? String ?? "none"
            
            return loginMethod
        } catch {
            throw error
        }
    }
    
    func setLogout() {
        userData = nil
    }
    
    func fetchData(parameter: DataParam) async throws -> DataResult {
        guard case let .userLoad(id, shouldReturnUser) = parameter else {
            throw DataError.fetchError(reason: "The DataParam is not a user load")
        }
        
        do {
            var result = DataResult.none
            if shouldReturnUser {
                result = try await getUserWithReturn(id: id)
            } else {
                result = try await getUserWithNoReturn(id: id)
            }
            
            return result
        } catch {
            throw error
        }
    }
    
    func updateData(parameter: DataParam) async throws {
        guard case let .userUpdate(id, user) = parameter else {
            throw DataError.updateError(reason: "The DataParam is not a user update")
        }
        
        var goodsCartIDs: [String] = []
        for element in user.cart {
            let goodsID = element.goods.id
            let goodsCount = element.goodsCount
            let cartInfo: String = goodsID + "_" + String(goodsCount)
            
            goodsCartIDs.append(cartInfo)
        }
        
        let recentWatchedIDs: [String] = getGoodsIDArray(goodsSet: user.goodsRecentWatched)
        let goodsFavoritedIDs: [String] = getGoodsIDArray(goodsSet: user.goodsFavorited)
        
        do {
            try await db.collection(collectionName).document(id).setData([
                "login_method": user.loginMethod,
                "is_seller": user.isSeller,
                "name": user.name,
                "profile_image": user.profileImageURL.absoluteString,
                "point": user.pointCount,
                "cart": goodsCartIDs,
                "goods_recent_watched": recentWatchedIDs,
                "goods_favorited": goodsFavoritedIDs
            ])
        } catch {
            throw error
        }
    }
    
    func deleteData(parameter: DataParam) async throws {
        guard let user = userData else {
            throw DataError.deleteError(reason: "User doesn't exist")
        }
        
        do {
            try await db.collection(collectionName).document(user.id).delete()
            setLogout()
        } catch {
            throw error
        }
    }
    
    private func getUserWithReturn(id: String) async throws -> DataResult {
        do {
            let snapshot = try await db.collection(collectionName).document(id).getDocument()
            
            let user = try await getData(document: snapshot)
            return DataResult.user(result: user)
        } catch {
            throw error
        }
    }
    
    private func getUserWithNoReturn(id: String) async throws -> DataResult {
        do {
            _ = try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<DataResult, Error>) in
                _ = db.collection(collectionName).document(id).addSnapshotListener { [weak self] snapshot, error in
                    if let error {
                        continuation.resume(throwing: error)
                    }
                    
                    guard let snapshot else {
                        continuation.resume(throwing: DataError.fetchError(reason: "User Data Snapshot not exist"))
                        return
                    }
                    
                    Task {
                        guard self != nil else {
                            continuation.resume(throwing: CommonError.referenceError(reason: "The self is nil"))
                            return
                        }
                        
                        self!.userData = try await self!.getData(document: snapshot)
                    }
                }
                
                continuation.resume(returning: DataResult.none)
            }
            
            return DataResult.none
        } catch {
            throw error
        }
    }
    
    private func getData(document: DocumentSnapshot) async throws -> User {
        guard let docData = document.data() else {
            throw DataError.fetchError(reason: "The Document Data is nil")
        }
        
        let id = document.documentID
        let loginMethod = docData["login_method"] as? String ?? "none"
        let isSeller = docData["is_seller"] as? Bool ?? false
        let name = docData["name"] as? String ?? "none"
        
        let profileImageURLString = docData["profile_image"] as? String ?? "none"
        guard let url = URL(string: profileImageURLString) else {
            throw DataError.convertError(reason: "The profile image URL is invalid")
        }
        
        let pointCount = docData["point"] as? Int ?? 0
        
        var cart: Set<CartElement> = []
        var goodsRecentWatched: Set<Goods> = []
        var goodsFavorited: Set<Goods> = []
        
        if !isSeller {
            let cartData = docData["cart"] as? [String] ?? []
            for data in cartData {
                let splitResult = data.components(separatedBy: "_")
                let goodsID = splitResult[0]
                let goodsCount = splitResult[1]
                
                let goodsResult = await DataManager.shared.fetchData(type: .goods, parameter: .goodsLoad(id: goodsID)) { _ in
                    
                }
                
                guard case let .goods(result) = goodsResult else {
                    throw DataError.fetchError(reason: "Can't get goods data")
                }
                
                let cartElement = CartElement(id: UUID().uuidString, goods: result, goodsCount: Int(goodsCount)!)
                cart.insert(cartElement)
            }
            
            goodsRecentWatched = try await getGoodsSet(field: "goods_recent_watched", docData: docData)
            goodsFavorited = try await getGoodsSet(field: "goods_favorited", docData: docData)
        }
        
        let user = User(id: id, loginMethod: loginMethod, isSeller: isSeller, name: name, profileImageURL: url, pointCount: pointCount, cart: cart, goodsRecentWatched: goodsRecentWatched, goodsFavorited: goodsFavorited)
        return user
    }
    
    private func getGoodsSet(field: String, docData: [String: Any]) async throws -> Set<Goods> {
        var resultSet: Set<Goods> = []
        let goodsIDs = docData[field] as? [String] ?? []
        
        for goodsID in goodsIDs {
            let goodsResult = await DataManager.shared.fetchData(type: .goods, parameter: .goodsLoad(id: goodsID)) { _ in
                
            }
            
            guard case let .goods(result) = goodsResult else {
                throw DataError.fetchError(reason: "Can't get goods data")
            }
            
            resultSet.insert(result)
        }
        
        return resultSet
    }
    
    private func getGoodsIDArray(goodsSet: Set<Goods>) -> [String] {
        var goodsIDs: [String] = []
        for goods in goodsSet {
            goodsIDs.append(goods.id)
        }
        
        return goodsIDs
    }
    
    // 최근 본 상품 저장 함수 (중복 방지 + 최신 본 상품 맨 위로 이동)
    func saveToRecentlyViewed(goods: Goods) {
        guard var user = userData else { return }
        
        // 최근 본 상품 배열로 변환
        var recentGoods = Array(user.goodsRecentWatched)
        
        // 이미 있는 상품이면 삭제 후 맨 앞에 추가
        if let index = recentGoods.firstIndex(of: goods) {
            recentGoods.remove(at: index)
        }
        
        // 상품을 맨 앞에 추가
        recentGoods.insert(goods, at: 0)
        
        // 최대 10개의 항목만 유지, 초과 시 가장 오래된 항목 삭제
        if recentGoods.count > 10 {
            recentGoods.removeLast()
        }
        
        // 업데이트된 배열을 Set으로 변환하여 저장
        user.goodsRecentWatched = Set(recentGoods)
        
        // 업데이트된 유저 데이터를 저장
        userData = user
        
        // 파이어베이스에 동기화 (옵션)
        Task {
            do {
                try await updateUserDataInFirestore(user: user)
            } catch {
                print("Failed to update user data in Firestore: \(error)")
            }
        }
    }
    
    // Firestore에 유저 데이터 업데이트
    private func updateUserDataInFirestore(user: User) async throws {
        let recentWatchedIDs = user.goodsRecentWatched.map { $0.id }
        try await db.collection("User").document(user.id).setData([
            "goods_recent_watched": recentWatchedIDs
        ], merge: true)
    }
}
