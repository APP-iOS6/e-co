//
//  RootView.swift
//  ECO_FB_Test
//
//  Created by wonhoKim on 10/15/24.
//

import SwiftUI

struct RootView: View {
    //앱스토리지로 로그인 상태 관리
    //그런데 종료후 다시 실행하니 로그인 상태가 남아있어요, 그런데 마이페이지 뷰에 정보가 나와야 하는데 흠.. 이따가 어케해야할지 물어볼게요 앱종료했을때 로그아웃 시킬지?
    @AppStorage("isLoggedIn") private var isLoggedIn: Bool = false

    var body: some View {
        if isLoggedIn {
            ContentView()
        } else {
            LoginView()
        }
    }
}

#Preview {
    RootView()
        .environment(AuthManager.shared)
}
