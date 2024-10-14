//
//  UserStore.swift
//  ECO_FB_Test
//
//  Created by Jaemin Hong on 10/11/24.
// 

import Foundation
import Combine
import FirebaseFirestore

final class UserStore: ObservableObject, DataControllable {
    static let shared: UserStore = UserStore()
    private let db: Firestore = DataManager.shared.db
    @Published private(set) var userData: User? = nil
    
    private init() {}
    
    func checkIfUserExists(parameter: DataParam) async throws -> Bool {
        guard case let .userLoad(id) = parameter else {
            throw DataError.fetchError(reason: "The DataParam is not a user load")
        }
        
        do {
            let snapshot = try await db.collection("User").document(id).getDocument()
            
            return snapshot.exists
        } catch {
            throw error
        }
    }
    
    func getUserLoginMethod(parameter: DataParam) async throws -> String {
        guard case let .userLoad(id) = parameter else {
            throw DataError.fetchError(reason: "The DataParam is not a user load")
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
        guard case let .userLoad(id) = parameter else {
            throw DataError.fetchError(reason: "The DataParam is not a user load")
        }
        
        do {
            let snapshot = try await db.collection("User").document(id).getDocument()
            
            guard let docData = snapshot.data() else {
                throw DataError.fetchError(reason: "The Document Data is nil")
            }
            
            let id = snapshot.documentID
            let loginMethod = docData["login_method"] as? String ?? "none"
            let name = docData["name"] as? String ?? "none"
            let profileImageName = docData["profile_image"] as? String ?? "none"
            let pointCount = docData["point"] as? Int ?? 0
            
            var cart: Set<Goods> = []
            let goodsIDs = docData["cart"] as? [String] ?? []
            for goodsId in goodsIDs {
                let goodsResult = await DataManager.shared.fetchData(type: .goods, parameter: .goodsLoad(id: goodsId))
                
                if case let .goods(result) = goodsResult {
                    cart.insert(result)
                }
            }
            
            userData = User(id: id, loginMethod: loginMethod, name: name, profileImageName: profileImageName, pointCount: pointCount, cart: cart)
            
            return DataResult.none
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
        
        do {
            try await db.collection("User").document(id).setData([
                "login_method": user.loginMethod,
                "name": user.name,
                "profile_image": user.profileImageName,
                "point": user.pointCount,
                "cart": goodsIds
            ])
        } catch {
            throw error
        }
    }
    
    func deleteData() {
        
    }
}
