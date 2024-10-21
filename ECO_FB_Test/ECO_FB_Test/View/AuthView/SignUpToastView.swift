//
//  SignUpToastView.swift
//  ECO_FB_Test
//
//  Created by wonhoKim on 10/16/24.
//

import SwiftUI
import UIKit

struct SignUpToastView: View {
    @Binding var isVisible: Bool
    let message: String
    
    var body: some View {
        if isVisible {
            VStack {
                Spacer()
                HStack(alignment: .center) {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.white)
                        .frame(width: 15, height: 15)
                        .padding(.leading)
                    
                    Text(message)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white)
                        .padding()
                    
                    Spacer()
                }
                .frame(height: 60)
                .background(.gray)
                .clipShape(RoundedRectangle(cornerRadius: 10))
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
}

#Preview {
    SignUpToastView(isVisible: .constant(true), message: "회원가입에 성공하셨습니다.")
}
