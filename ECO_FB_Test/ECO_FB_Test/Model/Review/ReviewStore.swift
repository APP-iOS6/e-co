//
//  ReviewStore.swift
//  ECO_FB_Test
//
//  Created by Jaemin Hong on 10/21/24.
// 

import Foundation
import FirebaseFirestore

@Observable
final class ReviewStore: DataControllable {
    static let shared: ReviewStore = ReviewStore()
    private let db: Firestore = DataManager.shared.db
    private let collectionName: String = "Review"
    private var lastDocuments: [String: QueryDocumentSnapshot?] = [:]
    
    private init() {}
    
    func fetchData(parameter: DataParam) async throws -> DataResult {
        guard case .reviewAll(let goodsID, let limit, let result) = parameter else {
            throw DataError.fetchError(reason: "The DataParam is not a review all")
        }
        
        var dataResult: DataResult = .review(result: result)
        
        if result.isEmpty {
            dataResult = try await getFirstPage(id: goodsID, limit: limit, result: result)
        } else {
            dataResult = try await getNextPage(id: goodsID, limit: limit, result: result)
        }
        
        return dataResult
    }
    
    func updateData(parameter: DataParam) async throws -> DataResult {
        guard case .reviewUpdate(let id, let review) = parameter else {
            throw DataError.fetchError(reason: "The DataParam is not a review update")
        }

        let creationDateString = review.creationDate.getFormattedString("yyyy-MM-dd-HH-mm")
        var contentImageURLStrings: [String] = []
        
        for contentImageURL in review.contentImages {
            contentImageURLStrings.append(contentImageURL.absoluteString)
        }
        
        do {
            try await db.collection(collectionName).document(id).setData([
                "user_id": review.user.id,
                "goods_id": review.goodsID,
                "title": review.title,
                "body_content": review.content,
                "body_images": contentImageURLStrings,
                "star_count": review.starCount,
                "creation_date": creationDateString
            ])
        }
        
        return DataResult.update(isSuccess: true)
    }
    
    func deleteData(parameter: DataParam) async throws -> DataResult {
        guard case .reviewDelete(let id) = parameter else {
            throw DataError.deleteError(reason: "The DataParam is not a review delete")
        }

        do {
            try await db.collection(collectionName).document(id).delete()
        } catch {
            throw error
        }
        
        return DataResult.delete(isSuccess: true)
    }
    
    private func getFirstPage(id: String, limit: Int, result: [Review]) async throws -> DataResult {
        var resultList = result
        
        do {
            let snapshots = try await db.collection(collectionName)
                                      .whereField("goods_id", isEqualTo: id)
                                      .order(by: "star_count")
                                      .order(by: "creation_date")
                                      .limit(to: limit)
                                      .getDocuments()
            
            for document in snapshots.documents {
                let review = try await getData(document: document)
                resultList.append(review)
            }
            
            lastDocuments[id] = snapshots.documents.last
        } catch {
            throw error
        }
        
        return DataResult.review(result: resultList)
    }
    
    private func getNextPage(id: String, limit: Int, result: [Review]) async throws -> DataResult {
        guard let dictionaryResult = lastDocuments[id], let last = dictionaryResult else {
            return DataResult.review(result: result)
        }
        
        var resultList = result
            
        do {
            let snapshots = try await db.collection(collectionName)
                                      .whereField("goods_id", isEqualTo: id)
                                      .order(by: "star_count")
                                      .order(by: "creation_date")
                                      .start(afterDocument: last)
                                      .limit(to: limit)
                                      .getDocuments()
            
            for document in snapshots.documents {
                let review = try await getData(document: document)
                resultList.append(review)
            }
            
            lastDocuments[id] = snapshots.documents.last
        } catch {
            throw error
        }
        
        return DataResult.review(result: resultList)
    }
    
    private func getData(document: QueryDocumentSnapshot) async throws -> Review {
        do {
            let docData = document.data()
            
            let id = document.documentID
            
            let userID = docData["user_id"] as? String ?? "none"
            let user = try await DataManager.shared.fetchData(type: .user, parameter: .userLoad(id: userID, shouldReturnUser: true))
            
            let goodsID = docData["goods_id"] as? String ?? "none"
            
            let title = docData["title"] as? String ?? "none"
            let content = docData["body_content"] as? String ?? "none"
            
            let contentURLStrings = docData["body_images"] as? [String] ?? []
            var contentURLs: [URL] = []
            
            for urlString in contentURLStrings {
                guard let url = URL(string: urlString) else {
                    throw DataError.convertError(reason: "Can't get url from content url array")
                }
                
                contentURLs.append(url)
            }
            
            let starCount = docData["star_count"] as? Int ?? 0
            
            let creationDateString = docData["creation_date"] as? String ?? "none"
            let creationDate = Date().getFormattedDate(dateString: creationDateString, "yyyy-MM-dd-HH-mm")
            
            guard case .user(let result) = user else {
                throw DataError.fetchError(reason: "Can't get user data")
            }
            
            let review = Review(id: id, user: result, goodsID: goodsID, title: title, content: content, contentImages: contentURLs, starCount: starCount, creationDate: creationDate)
            return review
        } catch {
            throw error
        }
    }
}
