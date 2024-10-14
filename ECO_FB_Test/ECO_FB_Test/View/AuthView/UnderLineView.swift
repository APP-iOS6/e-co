//
//  UnderLineView.swift
//  ECO_FB_Test
//
//  Created by wonhoKim on 10/14/24.
//



import SwiftUI

struct UnderlineTextFieldView<TextFieldView>: View where TextFieldView: View {
    
    @Binding var text: String
    let textFieldView: TextFieldView
    //let guideText: String
    let placeholder: String
    var imageName: String? = nil
    let isFocused: Bool
    
    private var isTextFieldWithIcon: Bool {
        return imageName != nil
    }
    
    var body: some View {
        HStack {
            if isTextFieldWithIcon {
                iconImageView
            }
            underlineTextFieldView
        }
    }
}



extension UnderlineTextFieldView {
    private var iconImageView: some View {
        Image(imageName ?? "")
            .frame(width: 32, height: 32)
            .padding(.leading, 16)
            .padding(.trailing, 16)
    }
    
    private var underlineTextFieldView: some View {
        VStack {
            ZStack(alignment: .leading) {
                if text.isEmpty && !isFocused {
                    placeholderView
                }
//Text(guideText).padding(.leading,-180.8)
                textFieldView
                    .padding(.trailing, 16)
                    .padding(.leading, isTextFieldWithIcon ? 0 : 16)
            }
            
            underlineView
        }
    }
    
    private var placeholderView: some View {
        Text(placeholder)
            .foregroundColor(.black)
            .padding(.leading, isTextFieldWithIcon ? 0 : 16)
            .opacity(0.5)
            .font(.caption2)
    }
    
    private var underlineView: some View {
        Rectangle().frame(height: 1)
            .foregroundColor(.black)
            .padding(.trailing, 16)
            .padding(.leading, isTextFieldWithIcon ? 0 : 16)
    }
}


