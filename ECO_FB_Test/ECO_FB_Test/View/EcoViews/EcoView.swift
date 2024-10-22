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
    @State var showInfoSheet: Bool = false
    
    var body: some View {
        GeometryReader{ geometry in
            ScrollView(.vertical){
                VStack {
                    HStack{
                        AppNameView()
                        Spacer()
                        Button {
                            showInfoSheet.toggle()
                        } label: {
                            Image(systemName: "questionmark.circle.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 28)
                        }
                        .padding(.trailing)
                    }
                    
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
        .sheet(isPresented: $showInfoSheet){
            EcoPointInfoView()
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

// 포인트 안내사항 뷰 코드
struct EcoPointInfoView: View {
    var body: some View {
        VStack(alignment: .leading){
            Text("포인트 획득 안내사항")
                .font(.title)
                .bold()
                .padding([.top, .horizontal])
            
            Text("1. 포인트 획득 방법")
                .font(.title3)
                .fontWeight(.semibold)
                .padding([.top, .horizontal])
            Text("- 1,000 걸음수에 10point씩 지급됩니다.")
                .padding([.bottom, .horizontal])
            Text("- 10,000 걸음목표를 달성할 시 50point 추가 지급됩니다.")
                .padding([.bottom, .horizontal])
            Text("- 하루 최대 150point 까지 적립이 가능합니다.")
                .padding([.bottom, .horizontal])
                
            Text("2. 포인트 사용 방법")
                .font(.title3)
                .fontWeight(.semibold)
                .padding([.top, .horizontal])
            Text("- 적립한 포인트는 상점 서비스 이용시 사용 가능합니다.")
                .padding([.bottom, .horizontal])
            
            Text("3. CO2 저감량 계산원리")
                .font(.title3)
                .fontWeight(.semibold)
                .padding([.top, .horizontal])
            Text("- 1km당 210g, 100m당 21g, 1m당 210mg이 감소됩니다.")
                .padding([.bottom, .horizontal])
        }
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 10)
                .stroke(lineWidth: 2)
                .padding()
        }
    }
}
