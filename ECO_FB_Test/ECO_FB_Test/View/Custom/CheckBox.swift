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
                Image(systemName: "checkmark.square.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundStyle(.accent)
            } else {
                Image(systemName: "square")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
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
