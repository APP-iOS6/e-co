//
//  SellerHomeView.swift
//  ECO_FB_Test
//
//  Created by 최승호 on 10/20/24.
//

import SwiftUI

struct SellerHomeView: View {
    var body: some View {
        ZStack{
            // 상단 앱 타이틀
            VStack{
                AppNameView()
                Spacer()
            }
            
            VStack{
                // 하단 네비게이션 버튼 뷰
                SellerBottomView()
            }
        }
    }
}

#Preview("판매자 홈") {
    NavigationStack{
        SellerHomeView()
    }
}
