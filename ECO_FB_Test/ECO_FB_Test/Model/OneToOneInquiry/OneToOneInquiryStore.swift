//
//  OneToOneInquiryStore.swift
//  ECO_FB_Test
//
//  Created by Jaemin Hong on 10/20/24.
// 

import Foundation
import FirebaseFirestore

@Observable
final class OneToOneInquiryStore: DataControllable{
    static let shared: OneToOneInquiryStore = OneToOneInquiryStore()
    private let db: Firestore = DataManager.shared.db
    private let collectionName: String = "OneToOneInquiry"
    private var lastDocument: QueryDocumentSnapshot? = nil
    private(set) var oneToOneInquiryList: [OneToOneInquiry] = []
    
    private init() {}
    
    func fetchData(parameter: DataParam) async throws -> DataResult {
        var queryFieldName: String = ""
        var id: String = ""
        var fetchLimit: Int = 0
        
        if case let .oneToOneInquiryAllWithSeller(sellerID, limit) = parameter {
            queryFieldName = "seller_id"
            id = sellerID
            fetchLimit = limit
        } else if case let .oneToOneInquiryAllWithUser(userID, limit) = parameter {
            queryFieldName = "user_id"
            id = userID
            fetchLimit = limit
        } else {
            throw DataError.fetchError(reason: "The DataParam is not a oneToOneInquiry all")
        }
        
        var result = DataResult.none
        if oneToOneInquiryList.isEmpty {
            result = try await getFirstPage(queryFieldName: queryFieldName, id: id, limit: fetchLimit)
        } else {
            result = try await getNextPage(queryFieldName: queryFieldName, id: id, limit: fetchLimit)
        }
        
        return result
    }
    
    func updateData(parameter: DataParam) async throws {
        guard case .oneToOneInquiryUpdate(let id, let inquiry) = parameter else {
            throw DataError.updateError(reason: "The DataParam is not a oneToOneInquiry update")
        }
        
        do {
            try await db.collection(collectionName).document(id).setData([
                "creation_date": inquiry.creationDate.getFormattedString("yyyy-MM-dd-HH-mm"),
                "user_id": inquiry.user.id,
                "seller_id": inquiry.seller.id,
                "title": inquiry.title,
                "question": inquiry.question,
                "answer": inquiry.answer
            ])
        } catch {
            throw error
        }
    }
    
    func deleteData(parameter: DataParam) async throws {
        guard case .oneToOneInquiryDelete(let id) = parameter else {
            throw DataError.deleteError(reason: "The DataParam is not a oneToOneInquiry delete")
        }
        
        do {
            try await db.collection(collectionName).document(id).delete()
        } catch {
            throw error
        }
    }
    
    private func getFirstPage(queryFieldName: String, id: String, limit: Int) async throws -> DataResult {
        do {
            let snapshots = try await db.collection(collectionName)
                                      .whereField(queryFieldName, isEqualTo: id)
                                      .order(by: "creation_date")
                                      .limit(to: limit)
                                      .getDocuments()
            
            for document in snapshots.documents {
                let oneToOneInquiry = try await getData(document: document)
                oneToOneInquiryList.append(oneToOneInquiry)
            }
            lastDocument = snapshots.documents.last
            
            return DataResult.none
        } catch {
            throw error
        }
    }
    
    private func getNextPage(queryFieldName: String, id: String, limit: Int) async throws -> DataResult {
        guard let lastDocument else { return DataResult.none }
        
        do {
            let snapshots = try await db.collection(collectionName)
                                      .whereField(queryFieldName, isEqualTo: id)
                                      .order(by: "creation_date")
                                      .start(afterDocument: lastDocument)
                                      .limit(to: limit)
                                      .getDocuments()
            
            for document in snapshots.documents {
                let oneToOneInquiry = try await getData(document: document)
                oneToOneInquiryList.append(oneToOneInquiry)
            }
            self.lastDocument = snapshots.documents.last
            
            return DataResult.none
        } catch {
            throw error
        }
    }
    
    private func getData(document: QueryDocumentSnapshot) async throws -> OneToOneInquiry {
        let docData = document.data()
        
        let id = document.documentID
        
        let creationDateString = docData["creation_date"] as? String ?? "none"
        let creationDate = Date().getFormattedDate(dateString: creationDateString, "yyyy-MM-dd-HH-mm")
        
        let userID = docData["user_id"] as? String ?? "none"
        let userResult = await DataManager.shared.fetchData(type: .user, parameter: .userLoad(id: userID, shouldReturnUser: true)) { _ in
            
        }

        let sellerID = docData["seller_id"] as? String ?? "none"
        let sellerResult = await DataManager.shared.fetchData(type: .user, parameter: .userLoad(id: sellerID, shouldReturnUser: true)) { _ in
            
        }

        let title = docData["title"] as? String ?? "none"
        let question = docData["question"] as? String ?? "none"
        let answer = docData["answer"] as? String ?? "none"
        
        guard case let .user(user) = userResult else {
            throw DataError.convertError(reason: "Can't get user date from .user(result)")
        }
        
        guard case let .user(seller) = sellerResult else {
            throw DataError.convertError(reason: "Can't get seller date from .user(result)")
        }
        
        let oneToOneInquiry = OneToOneInquiry(id: id, creationDate: creationDate, user: user, seller: seller, title: title, question: question, answer: answer)
        
        return oneToOneInquiry
    }
    
    //재민님 기존 메소드 제외 새로 만든 메소드들(기존 메소드는 건들지 않았습니다)
    
    //질문 보내기
    func saveInquiry(inquiry: OneToOneInquiry) async throws {
           do {
               let _ = try await db.collection(collectionName).document(inquiry.id).setData([
                   "creation_date": inquiry.creationDate.getFormattedString("yyyy-MM-dd-HH-mm"),
                   "user_id": inquiry.user.id,
                   "seller_id": inquiry.seller.id,
                   "title": inquiry.title,
                   "question": inquiry.question,
                   "answer": inquiry.answer
               ])
               oneToOneInquiries.append(inquiry)
           } catch {
               throw error
           }
       }
   
    //답변 업데이트
    func updateInquiryAnswer(inquiryID: String, answer: String) async throws {
          let inquiryRef = db.collection(collectionName).document(inquiryID)
        
          // Firestore 답변 업데이트
          try await inquiryRef.updateData([
              "answer": answer,
            //  "creation_date":Date().getFormattedDate(dateString: creationDateString, "yyyy-MM-dd-HH-mm")// 시간찍기
          ])
      }
    
    func removeAll() {
           oneToOneInquiries.removeAll()
       }
}
