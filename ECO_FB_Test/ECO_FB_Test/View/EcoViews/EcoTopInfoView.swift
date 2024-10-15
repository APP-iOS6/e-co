//
//  EcoTopInfoView.swift
//  ECO_FB_Test
//
//  Created by 최승호 on 10/14/24.
//

import SwiftUI

struct EcoTopInfoView: View {
    // TODO: 전달받은 걸음수 데이터를 가공하여 정보 계산하기
    var healthManager: HealthKitManager
    
    // 이산화탄소 저감량계산: 1km당 0.21kg저감, 100m당 0.021kg(21g), 1m당 0.21g(210mg)
    private var co2Reduction: Int {
        let distance = healthManager.distanceWalking
        return Int(distance * 0.21)
    }
    
    private var todayDistance: String {
        let distance = healthManager.distanceWalking
        
        if distance > 999 { // 1000이상일때 km로 변환
            let km = distance / 1000
            return String(format: "%.1f", km)
        }
        
        let meter = String(format: "%.1f", distance)
        return meter
    }
    
    var body: some View {
        HStack {
            Spacer()
            VStack {
                Text("CO2 저감")
                HStack {
                    Text("\(co2Reduction)")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundStyle(.green)
                        .contentTransition(.numericText())
                        .transaction { t in
                            t.animation = .default
                        }
                    Text("g")
                }
                
            }
            .frame(maxWidth: .infinity)
            .padding()
            
            Spacer()
            
            VStack {
                Text("포인트")
                HStack {
                    Text("\(healthManager.getTodayStepPoint())")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundStyle(.green)
                        .contentTransition(.numericText())
                        .transaction { t in
                            t.animation = .default
                        }
                    Text("원")
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            
            Spacer()
            
            VStack {
                Text("이동 거리")
                HStack {
                    Text("\(todayDistance)")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundStyle(.green)
                        .contentTransition(.numericText())
                        .transaction { t in
                            t.animation = .default
                        }
                    if healthManager.distanceWalking > 999 {
                        Text("km")
                    } else {
                        Text("m")
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            Spacer()
        }
    }
}

#Preview {
    EcoTopInfoView(healthManager: HealthKitManager())
}
