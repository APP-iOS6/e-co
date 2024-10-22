//
//  ECO_FB_TestTests.swift
//  ECO_FB_Test
//
//  Created by Jaemin Hong on 10/11/24.
// 

import XCTest
@testable import ECO_FB_Test

final class ECO_FB_TestTests: XCTestCase {
    
    func testOrderDetailFetch() async throws {
        _ = await DataManager.shared.fetchData(type: .orderDetail, parameter: .orderDetailAll(userID: "idntno0505@gmail.com", limit: 500)) { _ in
            
        }
        
        print(await OrderDetailStore.shared.orderDetailList)
    }
    
//    func testPaymentInfoFetch() async throws {
//        let result = await DataManager.shared.fetchData(type: .paymentInfo, parameter: .paymentInfoLoad(id: "Ki12J9HmdyzwcO2TsMlS")) { _ in
//            
//        }
//        
//        guard case DataResult.paymentInfo(let paymentInfo) = result else {
//            throw DataError.fetchError(reason: "Can't get paymentInfo")
//        }
//        
//        let card = CardInfo(id: "0woTQSLvsGuqbKNZvtkc", cvc: "365", ownerName: "Lucy", cardNumber: "5034398373489929", cardPassword: "5100", expirationDate: Date().getFormattedDate(dateString: "27/10", "yy/MM"))
//        let expect = PaymentInfo(id: "Ki12J9HmdyzwcO2TsMlS", userID: "idntno0505@gmail.com", recipientName: "홍재민", phoneNumber: "010-1234-5060", paymentMethod: .card, paymentMethodInfo: card, address: "home")
//        
//        XCTAssertEqual(paymentInfo, expect)
//    }
    
//    func testCardInfoFetch() async throws {
//        let result = await DataManager.shared.fetchData(type: .cardInfo, parameter: .cardInfoLoad(id: "0woTQSLvsGuqbKNZvtkc")) { _ in
//            
//        }
//        
//        guard case DataResult.cardInfo(let cardInfo) = result else {
//            throw DataError.fetchError(reason: "Can't get cardInfo")
//        }
//        
//        let expect = CardInfo(id: "0woTQSLvsGuqbKNZvtkc", cvc: "365", ownerName: "Lucy", cardNumber: "5034398373489929", cardPassword: "5100", expirationDate: Date().getFormattedDate(dateString: "27/10", "yy/MM"))
//        
//        XCTAssertEqual(cardInfo, expect)
//    }

    func testOneToOneInquiryFetch() async throws {
        _ = await DataManager.shared.fetchData(type: .oneToOneInquiry, parameter: .oneToOneInquiryAll(sellerID: "seller@seller.com", limit: 20)) { _ in
            
        }
        
        let result = await OneToOneInquiryStore.shared.oneToOneInquiryList[0]
        let expect = await OneToOneInquiryStore.shared.oneToOneInquiryList[0]
        
        XCTAssertEqual(result, expect)
    }
    
    func testOneToOneInquiryUpdate() async throws {
        let id = UUID().uuidString
        let user = await DataManager.shared.fetchData(type: .user, parameter: .userLoad(id: "idntno0505@gmail.com", shouldReturnUser: true)) { _ in
            
        }
        let seller = await DataManager.shared.fetchData(type: .user, parameter: .userLoad(id: "seller@seller.com", shouldReturnUser: true)) { _ in
            
        }
        
        guard case .user(let user) = user else {
            throw DataError.convertError(reason: "Can't get user")
        }
        
        guard case .user(let seller) = seller else {
            throw DataError.convertError(reason: "Can't get user")
        }
        
        let inquiry = OneToOneInquiry(id: id, creationDate: .now, user: user, seller: seller, title: "테스트요", question: "질문이요", answer: "정답이요")
        await DataManager.shared.updateData(type: .oneToOneInquiry, parameter: .oneToOneInquiryUpdate(id: UUID().uuidString, inquiry: inquiry)) { _ in
            
        }
    }
    
    func testOneToOneInquiryDelete() async {
        await DataManager.shared.deleteData(type: .oneToOneInquiry, parameter: .oneToOneInquiryDelete(id: "D974FBD5-F5E5-42AA-88A3-093162D8D8F9")) { _ in
            
        }
    }
    
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
