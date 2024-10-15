//
//  EcoView.swift
//  ECO_FB_Test
//
//  Created by 최승호 on 10/14/24.
//

import SwiftUI
import HealthKit

struct EcoView: View {
    @EnvironmentObject private var userStore: UserStore
    private var dataManager = DataManager.shared
    private var healthManager = HealthKitManager.shared
    
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
                EcoTopInfoView(healthManager: healthManager)    // TODO: 건강앱에서 추적한 걸음수 데이터 가져와 전달하기
                
                // 중앙 걸음수 Area
                EcoStepsView(stepCount: healthManager.stepCount)
                
                // 하단 친환경 행사 Area
                EcoEventsView()
                
            }
        }
        .onAppear {
            healthManager.requestAuthorization()
            healthManager.readCurrentStepCount()
            healthManager.readCurrentDistance()
            print("디스턴스 테스트: \(healthManager.distanceWalking)")
            
            if var user = userStore.userData {
//                user.pointCount = healthManager.stepCount / 10
//                dataManager.updateData(type: .user, parameter: .userUpdate(id: user.id, user: user))
            }
            // 포인트 업데이트를 이런식으로 해야하는가? but pointCount let이라서 재정의x
            
            // 포인트 업데이트 로직을 어떻게 해야할까..
            // 00시 기준으로 오늘획득 포인트는 초기화되고, 하루동안 앱 접속시 이전 걸음수보다 늘어남이 감지되면
            // 늘어난 걸음수 만큼 오늘 총 획득 포인트를 증가시킨다.
            // 늘어난 걸음수의 포인트량을 user의 pointCount에 증가시킨다.
        }
    }
}

#Preview {
    EcoView()
}
