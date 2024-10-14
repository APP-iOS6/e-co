//
//  ContentView.swift
//  ECO_FB_Test
//
//  Created by Hwang_Inyoung on 10/14/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            EcoView()
                .tabItem { Image(systemName: "house") }
            
            StoreView()
                .tabItem { Image(systemName: "cart") }
            
            MyPageView()
                .tabItem { Image(systemName: "person") }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(UserStore.shared)
        .environmentObject(GoodsStore.shared)
}
