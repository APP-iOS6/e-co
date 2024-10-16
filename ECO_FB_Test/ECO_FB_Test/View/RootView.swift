//
//  RootView.swift
//  ECO_FB_Test
//
//  Created by wonhoKim on 10/15/24.
//

import SwiftUI

struct RootView: View {
    private let authManager: AuthManager = AuthManager.shared
    
    var body: some View {
        NavigationStack {
//            if authManager.isUserLoggedIn {
                ContentView()
                    .onAppear {
//                        Task {
//                            await authManager.getLoggedInUserData()
//                        }
                    }
                    
//            } else {
//                LoginView()
//            }
        }
    }
}

#Preview {
    RootView()
        .environment(AuthManager.shared)
}
