//
//  EcoView.swift
//  ECO_FB_Test
//
//  Created by 최승호 on 10/14/24.
//

import SwiftUI
import HealthKit

struct EcoView: View {
    @Binding var selectedTab: Int
    @Environment(UserStore.self) private var userStore: UserStore
    var dataManager = DataManager.shared
    @Bindable private var healthManager = HealthKitManager.shared
    @Environment(\.scenePhase) var scene
    
    var body: some View {
        VStack {
            AppNameView()
            
            // 상단 Info Area
            EcoTopInfoView(healthManager: healthManager)
                .padding(.top, 20)
            
            // 중앙 걸음수 Area
            EcoStepsView(stepCount: healthManager.todayStepCount, selectedTab: $selectedTab)
                

            // 하단 친환경 행사 Area
            EcoEventsView()

        }
        .padding(.top)
        .onChange(of: healthManager.todayStepCount) {
            healthManager.readCurrentStepCount()
            healthManager.readCurrentDistance()
            Task {
                if var user = userStore.userData {  // 유저데이터가 존재하고 (로그인)
                    if healthManager.isChangedTodayStepCount { // 오늘의 걸음수가 변경되었다면
                        user.pointCount += healthManager.getStepPoint() // 방금 증가한 걸음수에 대한 포인트를 더함
                        await dataManager.updateData(type: .user, parameter: .userUpdate(id: user.id, user: user)) { _ in
                            
                        }
                    }
                }
            }
        }
        .onChange(of: scene, {
            healthManager.readCurrentStepCount()
            healthManager.readCurrentDistance()
            Task {
                if var user = userStore.userData {  // 유저데이터가 존재하고 (로그인)
                    if healthManager.isChangedTodayStepCount { // 오늘의 걸음수가 변경되었다면
                        user.pointCount += healthManager.getStepPoint() // 방금 증가한 걸음수에 대한 포인트를 더함
                        await dataManager.updateData(type: .user, parameter: .userUpdate(id: user.id, user: user)) { _ in
                            
                        }
                    }
                }
            }
        })
        .onAppear {
            healthManager.requestAuthorization()
            healthManager.readCurrentStepCount()
            healthManager.readCurrentDistance()
        }
    }
}

#Preview {
    NavigationStack {
        EcoView(selectedTab: .constant(0))
            .environment(UserStore.shared)
    }
}
