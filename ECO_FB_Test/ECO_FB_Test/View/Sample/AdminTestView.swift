//
//  AdminTestView.swift
//  ECO_FB_Test
//
//  Created by Jaemin Hong on 10/11/24.
// 

import SwiftUI

struct AdminTestView: View {
    @EnvironmentObject private var adminStore: AdminStore
    
    var body: some View {
        VStack(spacing: 10) {
            Button("Fetch Admin") {
                Task {
                    await DataManager.shared.fetchData(type: .admin, parameter: .adminLoad(id: "CJDF8UNrcWP36scvUHq7"))
                }
            }
            .buttonStyle(.bordered)
            
            if let admin = adminStore.adminData {
                VStack {
                    Text("id: \(admin.id)")
                    Text("name: \(admin.name)")
                    Text("profile image name: \(admin.profileImageName)")
                }
                .font(.title)
            }
        }
    }
}

#Preview {
    AdminTestView()
        .environmentObject(AdminStore.shared)
}
