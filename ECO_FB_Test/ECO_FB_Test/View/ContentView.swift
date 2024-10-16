//
//  ContentView.swift
//  ECO_FB_Test
//
//  Created by Hwang_Inyoung on 10/14/24.
//

import SwiftUI

struct ContentView: View {
    @State private var selection = 0
    @State private var isNeedLogin: Bool = false
    @Environment(AuthManager.self) var authManager: AuthManager
    
    var body: some View {
        NavigationStack {
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
        .onAppear {
            isNeedLogin = !authManager.isUserLoggedIn
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                HStack {
                    Text("이코")
                        .font(.title3)
                        .fontWeight(.bold)
                    Image(systemName: "leaf.fill")
                }
            }
        }
        .fullScreenCover(isPresented: $isNeedLogin) {
            LoginView()
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
