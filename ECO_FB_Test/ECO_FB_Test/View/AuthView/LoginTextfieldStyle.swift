//
//  LoginTextfieldStyle.swift
//  ECO_FB_Test
//
//  Created by wonhoKim on 10/14/24.
//

import SwiftUI

struct TextFieldStyle: ViewModifier {
    var paddingTop: CGFloat
    var paddingLeading: CGFloat
    var isFocused: Bool

    func body(content: Content) -> some View {
        content
            .padding(.top, paddingTop)
            .padding(.leading, paddingLeading)
            .font(.caption2)
            .foregroundColor(.gray)
            .opacity(isFocused ? 1 : 0)
            .offset(x: isFocused ? 0 : 10, y: isFocused ? 0 : 20)
              .animation(.easeInOut(duration: 0.3), value: isFocused)
    }
}

extension View {
    func textFieldStyle(paddingTop: CGFloat, paddingLeading: CGFloat, isFocused: Bool) -> some View {
        self.modifier(TextFieldStyle(paddingTop: paddingTop, paddingLeading: paddingLeading, isFocused: isFocused))
    }
}
