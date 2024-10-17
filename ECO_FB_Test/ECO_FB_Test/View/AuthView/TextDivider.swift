//
//  TextDivider.swift
//  ECO_FB_Test
//
//  Created by 이소영 on 10/17/24.
//


import SwiftUI

struct TextDivider: View {
    let text: String
    var body: some View {
        HStack {
            Divider()
                .frame(maxWidth: 80, maxHeight: 1)
                .background(Color.gray)
            
            Text(text)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.gray)
                .padding(.horizontal, 8)
            
            Divider()
                .frame(maxWidth: 80, maxHeight: 1)
                .background(Color.gray)
            
        }
        .padding(.vertical, 8)
    }
}