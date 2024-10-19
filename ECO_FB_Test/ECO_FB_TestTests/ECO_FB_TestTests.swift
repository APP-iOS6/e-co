//
//  ECO_FB_TestTests.swift
//  ECO_FB_Test
//
//  Created by Jaemin Hong on 10/11/24.
// 

import XCTest
@testable import ECO_FB_Test

final class ECO_FB_TestTests: XCTestCase {
    
//    func testPaymentInfoFetch() async throws {
//        let result = await DataManager.shared.fetchData(type: .paymentInfo, parameter: .paymentInfoLoad(id: "Ki12J9HmdyzwcO2TsMlS")) { _ in
//            
//        }
//        
//        guard case DataResult.paymentInfo(let paymentInfo) = result else {
//            throw DataError.fetchError(reason: "Can't get paymentInfo")
//        }
//        
//        let expect = PaymentInfo(id: "Ki12J9HmdyzwcO2TsMlS", userID: "idntno0505@gmail.com", recipientName: "홍재민", phoneNumber: "010-1234-5060", paymentMethod: .card, paymentMethodID: "0woTQSLvsGuqbKNZvtkc", address: "home")
//        
//        XCTAssertEqual(paymentInfo, expect)
//    }
    
    func testCardInfoFetch() async throws {
        let result = await DataManager.shared.fetchData(type: .cardInfo, parameter: .cardInfoLoad(id: "0woTQSLvsGuqbKNZvtkc")) { _ in
            
        }
        
        guard case DataResult.cardInfo(let cardInfo) = result else {
            throw DataError.fetchError(reason: "Can't get cardInfo")
        }
        
        let expect = CardInfo(id: "0woTQSLvsGuqbKNZvtkc", cvc: "365", ownerName: "Lucy", cardNumber: "5034398373489929", cardPassword: "5100", expirationDate: Date().getFormattedDate(dateString: "27/10", "yy/MM"))
        
        XCTAssertEqual(cardInfo, expect)
    }

    override func setUpWithError() throws {
        try super.setUpWithError()
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
