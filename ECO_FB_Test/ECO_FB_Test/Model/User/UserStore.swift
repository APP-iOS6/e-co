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
    private(set) var userData: User? = nil
    
    private init() {}
    
    func checkIfUserExists(parameter: DataParam) async throws -> Bool {
        guard case let .userSearch(id) = parameter else {
            throw DataError.fetchError(reason: "The DataParam is not a user search")
        }
        
        do {
            let snapshot = try await db.collection("User").document(id).getDocument()
            
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
            let snapshot = try await db.collection("User").document(id).getDocument()
            
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
            throw DataError.fetchError(reason: "The DataParam is not a user update")
        }
        
        var goodsIds: [String] = []
        for goods in user.cart {
            goodsIds.append(goods.id)
        }
        
        var recentWatchedIDs: [String] = []
        for goods in user.goodsRecentWatched {
            recentWatchedIDs.append(goods.id)
        }
        
        do {
            try await db.collection("User").document(id).setData([
                "login_method": user.loginMethod,
                "is_seller": user.isSeller,
                "name": user.name,
                "profile_image": user.profileImageName,
                "point": user.pointCount,
                "cart": goodsIds,
                "goods_recent_watched": recentWatchedIDs
            ])
        } catch {
            throw error
        }
    }
    
    func deleteData() {
        
    }
    
    private func getUserWithReturn(id: String) async throws -> DataResult {
        do {
            let snapshot = try await db.collection("User").document(id).getDocument()
            
            let user = try await getData(document: snapshot)
            return DataResult.user(result: user)
        } catch {
            throw error
        }
    }
    
    private func getUserWithNoReturn(id: String) async throws -> DataResult {
        do {
            _ = try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<DataResult, Error>) in
                _ = db.collection("User").document(id).addSnapshotListener { [weak self] snapshot, error in
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
        let profileImageName = docData["profile_image"] as? String ?? "none"
        let pointCount = docData["point"] as? Int ?? 0
        
        var cart: Set<Goods> = []
        let cartGoodsIDs = docData["cart"] as? [String] ?? []
        for goodsId in cartGoodsIDs {
            let goodsResult = await DataManager.shared.fetchData(type: .goods, parameter: .goodsLoad(id: goodsId)) { _ in
                
            }
            
            if case let .goods(result) = goodsResult {
                cart.insert(result)
            }
        }
        
        var goodsRecentWatched: Set<Goods> = []
        let recentGoodsIDs = docData["goods_recent_watched"] as? [String] ?? []
        for goodsId in recentGoodsIDs {
            let goodsResult = await DataManager.shared.fetchData(type: .goods, parameter: .goodsLoad(id: goodsId)) { _ in
                
            }
            
            if case let .goods(result) = goodsResult {
                goodsRecentWatched.insert(result)
            }
        }
        
        let user = User(id: id, loginMethod: loginMethod, isSeller: isSeller, name: name, profileImageName: profileImageName, pointCount: pointCount, cart: cart, goodsRecentWatched: goodsRecentWatched)
        return user
    }
}
