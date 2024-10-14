//
//  AdminStore.swift
//  ECO_FB_Test
//
//  Created by Jaemin Hong on 10/11/24.
// 

import Foundation
import FirebaseFirestore

final class AdminStore: ObservableObject, DataControllable {
    static let shared: AdminStore = AdminStore()
    private let db: Firestore = DataManager.shared.db
    @Published private(set) var adminData: Admin? = nil
    
    private init() {}
    
    func fetchData(parameter: DataParam) async throws -> DataResult {
        guard case let .adminLoad(id) = parameter else {
            throw DataError.fetchError(reason: "The DataParam is not a admin load")
        }
        
        do {
            let snapshot = try await db.collection("Admin").document("\(id)").getDocument()
            
            guard let docData = snapshot.data() else {
                throw DataError.fetchError(reason: "The Document Data is nil")
            }
            
            let id = snapshot.documentID
            let name = docData["name"] as? String ?? "none"
            let profileImageName = docData["profile_image"] as? String ?? "none"
            
            adminData = Admin(id: id, name: name, profileImageName: profileImageName)
            
            return DataResult.none
        } catch {
            throw error
        }
    }
    
    func updateData(parameter: DataParam) async throws {
        guard case let .adminUpdate(id, admin) = parameter else {
            throw DataError.fetchError(reason: "The DataParam is not a admin update")
        }
        
        do {
            try await db.collection("Admin").document(id).setData([
                "name": admin.name,
                "profile_image": admin.profileImageName,
            ])
        } catch {
            throw error
        }
    }
    
    func deleteData() {
        
    }
}
