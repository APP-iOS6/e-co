//
//  PasswordStyle.swift
//  ECO_FB_Test
//
//  Created by 이소영 on 10/17/24.
//


import SwiftUI

struct PasswordStyle: ViewModifier {
    var paddingTop: CGFloat
    var isFocused: Bool

    func body(content: Content) -> some View {
        content
            .padding(.top, paddingTop)
            .font(.caption2)
            .foregroundColor(.gray)
            .opacity(isFocused ? 1 : 0)
    }
}

extension View {
    func passwordStyle(paddingTop: CGFloat, isFocused: Bool) -> some View {
        self.modifier(PasswordStyle(paddingTop: paddingTop, isFocused: isFocused))
    }
}
