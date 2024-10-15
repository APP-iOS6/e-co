//
//  OrderInfoStore.swift
//  ECO_FB_Test
//
//  Created by Jaemin Hong on 10/14/24.
// 

import Foundation
import FirebaseFirestore

@Observable
final class PaymentInfoStore: DataControllable {
    static let shared: PaymentInfoStore = PaymentInfoStore()
    private let db: Firestore = DataManager.shared.db
    private(set) var paymentList: [PaymentInfo] = []
    
    private init() {}
    
    func fetchData(parameter: DataParam) async throws -> DataResult {
        do {
            var result = DataResult.none
            if case .paymentInfoAll(let userID) = parameter {
                result = try await getPaymentInfoAll(userID: userID)
            } else if case .paymentInfoLoad(let id) = parameter {
                result = try await getPaymentInfoByID(id)
            } else {
                throw DataError.fetchError(reason: "The DataParam is not a payment info load or payment info all")
            }
            
            return result
        } catch {
            throw error
        }
    }
    
    func updateData(parameter: DataParam) async throws {
        
    }
    
    func deleteData() {
        
    }
    
    private func getPaymentInfoByID(_ id: String) async throws -> DataResult {
        do {
            let snapshot = try await db.collection("PaymentInfo").document(id).getDocument()
            
            guard let docData = snapshot.data() else {
                throw DataError.fetchError(reason: "The Document Data is nil")
            }
            
            let id = snapshot.documentID
            
            let paymentInfo = getData(id: id, docData: docData)
            return DataResult.paymentInfo(result: paymentInfo)
        } catch {
            throw error
        }
    }
    
    private func getPaymentInfoAll(userID: String) async throws -> DataResult {
        paymentList.removeAll()
        
        do {
            let snapshots = try await db.collection("PaymentInfo")
                            .whereField("user_id", isEqualTo: userID)
                            .getDocuments()
            
            for document in snapshots.documents {
                let docData = document.data()
                
                let id = document.documentID
                
                let paymentInfo = getData(id: id, docData: docData)
                paymentList.append(paymentInfo)
            }
            
            return DataResult.none
        } catch {
            throw error
        }
    }
    
    private func getData(id: String, docData: [String: Any]) -> PaymentInfo {
        let userID = docData["user_id"] as? String ?? "none"
        let address = docData["address"] as? String ?? "none"
        let payment = docData["payment_method"] as? [String] ?? []
        
        let paymentInfo = PaymentInfo(id: id, userID: userID, address: address, paymentMethod: payment)
        return paymentInfo
    }
}
