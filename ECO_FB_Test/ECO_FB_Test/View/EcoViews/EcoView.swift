//
//  EcoView.swift
//  ECO_FB_Test
//
//  Created by 최승호 on 10/14/24.
//

import SwiftUI

struct EcoView: View {
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Text("이코 E-co")
                        .font(.system(size: 25, weight: .bold))
                    Image(systemName: "leaf.fill")
                    Spacer()
                }
                .padding()
                
                // 상단 Info Area
                EcoTopInfoView()    // TODO: 건강앱에서 추적한 걸음수 데이터 가져와 전달하기
                
                // 중앙 걸음수 Area
                EcoStepsView(progress: 200) // TODO: 건강앱에서 추적한 걸음수 데이터 가져와 전달하기
                
                // 하단 친환경 행사 Area
                EcoEventsView()
            }
        }
    }
}

#Preview {
    EcoView()
}
