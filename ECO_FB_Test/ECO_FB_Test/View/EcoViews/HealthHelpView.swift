//
//  HealthHelpView.swift
//  ECO_FB_Test
//
//  Created by 이소영 on 10/17/24.
//


import SwiftUI
import HealthKit

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