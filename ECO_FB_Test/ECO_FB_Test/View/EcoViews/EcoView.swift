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
//    @State var stepAuthorization: Bool = false
//    @State var isShowSheet: Bool = false
    
    var body: some View {
        ZStack {
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
                EcoStepsView(stepCount: healthManager.todayStepCount, selectedTab: $selectedTab)
                
                if AuthManager.shared.tryToLoginNow {
                    
                }
                
                // 하단 친환경 행사 Area
                EcoEventsView()
            }
            
//            VStack {
//                Spacer()
//                EcoToastView(isVisible: $stepAuthorization, message: "건강앱 읽기 권한이 감지되지 않습니다!", isShowSheet: $isShowSheet)
//            }
        }
//        .sheet(isPresented: $isShowSheet, content: {
//            HealthHelpView()
//        })
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
//            self.stepAuthorization = !healthManager.stepAuthorization
//            print("\(self.stepAuthorization)")
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
