//
//  OneToOneInquiry.swift
//  ECO_FB_Test
//
//  Created by Jaemin Hong on 10/20/24.
// 

import Foundation

struct OneToOneInquiry: Identifiable, Equatable {
    let id: String
    let creationDate: Date
    let user: User
    let seller: User
    var title: String
    var question: String
    var answer: String
}
