//
//  UserInformationView.swift
//  ECO_FB_Test
//
//  Created by 이소영 on 10/17/24.
//

import SwiftUI

struct UserInformationView: View {
    @State private var showLogoutAlert: Bool = false // 로그아웃 알림 표시 여부
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        Text("사용자 정보")
        Button {
            showLogoutAlert = true
        } label: {
            Text("로그아웃")
                .foregroundColor(.red)
        }
        .alert("로그아웃", isPresented: $showLogoutAlert, actions: {
            Button("로그아웃", role: .destructive) {
                AuthManager.shared.logout()
                dismiss()
            }
            
            Button("취소", role: .cancel) { }
        }, message: {
            Text("로그아웃 하시겠습니까?")
        })
    }
}
