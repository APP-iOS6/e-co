//
//  ECO_FB_TestTests.swift
//  ECO_FB_Test
//
//  Created by Jaemin Hong on 10/11/24.
// 

import XCTest
@testable import ECO_FB_Test

final class ECO_FB_TestTests: XCTestCase {
    
    func testPriorityQueue() {
        var priorityQueue = PriorityQueue<Int> { $0 > $1 }
        priorityQueue.enqueue(1)
        priorityQueue.enqueue(5)
        priorityQueue.enqueue(2)
        priorityQueue.enqueue(15)
        priorityQueue.enqueue(98)
        priorityQueue.enqueue(3)
        
        var result = priorityQueue.dequeue()
        var expect = 98
        result = priorityQueue.dequeue()
        expect = 15
        
        XCTAssertEqual(result!, expect)
        
//        result = priorityQueue.dequeue()
//        expect = 2
//        XCTAssertEqual(result!, expect)
//        
//        result = priorityQueue.dequeue()
//        expect = 3
//        XCTAssertEqual(result!, expect)
    }
    
    func testGetAddress() async throws {
        let result = try await SearchedAddressStore.shared.getAddresses(query: "제주특별자치도 제주시 첨단로")
       
        for document in result.documents {
            if let address = document.address {
                print("addressName: \(address.addressName)")
                print("mainAddressNumber: \(address.mainAddressNumber)")
                print("subAddressNumber: \(address.subAddressNumber)")
            }
            
            print("addressName: \(document.roadAddress.addressName)")
            print("buildingName: \(document.roadAddress.buildingName ?? "")")
            print("mainBuildingNumber: \(document.roadAddress.mainBuildingNumber)")
            print("region1DepthName: \(document.roadAddress.region1DepthName)")
            print("region2DepthName: \(document.roadAddress.region2DepthName)")
            print("region3DepthName: \(document.roadAddress.region3DepthName)")
            print("roadName: \(document.roadAddress.roadName)")
            print("zoneNumber: \(document.roadAddress.zoneNumber)")
            
            print("addressName: \(document.addressName)")
            print("addressType: \(document.addressType)")
            print("x: \(document.x)")
            print("y: \(document.y)")
            print("==================================")
        }
    }
//
//    func testOneToOneInquiryWithUserFetch() async throws {
//        _ = await DataManager.shared.fetchData(type: .oneToOneInquiry, parameter: .oneToOneInquiryAllWithUser(userID: "dnjsgh4829@hs.ac.kr", limit: 100)) { _ in
//            
//        }
//        
//        print(await OneToOneInquiryStore.shared.oneToOneInquiryList)
//    }
//    
//    
//
    func testOrderDetailFetch() async throws {
        _ = try await DataManager.shared.fetchData(type: .orderDetail, parameter: .orderDetailAll(userID: "idntno0505@gmail.com", limit: 500))
        
        print(await OrderDetailStore.shared.orderDetailList)
    }
    
