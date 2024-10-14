//
//  SellerStore.swift
//  ECO_FB_Test
//
//  Created by Jaemin Hong on 10/12/24.
// 

import Foundation
import FirebaseFirestore

final class SellerStore: DataControllable {
    static let shared: SellerStore = SellerStore()
    private let db: Firestore = DataManager.shared.db
    
    private init() {}
    
    func fetchData(parameter: DataParam) async throws -> DataResult {
        guard case let .sellerLoad(id) = parameter else {
            throw DataError.fetchError(reason: "The DataParam is not a seller load")
        }
        
        do {
            let snapshot = try await db.collection("Seller").document(id).getDocument()
            
            guard let docData = snapshot.data() else {
                throw DataError.fetchError(reason: "The Document Data is nil")
            }
            
            let id = snapshot.documentID
            let name = docData["name"] as? String ?? "none"
            let profileImageName = docData["profile_image"] as? String ?? "none"
            
            let seller = Seller(id: id, name: name, profileImageName: profileImageName)
            
            return DataResult.seller(result: seller)
        } catch {
            throw error
        }
    }
    
    func updateData(parameter: DataParam) async throws {
        
    }
    
    func deleteData() {
        
    }
}
