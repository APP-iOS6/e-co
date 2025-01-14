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
    
    @MainActor
    func getAllSellers() async throws -> [User] {
        var sellers: [User] = []
        
        do {
            let snapshots = try await db.collection(collectionName)
                                      .whereField("is_seller", isEqualTo: true)
                                      .getDocuments()
            
            for document in snapshots.documents {
                let user = try await getData(document: document)
                sellers.append(user)
            }
            
            return sellers
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
            if error is DataError {
                print("Error In UserStore: \(error)")
                return DataResult.none
            }
            
            throw error
        }
    }
    
    func updateData(parameter: DataParam) async throws -> DataResult {
        guard case let .userUpdate(id, user) = parameter else {
            throw DataError.updateError(reason: "The DataParam is not a user update")
        }
        
        DispatchQueue.main.async { [weak self] in
            if let self = self, let userData = self.userData, userData.id == id {
                self.userData = user
            }
        }
        
        var goodsCartIDs: [String] = []
        for element in user.cart {
            let goodsID = element.goods.id
            let goodsCount = element.goodsCount
            let cartInfo: String = goodsID + "_" + String(goodsCount)
            
            goodsCartIDs.append(cartInfo)
        }
        
        var recentWatchedDic: [String: String] = [:]
        for recentWatchedInfo in user.goodsRecentWatched {
            let goodsID = recentWatchedInfo.goods.id
            let dateString = recentWatchedInfo.watchedDate.getFormattedString("yyyy-MM-dd-HH-mm")
            recentWatchedDic[goodsID] = dateString
        }
        
        let goodsFavoritedIDs: [String] = getGoodsIDArray(goodsSet: user.goodsFavorited)
        
        do {
            try await db.collection(collectionName).document(id).setData([
                "login_method": user.loginMethod,
                "is_seller": user.isSeller,
                "name": user.name,
                "profile_image": user.profileImageURL.absoluteString,
                "point": user.pointCount,
                "cart": goodsCartIDs,
                "goods_recent_watched": recentWatchedDic,
                "goods_favorited": goodsFavoritedIDs
            ])
        } catch {
            throw error
        }
        
        return DataResult.update(isSuccess: true)
    }
    
    func deleteData(parameter: DataParam) async throws -> DataResult {
        guard let user = userData else {
            throw DataError.deleteError(reason: "User doesn't exist")
        }
        
        do {
            try await db.collection(collectionName).document(user.id).delete()
            setLogout()
        } catch {
            throw error
        }
        
        return DataResult.delete(isSuccess: true)
    }
    
    @MainActor
    private func getUserWithReturn(id: String) async throws -> DataResult {
        do {
            let snapshot = try await db.collection(collectionName).document(id).getDocument()
            
            let user = try await getData(document: snapshot)
            return DataResult.user(result: user)
        } catch {
            throw error
        }
    }
    
    @MainActor
    private func getUserWithNoReturn(id: String) async throws -> DataResult {
        do {
            let snapshot = try await db.collection(collectionName).document(id).getDocument()
            
            userData = try await getData(document: snapshot)
            return DataResult.none
        } catch {
            throw error
        }
    }
    
    private func getData(document: DocumentSnapshot) async throws -> User {
        do {
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
            var goodsRecentWatched: Set<RecentWatchedGoodsInfo> = []
            var goodsFavorited: Set<Goods> = []
            
            if !isSeller {
                let cartData = docData["cart"] as? [String] ?? []
                for data in cartData {
                    let splitResult = data.components(separatedBy: "_")
                    let goodsID = splitResult[0]
                    let goodsCount = splitResult[1]
                    
                    let goodsResult = try await DataManager.shared.fetchData(type: .goods, parameter: .goodsLoad(id: goodsID))
                    
                    if case let .goods(result) = goodsResult {
                        let cartElement = CartElement(id: UUID().uuidString, goods: result, goodsCount: Int(goodsCount)!)
                        cart.insert(cartElement)
                    }
                }
                
                let recentWatched = docData["goods_recent_watched"] as? [String: String] ?? [:]
                for (id, dateString) in recentWatched {
                    let goodsResult = try await DataManager.shared.fetchData(type: .goods, parameter: .goodsLoad(id: id))
                    
                    if case .goods(let goods) = goodsResult {
                        let date: Date = Date().getFormattedDate(dateString: dateString, "yyyy-MM-dd-HH-mm")
                        let watchedGoodsInfo = RecentWatchedGoodsInfo(id: UUID().uuidString, goods: goods, watchedDate: date)
                        
                        goodsRecentWatched.insert(watchedGoodsInfo)
                    }
                }
                
                let goodsIDs = docData["goods_favorited"] as? [String] ?? []
                for goodsID in goodsIDs {
                    let goodsResult = try await DataManager.shared.fetchData(type: .goods, parameter: .goodsLoad(id: goodsID))
                    
                    if case let .goods(result) = goodsResult {
                        goodsFavorited.insert(result)
                    }
                }
            }
            
            let user = User(id: id, loginMethod: loginMethod, isSeller: isSeller, name: name, profileImageURL: url, pointCount: pointCount, cart: cart, goodsRecentWatched: goodsRecentWatched, goodsFavorited: goodsFavorited)
            return user
        } catch {
            throw error
        }
    }
    
    private func getGoodsIDArray(goodsSet: Set<Goods>) -> [String] {
        var goodsIDs: [String] = []
        for goods in goodsSet {
            goodsIDs.append(goods.id)
        }
        
        return goodsIDs
    }
}
