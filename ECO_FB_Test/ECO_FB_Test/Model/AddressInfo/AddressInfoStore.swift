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
    
    private init() {
        Task {
            let snapshot = try await db.collection(collectionName).getDocuments()
            for document in snapshot.documents {
                let id = document.documentID
                let result = try await DataManager.shared.fetchData(type: .addressInfo, parameter: .addressInfoLoad(id: id))
                
                if case .addressInfo(var addressInfo) = result {
                    addressInfo.detailAddress = "철수 아파트 120동 1202호"
                    try await DataManager.shared.updateData(type: .addressInfo, parameter: .addressInfoUpdate(id: id, addressInfo: addressInfo))
                }
            }
        }
    }
    
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
            let detailAddress = docData["detail_address"] as? String ?? "none"
            
            let addressInfo = AddressInfo(id: id, recipientName: recipientName, phoneNumber: phoneNumber, address: address, detailAddress: detailAddress)
            return DataResult.addressInfo(result: addressInfo)
        } catch {
            if error is DataError {
                print("Error In AddressInfo Store: \(error)")
                return DataResult.none
            }
            
            throw error
        }
    }
    
    func updateData(parameter: DataParam) async throws -> DataResult {
        guard case .addressInfoUpdate(let id, let addressInfo) = parameter else {
            throw DataError.fetchError(reason: "The DataParam is not a address info update")
        }

        do {
            try await db.collection(collectionName).document(id).setData([
                "recipient_name": addressInfo.recipientName,
                "phone_number": addressInfo.phoneNumber,
                "address": addressInfo.address,
                "detail_address": addressInfo.detailAddress
            ])
        } catch {
            throw error
        }
        
        return DataResult.update(isSuccess: true)
    }
    
    func deleteData(parameter: DataParam) async throws -> DataResult {
        guard case .addressInfoDelete(let id) = parameter else {
            throw DataError.deleteError(reason: "The DataParam is not a address info delete")
        }

        do {
            try await db.collection(collectionName).document(id).delete()
        } catch {
            throw error
        }
        
        return DataResult.delete(isSuccess: true)
    }
}
