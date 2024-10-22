//
//  AddressInfoStore.swift
//  ECO_FB_Test
//
//  Created by Jaemin Hong on 10/22/24.
// 

import Foundation
import FirebaseFirestore

final class AddressInfoStore: DataControllable {
    static let shared: AddressInfoStore = AddressInfoStore()
    private let db: Firestore = DataManager.shared.db
    private let collectionName: String = "AddressInfo"
    
    private init() {}
    
    func fetchData(parameter: DataParam) async throws -> DataResult {
        guard case let .addressInfoLoad(id) = parameter else {
            throw DataError.fetchError(reason: "The DataParam is not a address info load")
        }
        
        do {
            let snapshot = try await db.collection(collectionName).document(id).getDocument()
            
            guard let docData = snapshot.data() else {
                throw DataError.fetchError(reason: "Can't get document data")
            }
            
            let id = snapshot.documentID
            let recipientName = docData["recipient_name"] as? String ?? "none"
            let phoneNumber = docData["phone_number"] as? String ?? "none"
            let address = docData["address"] as? String ?? "none"
            
            let addressInfo = AddressInfo(id: id, recipientName: recipientName, phoneNumber: phoneNumber, address: address)
            return DataResult.addressInfo(result: addressInfo)
        } catch {
            throw error
        }
    }
    
    func updateData(parameter: DataParam) async throws {
        
    }
    
    func deleteData(parameter: DataParam) async throws {
        
    }
}
