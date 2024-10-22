//
//  SellerCapsuleTitleView.swift
//  ECO_FB_Test
//
//  Created by Hwang_Inyoung on 10/21/24.
//


import SwiftUI

struct SellerCapsuleTitleView: View {
    var title: String
    var body: some View {
        Text("\(title)")
            .foregroundStyle(.white)
            .font(.title3)
            .fontWeight(.bold)
            .padding()
            .background {
                Capsule()
                    .foregroundStyle(.accent)
                    .shadow(radius: 5)
            }
    }
}