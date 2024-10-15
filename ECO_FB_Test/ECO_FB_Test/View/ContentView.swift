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
                .tabItem { Image(systemName: "leaf.fill") }
                .tag(0)
            
            StoreView(index:$index)
                .tabItem { Image(systemName: "bag.fill") }
                .tag(1)

            MyPageView()
                .tabItem { Image(systemName: "person.fill") }
                .tag(2)
        })
        .accentColor(.green) // 아이콘과 텍스트의 선택된 색상을 초록색으로 설정
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
