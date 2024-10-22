//
//  OrderDetailStore.swift
//  ECO_FB_Test
//
//  Created by Jaemin Hong on 10/20/24.
// 

import Foundation
import FirebaseFirestore

final class OrderDetailStore: DataControllable {
    static let shared: OrderDetailStore = OrderDetailStore()
    private let db: Firestore = DataManager.shared.db
    private let collectionName: String = "OrderDetail"
    private let subCollectionName: String = "OrderedGoodsInfo"
    private var lastDocument: QueryDocumentSnapshot? = nil
    private(set) var orderDetailList: [OrderDetail] = []
    
    private init() {}
    
    func fetchData(parameter: DataParam) async throws -> DataResult {
        guard case let .orderDetailAll(userID, limit) = parameter else {
            throw DataError.fetchError(reason: "The DataParam is not order detail all")
        }
        
        var result: DataResult = .none
        if lastDocument == nil {
            result = try await getFirstPage(userID: userID, limit: limit)
        } else {
            result = try await getNextPage(userID: userID, limit: limit)
        }
        
        return result
    }
    
    func updateData(parameter: DataParam) async throws {
        
    }
    
    func deleteData(parameter: DataParam) async throws {
        
    }
    
    private func getFirstPage(userID: String, limit: Int) async throws -> DataResult {
        do {
            let snapshots = try await db.collection(collectionName)
                                      .whereField("user_id", isEqualTo: userID)
                                      .order(by: "order_date")
                                      .limit(to: limit)
                                      .getDocuments()
            
            for document in snapshots.documents {
                let orderDetail = try await getData(document: document)
                orderDetailList.append(orderDetail)
            }
            lastDocument = snapshots.documents.last
            
            return DataResult.none
        } catch {
            throw error
        }
    }
    
    private func getNextPage(userID: String, limit: Int) async throws -> DataResult {
        guard let last = lastDocument else { return DataResult.none }
        
        do {
            let snapshots = try await db.collection(collectionName)
                                      .whereField("user_id", isEqualTo: userID)
                                      .order(by: "order_date")
                                      .start(afterDocument: last)
                                      .limit(to: limit)
                                      .getDocuments()
            
            for document in snapshots.documents {
                let orderDetail = try await getData(document: document)
                orderDetailList.append(orderDetail)
            }
            lastDocument = snapshots.documents.last
            
            return DataResult.none
        } catch {
            throw error
        }
    }
    
    private func getData(document: QueryDocumentSnapshot) async throws -> OrderDetail {
        do {
            let docData = document.data()
            
            let id = document.documentID
            let userID = docData["user_id"] as? String ?? "none"
            
            let paymentInfoID = docData["payment_info_id"] as? String ?? "none"
            let paymentInfoResult = await DataManager.shared.fetchData(type: .paymentInfo, parameter: .paymentInfoLoad(id: paymentInfoID)) { _ in
                
            }
            
            let orderDateString = docData["order_date"] as? String ?? "none"
            let orderDate = Date().getFormattedDate(dateString: orderDateString, "yyyy-MM-dd-HH-mm")
            
            let snapshots = try await document.reference.collection(subCollectionName).getDocuments()
            var orderedGoodsInfoList: [OrderedGoodsInfo] = []
            
            for document in snapshots.documents {
                let orderedGoodsInfo = try await getOrderedGoodsInfo(document: document)
                orderedGoodsInfoList.append(orderedGoodsInfo)
            }
            
            guard case let .paymentInfo(paymentInfo) = paymentInfoResult else {
                throw DataError.fetchError(reason: "Can't get payment info data")
            }
            
            let orderDetail = OrderDetail(id: id, userID: userID, paymentInfo: paymentInfo, orderedGoodsInfos: orderedGoodsInfoList, orderDate: orderDate)
            return orderDetail
        } catch {
            throw error
        }
    }
    
    private func getOrderedGoodsInfo(document: QueryDocumentSnapshot) async throws -> OrderedGoodsInfo {
        let docData = document.data()
        
        let id = document.documentID
        
        let deliveryStatusString = docData["delivery_status"] as? String ?? "none"
        let deliveryStatus = stringToDeliveryStatus(deliveryStatusString)
        
        let orderedGoodsWithCount = docData["goods_with_count"] as? [String] ?? []
        var orderedGoodsList: [OrderedGoods] = []
        
        for orderedGoods in orderedGoodsWithCount {
            let splitResult = orderedGoods.components(separatedBy: "_")
            let goodsID = splitResult[0]
            let count = Int(splitResult[1])!
            
            let goodsResult = await DataManager.shared.fetchData(type: .goods, parameter: .goodsLoad(id: goodsID)) { _ in
                
            }
            
            guard case let .goods(goods) = goodsResult else {
                throw DataError.fetchError(reason: "Can't get goods data")
            }

            let orderedGoods = OrderedGoods(id: UUID().uuidString, goods: goods, count: count)
            orderedGoodsList.append(orderedGoods)
        }
        
        let orderedGoodsInfo = OrderedGoodsInfo(id: id, deliveryStatus: deliveryStatus, goodsList: orderedGoodsList)
        return orderedGoodsInfo
    }
    
    private func stringToDeliveryStatus(_ deliveryStatus: String) -> DeliveryStatus {
        switch deliveryStatus {
        case DeliveryStatus.shipped.rawValue:
            return .shipped
        case DeliveryStatus.inDelivery.rawValue:
            return .inDelivery
        default:
            return .delivered
        }
    }
}
