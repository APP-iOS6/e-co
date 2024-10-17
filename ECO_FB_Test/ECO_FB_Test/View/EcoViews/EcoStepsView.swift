//
//  EcoStepsView.swift
//  ECO_FB_Test
//
//  Created by 최승호 on 10/14/24.
//

import SwiftUI

/*
 최소 각도 : 135`
 최대 각도 : 405`
 사이값 : 0 ~ 270
 */
struct EcoStepsView: View {
    var stepCount: Int
    @Binding var selectedTab: Int
    private var progress: CGFloat {
        return Double(stepCount) / 10000
    }
    @State private var animatedProgress: CGFloat = 0
    @Environment(UserStore.self) private var userStore
    
    var body: some View {
        VStack{
            GeometryReader { geometry in
                ZStack {
                    let center = CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2)

                    // --------- 외부 원호 ---------
                    Path { path in
                        path.addArc(center: center,             // 위치
                                    radius: 130,                // 반지름
                                    startAngle: .degrees(135),  // 좌하단 시작점 : 135`
                                    endAngle: .degrees(405),         // 우하단 끝점 : 45` (405`)
                                    clockwise: false)           // 시계 반대방향
                    }
                    .trim(from: 0, to: animatedProgress)
                    .stroke(Color.green, lineWidth: 8)
                    
                    // --------- 내부 원호 ---------
                    Path { path in
                        path.addArc(center: center,
                                    radius: 120,
                                    startAngle: .init(degrees: 135),
                                    endAngle: .init(degrees: 45),
                                    clockwise: false)
                    }
                    .stroke(lineWidth: 2)

                    VStack {
                        Text("오늘의 걸음")
                        Text("\(stepCount)")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundStyle(.green)
                            .contentTransition(.numericText())
                            .transaction { t in
                                t.animation = .default
                            }
                    }
                    
                    VStack {
                        Text("목표: 10,000")
                            .offset(y: 100)
                            .font(.title3)
                    }
                }
            }
            
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
                        .padding(.bottom)
                    
                    NavigationLink(destination: LoginView()) {
                        HStack {
                            Text("로그인 하기")
                            Image(systemName: "chevron.right")
                        }
                        .fontWeight(.semibold)
                    }
                }
            }
        }
        .onAppear {
            animatedProgress = 0
            withAnimation(.easeOut(duration: 1)) {
                animatedProgress = progress
            }
        }
        .onChange(of: stepCount) {
            animatedProgress = 0
            withAnimation(.easeOut(duration: 1)) {
                animatedProgress = progress
            }
        }
    }
}

#Preview {
    EcoStepsView(stepCount: 5000, selectedTab: .constant(0))
}
