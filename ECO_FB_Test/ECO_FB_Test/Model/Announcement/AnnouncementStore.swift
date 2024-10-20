//
//  AnnouncementStore.swift
//  ECO_FB_Test
//
//  Created by Jaemin Hong on 10/14/24.
// 

import Foundation
import FirebaseFirestore

@Observable
final class AnnouncementStore: DataControllable {
    static let shared: AnnouncementStore = AnnouncementStore()
    private let db: Firestore = DataManager.shared.db
    private let limitSize: Int = 20
    private var isFirstFetch: Bool = true
    private var lastDocument: DocumentSnapshot? = nil
    private(set) var announcementList: [Announcement] = []
    
    private init() {}
    
    func fetchData(parameter: DataParam) async throws -> DataResult {
        guard case .announcementAll = parameter else {
            throw DataError.fetchError(reason: "The DataParam is not a announcement all")
        }
        
        do {
            var result = DataResult.none
            if isFirstFetch {
                isFirstFetch = false
                result = try await getFirstPage()
            } else {
                result = try await getNextPage()
            }
            
            return result
        } catch {
            throw error
        }
    }
    
    func updateData(parameter: DataParam) async throws {
        guard case let .announcementUpdate(id, announcement) = parameter else {
            throw DataError.updateError(reason: "The DataParam is not a announcement update")
        }
        
        do {
            try await db.collection("Announcement").document(id).setData([
                "admin_id": announcement.admin.id,
                "content": announcement.content,
                "creation_date": announcement.creationDate.getFormattedString("yyyy-MM-dd-HH-mm")
            ])
        } catch {
            throw error
        }
    }
    
    func deleteData(parameter: DataParam) async throws {
        
    }
    
    private func getFirstPage() async throws -> DataResult {
        do {
            let snapshots = try await db.collection("Announcement")
                                      .order(by: "creation_date")
                                      .limit(to: limitSize)
                                      .getDocuments()
            
            for document in snapshots.documents {
                let announcement = try await getData(document: document)
                announcementList.append(announcement)
            }
            
            lastDocument = snapshots.documents.last
            return DataResult.none
        } catch {
            throw error
        }
    }
    
    private func getNextPage() async throws -> DataResult {
        guard let lastDocument else { return DataResult.none }
        
        do {
            let snapshots = try await db.collection("Announcement")
                                      .order(by: "creation_date")
                                      .start(afterDocument: lastDocument)
                                      .limit(to: limitSize)
                                      .getDocuments()
            
            for document in snapshots.documents {
                let announcement = try await getData(document: document)
                announcementList.append(announcement)
            }
            
            self.lastDocument = snapshots.documents.last
            return DataResult.none
        } catch {
            throw error
        }
    }
    
    private func getData(document: QueryDocumentSnapshot) async throws -> Announcement {
        let docData = document.data()
        
        let id = document.documentID
        let title = docData["title"] as? String ?? "none"
        let content = docData["content"] as? String ?? "none"
        
        let adminID = docData["admin_id"] as? String ?? "none"
        let admin = await DataManager.shared.fetchData(type: .user, parameter: .userLoad(id: adminID, shouldReturnUser: true)) { _ in
            
        }
        
        guard case let DataResult.user(result) = admin else {
            throw DataError.convertError(reason: "DataResult is not a user")
        }

        let creationDateString = docData["creation_date"] as? String ?? "none"
        let creationDate = Date().getFormattedDate(dateString: creationDateString, "yyyy-MM-dd-HH-mm")
        
        let announcement = Announcement(id: id, admin: result, title: title, content: content, creationDate: creationDate)
        return announcement
    }
}
