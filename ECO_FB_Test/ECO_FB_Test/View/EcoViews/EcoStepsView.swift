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
    // TODO: 전달받은 걸음수 데이터 띄우기, 목표 걸음수의 비율에 맞게 그래프 조정하기
    var stepCount: Int
    private var progress: CGFloat {
        return Double(stepCount) / 10000
    }
    @State private var animatedProgress: CGFloat = 0
    
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
                        Text("목표: 10000")
                            .offset(y: 100)
                            .font(.title3)
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
    EcoStepsView(stepCount: 5000)
}
