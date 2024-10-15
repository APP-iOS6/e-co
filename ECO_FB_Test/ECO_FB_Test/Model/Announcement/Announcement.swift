//
//  Announcement.swift
//  ECO_FB_Test
//
//  Created by Jaemin Hong on 10/14/24.
// 

import Foundation

struct Announcement: Identifiable {
    let id: String
    let admin: User
    let title: String
    let content: String
    let creationDate: Date
    
    var formattedCreationDate: String {
        return creationDate.getFormattedString("yyyy년 MM월 dd일 HH시 mm분")
    }
}
