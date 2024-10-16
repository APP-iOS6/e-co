//
//  CheckBox.swift
//  ECO_FB_Test
//
//  Created by Jaemin Hong on 10/14/24.
// 

import SwiftUI

struct CheckBox: View {
    @Binding var isOn: Bool
    var action: () -> Void = { }
    
    var body: some View {
        Button {
            isOn.toggle()
            action()
        } label: {
            if isOn {
                Image(systemName: "checkmark.rectangle.fill")
                    .resizable()
                    .foregroundStyle(.accent)
            } else {
                Image(systemName: "rectangle")
                    .resizable()
            }
        }
        .frame(width: 25, height: 25)
        .foregroundStyle(.black)
    }
}

#Preview {
    CheckBox(isOn: .constant(true)) {
        print("A")
    }
}
