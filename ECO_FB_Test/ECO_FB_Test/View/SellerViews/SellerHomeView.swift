//
//  SellerHomeView.swift
//  ECO_FB_Test
//
//  Created by 최승호 on 10/20/24.
//

import SwiftUI

struct SellerHomeView: View {
    var body: some View {
        VStack{
            GeometryReader{ proxy in
                // 상단 앱 타이틀
                VStack(alignment: .center){
                    HStack {
                        Image(systemName: "leaf.fill")
                            .foregroundStyle(.accent)
                        
                        Text("이코")
                            .fontWeight(.bold)
                    }
                }
                .font(.largeTitle)
                .frame(width: proxy.size.width, height: proxy.size.height * (3/7))
                
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
