//
//  AppNameView.swift
//  ECO_FB_Test
//
//  Created by 이소영 on 10/17/24.
//

import SwiftUI

struct AppNameView: View {
    var body: some View {
        HStack {
            Image(systemName: "leaf.fill")
                .foregroundStyle(.accent)
                .font(.system(size: 25))
            
            Text("이코")
                .font(.system(size: 25))
                .font(.title3)
                .fontWeight(.bold)
            
            Spacer()
        }
        .padding(.horizontal)
        .padding(.top)
    }
}


#Preview {
    AppNameView()
}
