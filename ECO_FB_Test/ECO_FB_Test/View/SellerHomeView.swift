//
//  SellerHomeView.swift
//  ECO_FB_Test
//
//  Created by 최승호 on 10/20/24.
//


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
                
                SellerBottomView()
            }
        }
    }
}

#Preview {
    NavigationStack{
        SellerHomeView()
    }
}

// 판매자 홈뷰의 하단영역 뷰
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

// 상품 등록 뷰
struct ProductSubmitView: View {
    var body: some View {
        Text("상품 등록 뷰")
    }
}

// 주문 관리 뷰
struct OrderManageView: View {
    var body: some View {
        Text("주문 관리 뷰")
    }
}

// 문의 관리 뷰
struct HelpManageView: View {
    var body: some View {
        Text("문의 관리 뷰")
    }
}
