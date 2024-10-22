//
//  Date+.swift
//  ECO_FB_Test
//
//  Created by Jaemin Hong on 10/14/24.
// 

import Foundation

extension Date {
    /**
     인자로 전달된 포맷으로 Date 타입을 String 타입으로 변환하는 메소드
     
     - parameter format: 변환 시 적용할 포맷
     */
    func getFormattedString(_ format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = TimeZone(identifier: "KST")
        dateFormatter.locale = Locale(identifier: "ko_KR")
        
        return dateFormatter.string(from: self)
    }
    
    /**
     인자로 전달된 포맷으로 String 타입을 Date 타입으로 변환하는 메소드
     
     - parameter dateString: 변환할 문자열 형태의 날짜
     - parameter format: 변환 시 적용할 포맷
     */
    func getFormattedDate(dateString: String, _ format: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = TimeZone(identifier: "KST")
        dateFormatter.locale = Locale(identifier: "ko_KR")
        
        return dateFormatter.date(from: dateString)!
    }
}
