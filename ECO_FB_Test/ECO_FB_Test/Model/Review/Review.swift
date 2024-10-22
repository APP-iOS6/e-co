//
//  Review.swift
//  ECO_FB_Test
//
//  Created by Jaemin Hong on 10/21/24.
// 

import Foundation

struct Review: Identifiable {
    let id: String
    var user: User
    var title: String
    var content: String
    var contentImages: [URL]
    var starCount: Int
    let creationDate: Date
    
    var formattedCreationDate: String {
        creationDate.getFormattedString("yyyy년 MM월 dd일 a hh시 mm분")
    }
}
