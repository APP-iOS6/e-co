//
//  ContentView.swift
//  ECO_FB_Test
//
//  Created by Hwang_Inyoung on 10/14/24.
//

import SwiftUI

struct ContentView: View {
    @State private var selection = 0

    var body: some View {
        TabView(selection: $selection) {
            Tab(value: 0) {
                EcoView()
            } label: {
                Image(systemName: "leaf.fill")
            }
            
            Tab(value: 1) {
                StoreView(selectedTab: $selection)
            } label: {
                Image(systemName: "bag.fill")
            }
            
            Tab(value: 2) {
                MyPageView()
            } label: {
                Image(systemName: "person.fill")
            }
        }
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
