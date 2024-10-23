//
//  SellerBottomView.swift
//  ECO_FB_Test
//
//  Created by Hwang_Inyoung on 10/21/24.
//


import SwiftUI

struct SellerBottomView: View {
    @State var isUploaded: Bool = false
    
    var body: some View {
        ZStack{
            VStack{
                NavigationLink(destination: ProductSubmitView(isUploaded: $isUploaded)) {
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
                
                NavigationLink(destination: SellerInquiryView()) {
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
            VStack{
                Spacer()
                SignUpToastView(isVisible: $isUploaded, message: "상품 등록이 완료되었습니다.")
                    .padding()
            }
        }
    }
}

#Preview {
    SellerHomeView()
}
