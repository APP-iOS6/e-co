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
                    if healthManager.isChangedTodayStepCount { // 오늘의 걸음수가 변경되었다면
                        user.pointCount += healthManager.getStepPoint() // 방금 증가한 걸음수에 대한 포인트를 더함
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

struct EcoToastView: View {
    @Binding var isVisible: Bool
    let message: String
    @Binding var isShowSheet: Bool
    
    var body: some View {
        if isVisible {
            HStack {
                Image(systemName: "exclamationmark.circle.fill")
                    .foregroundColor(.white)
                    .padding(.leading, 10)

                Text(message)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white)
                    .padding()

                Button {
                    isShowSheet.toggle()
                } label: {
                    Image(systemName: "chevron.right.circle.fill")
                }
                .foregroundStyle(.white)
                
                Spacer()
            }
            .background(Color.green)
            .cornerRadius(10)
            .padding(.horizontal, 20)
            .padding(.top, 10)
            .transition(.slide)
            .animation(.easeInOut, value: isVisible)
            .onAppear {
              
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    withAnimation {
                        isVisible = false
                    }
                }
            }
        }
    }
}

struct HealthHelpView: View {
    var body: some View {
        Text("혹시 모든 정보가 0으로만 보이고, 변화가 없으신가요?")
            .padding(.top, 50)
        Text("설정 > 앱 > 건강 > 데이터 접근 및 기기 >\ne-co에서 '모두 켜기'를 눌러주세요.")
            .padding()
        
        ScrollView(.vertical) {
            Image(.healthHelp)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: .infinity)
                .padding()
        }
    }
}

#Preview {
    NavigationStack {
        EcoView(selectedTab: .constant(0))
            .environment(UserStore.shared)
    }
}
