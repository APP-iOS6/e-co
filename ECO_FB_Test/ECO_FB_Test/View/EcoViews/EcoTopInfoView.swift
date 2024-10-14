//
//  EcoTopInfoView.swift
//  ECO_FB_Test
//
//  Created by 최승호 on 10/14/24.
//

import SwiftUI

struct EcoTopInfoView: View {
    // TODO: 전달받은 걸음수 데이터를 가공하여 정보 계산하기
    var body: some View {
        HStack {
            VStack {
                Text("CO2 저감")
                Text("341")
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
                Text("2.5")
                    .font(.title)
            }
            .padding()
        }
    }
}

#Preview {
    EcoTopInfoView()
}
