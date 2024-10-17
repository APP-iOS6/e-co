//
//  EcoToastView.swift
//  ECO_FB_Test
//
//  Created by 이소영 on 10/17/24.
//


import SwiftUI

struct EcoToastView: View {
    @Binding var isVisible: Bool
    let message: String
    @Binding var isShowSheet: Bool
    
    var body: some View {
        if isVisible {
            HStack {
                Image(systemName: "exclamationmark.circle.fill")
                    .foregroundColor(.white)
                    .padding(.leading, 10)

                Text(message)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white)
                    .padding()

                Button {
                    isShowSheet.toggle()
                } label: {
                    Image(systemName: "chevron.right.circle.fill")
                }
                .foregroundStyle(.white)
                
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
