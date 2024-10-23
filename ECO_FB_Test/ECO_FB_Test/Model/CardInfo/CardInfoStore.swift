//
//  CardInfoStore.swift
//  ECO_FB_Test
//
//  Created by Jaemin Hong on 10/19/24.
// 

import Foundation
import FirebaseFirestore

final class CardInfoStore: DataControllable {
    static let shared: CardInfoStore = CardInfoStore()
    private let db: Firestore = DataManager.shared.db
    private let collectionName: String = "CardInfo"
    
    private init() {}
    
    func fetchData(parameter: DataParam) async throws -> DataResult {
        guard case let .cardInfoLoad(id) = parameter else {
            throw DataError.fetchError(reason: "The DataParam is not a card info")
        }

        do {
            let snapshot = try await db.collection(collectionName).document(id).getDocument()
            
            guard let docData = snapshot.data() else {
                throw DataError.fetchError(reason: "Can't get document data")
            }
            
            let id = snapshot.documentID
            let cvc = docData["cvc"] as? String ?? "none"
            let ownerName = docData["owner"] as? String ?? "none"
            
            let encodedCardNumber = docData["number"] as? String ?? "none"
            let cardNumber = try EncryptManager.shared.decode(encodedCardNumber)
            
            let encodedCardPassword = docData["password"] as? String ?? "none"
            let cardPassword = try EncryptManager.shared.decode(encodedCardPassword)
            
            let expirationDateString = docData["expiration_date"] as? String ?? "none"
            let expirationDate = Date().getFormattedDate(dateString: expirationDateString, "yy/MM")
            
            let cardInfo = CardInfo(id: id, cvc: cvc, ownerName: ownerName, cardNumber: cardNumber, cardPassword: cardPassword, expirationDate: expirationDate)
            
            return DataResult.cardInfo(result: cardInfo)
        } catch {
            if error is DataError {
                print("Error In Goods Store: \(error)")
                return DataResult.none
            }
            
            throw error
        }
    }
    
    func updateData(parameter: DataParam) async throws -> DataResult {
        guard case .cardInfoUpdate(let id, let cardInfo) = parameter else {
            throw DataError.updateError(reason: "The DataParam is not a card info update")
        }

        let encodedCardNumber = try EncryptManager.shared.encrypt(cardInfo.cardNumber)
        let encodedCardPassword = try EncryptManager.shared.encrypt(cardInfo.cardPassword)
        let expirationDateString = cardInfo.expirationDate.getFormattedString("yy-MM")
        
        do {
            try await db.collection(collectionName).document(id).setData([
                "cvc": cardInfo.cvc,
                "owner": cardInfo.ownerName,
                "number": encodedCardNumber,
                "password": encodedCardPassword,
                "expiration_date": expirationDateString
            ])
        } catch {
            throw error
        }
        
        return DataResult.update(isSuccess: true)
    }
    
    func deleteData(parameter: DataParam) async throws -> DataResult {
        return DataResult.delete(isSuccess: true)
    }
}
