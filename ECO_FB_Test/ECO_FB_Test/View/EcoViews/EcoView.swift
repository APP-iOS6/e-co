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
        GeometryReader{ geometry in
            ScrollView(.vertical){
                VStack {
                    AppNameView()
                    
                    // 상단 Info Area
                    EcoTopInfoView(healthManager: healthManager)
                        .padding(.top, 20)
                        .padding(.bottom, 40)
                    
                    // 중앙 걸음수 Area
                    EcoStepsView(stepCount: healthManager.todayStepCount, selectedTab: $selectedTab)
                        .frame(height: geometry.size.height/2)
                    
                    // 하단 친환경 행사 Area
                    EcoEventsView()

                }
            }
        }
        .padding(.top)
        .onChange(of: healthManager.todayStepCount) {
            print("onChange step")
            healthManager.loadData()
            updateUserPoints()
        }
        .onChange(of: scene, {
            print("onChange scene")
            healthManager.loadData()
//            updateUserPoints()
        })
        .onAppear {
            print("onAppear")
            print("오늘 적립한 총 포인트: \(healthManager.earnedPointsToday)")
            healthManager.requestAuthorization()
        }
    }
    
    private func updateUserPoints() {
        Task {
            if var user = userStore.userData {  // 유저데이터가 존재하고 (로그인)
                if healthManager.isChangedTodayStepCount {  // 오늘의 걸음수가 변경되었다면
                    let points = healthManager.totalPoints  // 획득한 총 포인트를 가져오고
                    let earnedPointsToday = healthManager.earnedPointsToday // 오늘 총 적립한 포인트를 가져오고
                    if earnedPointsToday < 150 {    // 오늘 적립한 포인트가 150점 미만일 때
                        user.pointCount += points   // user에 포인트를 증가시킨 후
                        await dataManager.updateData(   // 업데이트
                            type: .user,
                            parameter: .userUpdate(id: user.id, user: user)
                        ) { _ in
                            print("유저 포인트를 \(points)만큼 증가시켰습니다.")
                        }
                        healthManager.earnedPointsToday += points
                        healthManager.totalPoints = 0   // 적립한 포인트를 0으로 초기화
                    } else {
                        print("이미 오늘 150포인트를 적립했습니다.")
                    }
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        EcoView(selectedTab: .constant(0))
            .environment(UserStore.shared)
    }
}
