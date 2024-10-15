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
//                HStack {
//                    Text("이코 E-co")
//                        .font(.system(size: 25, weight: .bold))
//                    Image(systemName: "leaf.fill")
//                    Spacer()
//                }
//                .foregroundStyle(.green)
//                .padding()
                
                // 상단 Info Area
                EcoTopInfoView(healthManager: healthManager)
                
                // 중앙 걸음수 Area
                EcoStepsView(stepCount: healthManager.todayStepCount)
                
                if userStore.userData != nil {
                    HStack {
                        Text("보유 포인트: ")
                        Text("\(userStore.userData!.pointCount)")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundStyle(.green)
                        Text("원")
                    }
                } else {
                    Text("비회원의 경우 포인트가 적립되지 않습니다.")
                        .font(.footnote)
                }
                
                // 하단 친환경 행사 Area
                EcoEventsView()
                
            }
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
        }
        .onChange(of: healthManager.todayStepCount) {
            healthManager.readCurrentStepCount()
            healthManager.readCurrentDistance()
            Task {
                if var user = userStore.userData {  // 유저데이터가 존재하고 (로그인)
//                    print("ecoView: 로그인되어있음")
                    if healthManager.isChangedTodayStepCount { // 오늘의 걸음수가 변경되었다면
//                        print("ecoView: 걸음수 변경감지되었음")
//                        print("ecoView: 변경전 유저 포인트 - \(user.pointCount)")
                        user.pointCount += healthManager.getStepPoint() // 방금 증가한 걸음수에 대한 포인트를 더함
//                        print("ecoView: 변경후 유저 포인트 - \(user.pointCount)")
                        await dataManager.updateData(type: .user, parameter: .userUpdate(id: user.id, user: user))
                    }
                }
            }
        }
        .onAppear {
            healthManager.requestAuthorization()
            healthManager.readCurrentStepCount()
            healthManager.readCurrentDistance()
        }
    }
}

#Preview {
    EcoView().environment(UserStore.shared)
}
