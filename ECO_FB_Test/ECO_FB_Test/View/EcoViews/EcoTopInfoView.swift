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
    private var co2Reduction: String {
        let distance = healthManager.distanceWalking
        let co2Reduction = 0.21 * distance
        if co2Reduction > 999 {
            let kgCo2 = co2Reduction / 1000
            return String(format: "%.0f", kgCo2)
        }
        return String(format: "%.0f" ,co2Reduction)
    }
    
    private var todayDistance: String {
        let distance = healthManager.distanceWalking
        
        if distance > 999 { // 1000이상일때 km로 변환
            let km = distance / 1000
            if km == floor(km) {
                return String(format: "%.0f", km)
            } else {
                return String(format: "%.1f", km)
            }
        }
        
        if distance == floor(distance) {
            return String(format: "%.0f", distance)
        } else {
            return String(format: "%.1f", distance)
        }
    }
    
    var body: some View {
        HStack {
            Spacer()
            VStack {
                Text("CO2 저감")
                HStack {
                    Text("\(co2Reduction)")
                        .font(.system(size: 24))
                        .fontWeight(.bold)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                        .foregroundStyle(.green)
                        .contentTransition(.numericText())
                        .transaction { t in
                            t.animation = .default
                        }
                    if healthManager.distanceWalking > 999 {
                        Text("kg")
                    } else {
                        Text("g")
                    }
                }
                
            }
            .frame(maxWidth: .infinity)
            
            Spacer()
            
            VStack {
                Text("포인트")
                
                HStack {
                    Text("\(healthManager.getTodayStepPoint())")
                        .font(.system(size: 24))
                        .fontWeight(.bold)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                        .foregroundStyle(.green)
                        .contentTransition(.numericText())
                        .transaction { t in
                            t.animation = .default
                        }
                    Text("점")
                }
            }
            .frame(maxWidth: .infinity)
            
            Spacer()
            
            VStack {
                Text("이동 거리")
                HStack {
                    Text("\(todayDistance)")
                        .font(.system(size: 24))
                        .fontWeight(.bold)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
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
            Spacer()
        }
    }
}

#Preview {
    EcoTopInfoView(healthManager: HealthKitManager())
}
