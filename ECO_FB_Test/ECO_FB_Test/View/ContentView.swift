//
//  ContentView.swift
//  ECO_FB_Test
//
//  Created by Hwang_Inyoung on 10/14/24.
//

import SwiftUI

struct ContentView: View {
    @State private var index = 0
    
    var body: some View {
        TabView(selection: $index, content: {
            EcoView()
                .tabItem { Image(systemName: "house") }
                .tag(0)
            
            StoreView(index:$index)
                .tabItem { Image(systemName: "cart") }
                .tag(1)

            MyPageView()
                .tabItem { Image(systemName: "person") }
                .tag(2)
        })
    }
}

#Preview {
    ContentView()
        .environment(UserStore.shared)
        .environment(GoodsStore.shared)
        .environment(DataManager.shared)
        .environment(AuthManager.shared)
        .environment(AnnouncementStore.shared)
}
