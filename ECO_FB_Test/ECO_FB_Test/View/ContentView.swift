//
//  ContentView.swift
//  ECO_FB_Test
//
//  Created by Hwang_Inyoung on 10/14/24.
//

import SwiftUI

struct ContentView: View {
    @State private var selection = 0
    @Environment(AuthManager.self) var authManager: AuthManager
    
    var body: some View {
        NavigationStack {
            VStack {
                TabView(selection: $selection) {
                    Tab(value: 0) {
                        EcoView(selectedTab: $selection)
                    } label: {
                        Image(systemName: "leaf.fill")
                        Text("Home")
                    }
                    
                    Tab(value: 1) {
                        StoreView(selectedTab: $selection)
                    } label: {
                        Image(systemName: "bag.fill")
                        Text("Store")
                    }
                    
                    Tab(value: 2) {
                        MyPageView()
                    } label: {
                        Image(systemName: "person.fill")
                        Text("My")
                    }
                }
            }
        }
        .onAppear {
            if AuthManager.shared.isUserLoggedIn {
                Task {
                    await AuthManager.shared.getLoggedInUserData()
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        ContentView()
            .environment(UserStore.shared)
            .environment(GoodsStore.shared)
            .environment(DataManager.shared)
            .environment(AuthManager.shared)
            .environment(AnnouncementStore.shared)
    }
}
