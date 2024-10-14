//
//  OrderInfoStore.swift
//  ECO_FB_Test
//
//  Created by Jaemin Hong on 10/14/24.
// 

import Foundation
import FirebaseFirestore

final class PaymentInfoStore: DataControllable {
    static let shared: PaymentInfoStore = PaymentInfoStore()
    private let db: Firestore = DataManager.shared.db
    private(set) var paymentList: [PaymentInfo] = []
    
    private init() {}
    
    func fetchData(parameter: DataParam) async throws -> DataResult {
        do {
            if case .paymentInfoAll(_) = parameter {
                return try await getPaymentInfoAll(parameter: parameter)
            } else if case .paymentInfoLoad(_, _) = parameter {
                return try await getPaymentInfoByID(parameter: parameter)
            } else {
                throw DataError.fetchError(reason: "The DataParam is not a payment info load or payment info all")
            }
        } catch {
            throw error
        }
    }
    
    func updateData(parameter: DataParam) async throws {
        
    }
    
    func deleteData() {
        
    }
    
    private func getPaymentInfoByID(parameter: DataParam) async throws -> DataResult {
        guard case let .paymentInfoLoad(id, userID) = parameter else {
            throw DataError.fetchError(reason: "The DataParam is not a payment info load")
        }
        
        do {
            let snapshots = try await db.collection("PaymentInfo")
                .whereField("user_id", isEqualTo: userID)
                .whereField(FieldPath.documentID(), isEqualTo: id)
                .getDocuments()
            
            guard let snapshot = snapshots.documents.first else { throw DataError.fetchError(reason: "Invalid ID") }
            
            let docData = snapshot.data()
            
            let id = snapshot.documentID
            let userID = docData["user_id"] as? String ?? "none"
            let address = docData["address"] as? String ?? "none"
            let payment = docData["payment_method"] as? [String] ?? []
            
            let paymentInfo = PaymentInfo(id: id, userID: userID, address: address, paymentMethod: payment)
            return DataResult.paymentInfo(result: paymentInfo)
        } catch {
            throw error
        }
    }
    
    private func getPaymentInfoAll(parameter: DataParam) async throws -> DataResult {
        guard case let .paymentInfoAll(userID) = parameter else {
            throw DataError.fetchError(reason: "The DataParam is not a payment info all")
        }

        paymentList.removeAll()
        
        do {
            let snapshots = try await db.collection("PaymentInfo")
                            .whereField("user_id", isEqualTo: userID)
                            .getDocuments()
            
            for document in snapshots.documents {
                let docData = document.data()
                
                let id = document.documentID
                let userID = docData["user_id"] as? String ?? "none"
                let address = docData["address"] as? String ?? "none"
                let payment = docData["payment_method"] as? [String] ?? []
                
                let paymentInfo = PaymentInfo(id: id, userID: userID, address: address, paymentMethod: payment)
                paymentList.append(paymentInfo)
            }
            
            return DataResult.none
        } catch {
            throw error
        }
    }
}
