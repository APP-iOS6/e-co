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
            
            let paymentInfo = try await getData(id: id, docData: docData)
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
                
                let paymentInfo = try await getData(id: id, docData: docData)
                paymentList.append(paymentInfo)
            }
            
            return DataResult.none
        } catch {
            throw error
        }
    }
    
    private func getData(id: String, docData: [String: Any]) async throws -> PaymentInfo {
        let userID = docData["user_id"] as? String ?? "none"
        let recipientName = docData["recipient_name"] as? String ?? "none"
        let phoneNumber = docData["phone_number"] as? String ?? "none"
        
        let paymentMethodString = docData["payment_method_name"] as? String ?? "none"
        let paymentMethodName = stringToPaymentMethod(paymentMethodString)
        var paymentMethod: CardInfo? = nil
        
        if paymentMethodName == .card {
            let paymentMethodID = docData["payment_method_id"] as? String ?? "none"
            let cardInfoResult = await DataManager.shared.fetchData(type: .cardInfo, parameter: .cardInfoLoad(id: paymentMethodID)) { _ in
                
            }
            
            guard case .cardInfo(let result) = cardInfoResult else {
                throw DataError.fetchError(reason: "Can't get card info")
            }
            
            paymentMethod = result
        }
        
        let address = docData["address"] as? String ?? "none"
        
        let paymentInfo = PaymentInfo(id: id, userID: userID, recipientName: recipientName, phoneNumber: phoneNumber, paymentMethod: paymentMethodName, paymentMethodInfo: paymentMethod, address: address)
        return paymentInfo
    }
    
    private func stringToPaymentMethod(_ method: String) -> PaymentMethod {
        var paymentMethod: PaymentMethod = .none
        
        switch method {
        case PaymentMethod.card.rawValue:
            paymentMethod = .card
        case PaymentMethod.bank.rawValue:
            paymentMethod = .bank
        default:
            paymentMethod = .point
        }
        
        return paymentMethod
    }
}
