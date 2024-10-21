//
//  SellerBottomView.swift
//  ECO_FB_Test
//
//  Created by Hwang_Inyoung on 10/21/24.
//


import SwiftUI

struct SellerBottomView: View {
    var body: some View {
        VStack {
            NavigationLink(destination: ProductSubmitView()) {
                ZStack{
                    Rectangle()
                        .fill(.accent)
                        .cornerRadius(20)
                    Text("상품 등록")
                        .foregroundStyle(.white)
                        .font(.title)
                        .fontWeight(.bold)
                }
            }
            .frame(maxHeight: 90)
            .padding()
            
            NavigationLink(destination: OrderManageView()) {
                ZStack{
                    Rectangle()
                        .fill(.accent)
                        .cornerRadius(20)
                    Text("주문 관리")
                        .foregroundStyle(.white)
                        .font(.title)
                        .fontWeight(.bold)
                }
            }
            .frame(maxHeight: 90)
            .padding()
            
            NavigationLink(destination: HelpManageView()) {
                ZStack{
                    Rectangle()
                        .fill(.accent)
                        .cornerRadius(20)
                    Text("문의 관리")
                        .foregroundStyle(.white)
                        .font(.title)
                        .fontWeight(.bold)
                }
            }
            .frame(maxHeight: 90)
            .padding()
        }
    }
}

#Preview {
    SellerHomeView()
}
