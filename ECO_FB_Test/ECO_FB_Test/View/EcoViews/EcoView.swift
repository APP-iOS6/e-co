//
//  EcoView.swift
//  ECO_FB_Test
//
//  Created by 최승호 on 10/14/24.
//

import SwiftUI
import HealthKit

struct EcoView: View {
    @Environment(UserStore.self) private var userStore: UserStore
    private var dataManager = DataManager.shared
    @Bindable private var healthManager = HealthKitManager.shared
    
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
                EcoTopInfoView(healthManager: healthManager)
                
                // 중앙 걸음수 Area
                EcoStepsView(stepCount: healthManager.todayStepCount)
                
                // 하단 친환경 행사 Area
                EcoEventsView()
                
            }
        }
        .onAppear {
            healthManager.requestAuthorization()
            healthManager.readCurrentStepCount()
            healthManager.readCurrentDistance()
            
            Task {
                if var user = userStore.userData {  // 유저데이터가 존재하고 (로그인)
                    if healthManager.isChangedTodayStepCount { // 오늘의 걸음수가 변경되었다면
                        user.pointCount += healthManager.getStepPoint() // 방금 증가한 걸음수에 대한 포인트를 더함
                        await dataManager.updateData(type: .user, parameter: .userUpdate(id: user.id, user: user))
                    }
                }
            }
        }
    }
}

#Preview {
    EcoView().environment(UserStore.shared)
}
