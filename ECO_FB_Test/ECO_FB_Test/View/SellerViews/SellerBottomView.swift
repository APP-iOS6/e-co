//
//  SellerBottomView.swift
//  ECO_FB_Test
//
//  Created by Hwang_Inyoung on 10/21/24.
//


import SwiftUI

struct SellerBottomView: View {
    var body: some View {
        GeometryReader{ proxy in
            VStack {
                NavigationLink(destination: ProductSubmitView()) {
                    ZStack{
                        Rectangle()
                            .cornerRadius(20)
                            .frame(width: proxy.size.width * (9/10), height: proxy.size.height / 10)
                        Text("상품 등록")
                            .foregroundStyle(.white)
                            .font(.title)
                            .fontWeight(.bold)
                    }
                }
                .padding()
                
                NavigationLink(destination: OrderManageView()) {
                    ZStack{
                        Rectangle()
                            .cornerRadius(20)
                            .frame(width: proxy.size.width * (9/10), height: proxy.size.height / 10)
                        Text("주문 관리")
                            .foregroundStyle(.white)
                            .font(.title)
                            .fontWeight(.bold)
                    }
                }
                .padding()
                
                NavigationLink(destination: HelpManageView()) {
                    ZStack{
                        Rectangle()
                            .cornerRadius(20)
                            .frame(width: proxy.size.width * (9/10), height: proxy.size.height / 10)
                        Text("문의 관리")
                            .foregroundStyle(.white)
                            .font(.title)
                            .fontWeight(.bold)
                    }
                }
                .padding()
            }
            .frame(width: proxy.size.width, height: proxy.size.height * (4/7))
            .offset(x: 0, y: proxy.size.height * (3/7))
        }
    }
}