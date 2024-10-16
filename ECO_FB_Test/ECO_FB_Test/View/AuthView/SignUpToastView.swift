//
//  SignUpToastView.swift
//  ECO_FB_Test
//
//  Created by wonhoKim on 10/16/24.
//

import SwiftUI

struct SignUpToastView: View {
    @Binding var isVisible: Bool
    let message: String

    var body: some View {
        if isVisible {
            HStack {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.white)
                    .padding(.leading, 10)

                Text(message)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white)
                    .padding()

                Spacer()
            }
            .background(Color.green)
            .cornerRadius(10)
            .padding(.horizontal, 20)
            .padding(.top, 10)
            .transition(.slide)
            .animation(.easeInOut, value: isVisible)
            .onAppear {
              
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    withAnimation {
                        isVisible = false
                    }
                }
            }
        }
    }
}

#Preview {
    SignUpToastView(isVisible: .constant(true), message: "회원가입에 성공하셨습니다.")
}
