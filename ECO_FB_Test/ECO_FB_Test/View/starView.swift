//
//  starView.swift
//  ECO_FB_Test
//
//  Created by 이소영 on 10/19/24.
//


import SwiftUI

struct starView: View {
    var starRank: Int
    
    var body: some View {
        HStack {
            ForEach(1..<6) { index in
                Image(systemName: "star.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 15, height: 15)
                    .foregroundStyle(index > starRank ? .gray : .yellow)
            }
        }
    }
}