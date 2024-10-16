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
            HStack {
                Image(systemName: "leaf.fill")
                    .foregroundStyle(.accent)
                    .font(.system(size: 20))
                Text("이코")
                    .font(.system(size: 20))
                    .font(.title3)
                    .fontWeight(.bold)
            }
            .padding(.vertical)
            
            // 상단 Info Area
            EcoTopInfoView(healthManager: healthManager)
            
            // 중앙 걸음수 Area
            EcoStepsView(stepCount: healthManager.todayStepCount)
            
            if userStore.userData != nil {
                HStack() {
                    Text("총 보유 포인트: ")
                    Text("\(userStore.userData!.pointCount)")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundStyle(.green)
                    Text("점")
                }
                .padding(.top)
                
                Button {
                    selectedTab = 1
                } label: {
                    HStack {
                        Text("스토어로 이동하기")
                        Image(systemName: "chevron.right")
                    }
                    .fontWeight(.semibold)
                }
                
            } else {
                if AuthManager.shared.tryToLoginNow {
                    Text("로그인 중 입니다.")
                        .font(.footnote)
                } else {
                    Text("비회원의 경우 포인트가 적립되지 않습니다.")
                        .font(.footnote)
                    
                    NavigationLink(destination: LoginView()) {
                        HStack {
                            Text("로그인 하기")
                            Image(systemName: "chevron.right")
                        }
                        .fontWeight(.semibold)
                    }
                }
            }
            
            // 하단 친환경 행사 Area
            EcoEventsView()
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
        .onChange(of: scene, {
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
