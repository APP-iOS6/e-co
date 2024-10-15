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
    private var co2Reduction: Int {
        let distance = healthManager.distanceWalking
        return Int(distance * 0.21)
    }
    // 이산화탄소 저감량계산: 1km당 0.21kg저감, 100m당 0.021kg(21g), 1m당 0.21g(210mg)
    var body: some View {
        HStack {
            VStack {
                Text("CO2 저감(g)")
                Text("\(co2Reduction)")
                    .font(.title)
            }
            .padding()
            
            VStack {
                Text("포인트")
                Text("100")
                    .font(.title)
            }
            .padding()
            
            VStack {
                Text("Km")
                Text("\(healthManager.distanceWalking)")
                    .font(.title)
            }
            .padding()
        }
    }
}

#Preview {
    EcoTopInfoView(healthManager: HealthKitManager())
}
