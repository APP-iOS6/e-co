//
//  ZeroWasteShopStore.swift
//  ECO_FB_Test
//
//  Created by Jaemin Hong on 10/15/24.
// 

import Foundation
import CoreLocation
import FirebaseFirestore

@Observable
final class ZeroWasteShopStore: DataControllable {
    static let shared: ZeroWasteShopStore = ZeroWasteShopStore()
    private let db: Firestore = DataManager.shared.db
    private let collectionName: String = "ZeroWasteStore"
    private(set) var zeroWasteShopList: [ZeroWasteShop] = []
    
    private init() {
        Task {
            _ = await DataManager.shared.fetchData(type: .zeroWasteShop, parameter: .zeroWasteShopLoadAll) { _ in
                
            }
        }
    }
    
    func fetchData(parameter: DataParam) async throws -> DataResult {
        guard case .zeroWasteShopLoadAll = parameter else {
            throw DataError.fetchError(reason: "The DataParam is not a zero waste store all")
        }
        
        zeroWasteShopList.removeAll()
        
        do {
            let snapshot = try await db.collection(collectionName).getDocuments()
            
            for document in snapshot.documents {
                let docData = document.data()
                
                let id = document.documentID
                let name = docData["name"] as? String ?? "none"
                let phoneNumber = docData["phone_number"] as? String ?? "none"
                
                guard let geoPoint = docData["position"] as? GeoPoint else {
                    throw DataError.fetchError(reason: "The field named 'position' doesn't exist")
                }
                let position = CLLocationCoordinate2D(latitude: geoPoint.latitude, longitude: geoPoint.longitude)
                
                let zeroWasteShop = ZeroWasteShop(id: id, name: name, phoneNumber: phoneNumber, position: position)
                zeroWasteShopList.append(zeroWasteShop)
            }
            
            return DataResult.none
        } catch {
            throw error
        }
    }
    
    func updateData(parameter: DataParam) async throws {
        
    }
    
    func deleteData(parameter: DataParam) async throws {
        
    }
}