    func testOrderDetailUpdate() async throws {
        let id = UUID().uuidString
        let paymentInfoResult = try await DataManager.shared.fetchData(type: .paymentInfo, parameter: .paymentInfoLoad(id: "212B4A49-26DE-46A9-9AF3-88FF6D66B3FB"))
        
        let goodsResult = try await DataManager.shared.fetchData(type: .goods, parameter: .goodsLoad(id: "04836B83-100F-4DEA-B686-C1C167982CED"))
        
        let goodsResult2 = try await DataManager.shared.fetchData(type: .goods, parameter: .goodsLoad(id: "04BC4400-F95C-43D6-8EED-B9404BFC6DC7"))
        
        guard case .paymentInfo(let result) = paymentInfoResult else {
            throw DataError.fetchError(reason: "cant get paymentinfo data")
        }
        
        guard case .goods(let goods) = goodsResult else {
            throw DataError.fetchError(reason: "cant get goods data")
        }
        
        guard case .goods(let goods2) = goodsResult2 else {
            throw DataError.fetchError(reason: "cant get goods data")
        }
        
        let orderedInfos: [OrderedGoodsInfo] = [
            OrderedGoodsInfo(id: "seller@seller.com", deliveryStatus: .inDelivery, goodsList: [
                OrderedGoods(id: UUID().uuidString, goods: goods, count: 5),
                OrderedGoods(id: UUID().uuidString, goods: goods2, count: 100)
            ]),
            
            OrderedGoodsInfo(id: "seller@seller.com", deliveryStatus: .inDelivery, goodsList: [
                OrderedGoods(id: UUID().uuidString, goods: goods, count: 5),
                OrderedGoods(id: UUID().uuidString, goods: goods2, count: 100)
            ])
        ]

        
        let orderDetail = OrderDetail(id: id, userID: "ecojoa@a.com", paymentInfo: result, orderedGoodsInfos: orderedInfos, orderDate: .now)
        _ = try await DataManager.shared.updateData(type: .orderDetail, parameter: .orderDetailUpdate(id: id, orderDetail: orderDetail))
    }
//    
//    func testOrderDetailDelete() async throws {
//        await DataManager.shared.deleteData(type: .orderDetail, parameter: .orderDetailDelete(id: "1EBB322E-635C-4E0F-9D11-00CDAD764117")) { _ in
//            
//        }
//
//    }
//    
////    func testPaymentInfoFetch() async throws {
////        let result = await DataManager.shared.fetchData(type: .paymentInfo, parameter: .paymentInfoLoad(id: "Ki12J9HmdyzwcO2TsMlS")) { _ in
////            
////        }
////        
////        guard case DataResult.paymentInfo(let paymentInfo) = result else {
////            throw DataError.fetchError(reason: "Can't get paymentInfo")
////        }
////        
////        let card = CardInfo(id: "0woTQSLvsGuqbKNZvtkc", cvc: "365", ownerName: "Lucy", cardNumber: "5034398373489929", cardPassword: "5100", expirationDate: Date().getFormattedDate(dateString: "27/10", "yy/MM"))
////        let expect = PaymentInfo(id: "Ki12J9HmdyzwcO2TsMlS", userID: "idntno0505@gmail.com", recipientName: "홍재민", phoneNumber: "010-1234-5060", paymentMethod: .card, paymentMethodInfo: card, address: "home")
////        
////        XCTAssertEqual(paymentInfo, expect)
////    }
//
//
//
//    func testGetAllSellers() async {
//        let result = await DataManager.shared.getAllSellers()
//        print(result)
//    }
//    
//
//    func testReviewUpdate() async throws {
//        let userResult = await DataManager.shared.fetchData(type: .user, parameter: .userLoad(id: "idntno0505@gmail.com", shouldReturnUser: true)) { _ in
//            
//        }
//        guard case .user(let user) = userResult else {
//            throw DataError.fetchError(reason: "cant get user")
//        }
//        
//        let id = UUID().uuidString
//        let review = Review(id: id, user: user, goodsID: "0360EFB2-29CD-4830-A571-7B44EEB09392", title: "test", content: "teste라고 써봅니다", contentImages: [], starCount: 1, creationDate: .now)
//        await DataManager.shared.updateData(type: .review, parameter: .reviewUpdate(id: id, review: review)) { _ in
//            
//        }
//    }
//    
////    func testCardInfoFetch() async throws {
////        let result = await DataManager.shared.fetchData(type: .cardInfo, parameter: .cardInfoLoad(id: "0woTQSLvsGuqbKNZvtkc")) { _ in
////            
////        }
////        
////        guard case DataResult.cardInfo(let cardInfo) = result else {
////            throw DataError.fetchError(reason: "Can't get cardInfo")
////        }
////        
////        let expect = CardInfo(id: "0woTQSLvsGuqbKNZvtkc", cvc: "365", ownerName: "Lucy", cardNumber: "5034398373489929", cardPassword: "5100", expirationDate: Date().getFormattedDate(dateString: "27/10", "yy/MM"))
////        
////        XCTAssertEqual(cardInfo, expect)
////    }
//
//    func testPaymentInfoAdd() async throws {
//        let id = UUID().uuidString
//        let paymentInfo = PaymentInfo(id: id, userID: "idntno0505@gmail.com", deliveryRequest: "오지마", paymentMethod: .bank, addressInfos: [AddressInfo(id: "25DE3FCA-80CE-40D0-840E-F7B6188F6BD6", recipientName: "홍재민", phoneNumber: "010-4534-2323", address: "구월3동")])
//        
//        await DataManager.shared.updateData(type: .paymentInfo, parameter: .paymentInfoUpdate(id: id, paymentInfo: paymentInfo)) { _ in
//            
//        }
//    }
//    
//    func testPaymentInfoUpdate() async throws {
//        let id = "Ki12J9HmdyzwcO2TsMlS"
//        let paymentInfo = PaymentInfo(id: id, userID: "idntno0505@gmail.com", deliveryRequest: "??", paymentMethod: .bank, paymentMethodInfo: CardInfo(id: UUID().uuidString, cvc: "326", ownerName: "홍재민", cardNumber: "2315 2321 9898 2030", cardPassword: "1235", expirationDate: Date().getFormattedDate(dateString: "30-12", "yy-MM")), addressInfos: [AddressInfo(id: UUID().uuidString, recipientName: "홍재민", phoneNumber: "010-4534-2323", address: "구월3동"), AddressInfo(id: "RTG5zronTdUlpuBT1MxE", recipientName: "홍재민", phoneNumber: "010-2321-9899", address: "my")])
//        
//        await DataManager.shared.updateData(type: .paymentInfo, parameter: .paymentInfoUpdate(id: id, paymentInfo: paymentInfo)) { _ in
//            
//        }
//    }
//    
//    func testOneToOneInquiryWithSellerFetch() async throws {
//        _ = await DataManager.shared.fetchData(type: .oneToOneInquiry, parameter: .oneToOneInquiryAllWithSeller(sellerID: "seller@seller.com", limit: 20)) { _ in
//            
//        }
//        
//        let result = await OneToOneInquiryStore.shared.oneToOneInquiryList[0]
//        let expect = await OneToOneInquiryStore.shared.oneToOneInquiryList[0]
//
//        print(result)
//
//        
//    }
//    
//    func testOneToOneInquiryUpdate() async throws {
//        let id = UUID().uuidString
//        let user = await DataManager.shared.fetchData(type: .user, parameter: .userLoad(id: "idntno0505@gmail.com", shouldReturnUser: true)) { _ in
//            
//        }
//        let seller = await DataManager.shared.fetchData(type: .user, parameter: .userLoad(id: "seller@seller.com", shouldReturnUser: true)) { _ in
//            
//        }
//        
//        guard case .user(let user) = user else {
//            throw DataError.convertError(reason: "Can't get user")
//        }
//        
//        guard case .user(let seller) = seller else {
//            throw DataError.convertError(reason: "Can't get user")
//        }
//        
//        let inquiry = OneToOneInquiry(id: id, creationDate: .now, user: user, seller: seller, title: "테스트요", question: "질문이요", answer: "정답이요")
//        await DataManager.shared.updateData(type: .oneToOneInquiry, parameter: .oneToOneInquiryUpdate(id: UUID().uuidString, inquiry: inquiry)) { _ in
//            
//        }
//    }
//    
//    func testOneToOneInquiryDelete() async {
//        await DataManager.shared.deleteData(type: .oneToOneInquiry, parameter: .oneToOneInquiryDelete(id: "D974FBD5-F5E5-42AA-88A3-093162D8D8F9")) { _ in
//            
//        }
//    }
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
//        Task {
//            let cardInfo = CardInfo(id: "0woTQSLvsGuqbKNZvtkc", cvc: "365", ownerName: "Lucy", cardNumber: "5034398373489929", cardPassword: "5100", expirationDate: Date().getFormattedDate(dateString: "27/10", "yy/MM"))
//            await DataManager.shared.updateData(type: .cardInfo, parameter: .cardInfoUpdate(id: "0woTQSLvsGuqbKNZvtkc", cardInfo: cardInfo)) { _ in
//                
//            }
//        }
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
