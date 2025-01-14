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
    @Environment(UserStore.self) private var userStore: UserStore
    
    var body: some View {
        NavigationStack {
            TabView(selection: $selection) {
                Tab(value: 0) {
                    if let isSeller = userStore.userData?.isSeller {
                        if isSeller {
                            SellerHomeView()
                        } else {
                            EcoView(selectedTab: $selection)
                        }
                    } else {
                        EcoView(selectedTab: $selection)
                    }
                } label: {
                    Image(systemName: "leaf.fill")
                    Text("Home")
                }
                
                Tab(value: 1) {
                    StoreView()
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
        .onAppear {
            if authManager.isUserLoggedIn && UserStore.shared.userData == nil {
                Task {
                    await authManager.getLoggedInUserData()
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
