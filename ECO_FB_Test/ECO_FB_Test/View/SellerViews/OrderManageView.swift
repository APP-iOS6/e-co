//
//  OrderManageView.swift
//  ECO_FB_Test
//
//  Created by Hwang_Inyoung on 10/21/24.
//


import SwiftUI

struct OrderManageView: View {
    @State private var isOn: Bool = false
    
    var body: some View {
        AppNameView()
        VStack(alignment: .leading){
            SellerCapsuleTitleView(title: "주문 관리")
                .padding(.bottom)
            Text("현재 들어온 주문들입니다.")
                .bold()
                .padding(.bottom)
            
            ScrollView(.vertical){
                ForEach(0..<10){ index in
                    HStack{
                        Text("\(index)")
                            .bold()
                            .foregroundStyle(.white)
                            .padding()
                            .background {
                                Circle()
                                    .fill(Color.accentColor)
                            }
                            .padding(.trailing)
                        Text("가방")
                        Spacer()
                        CheckBox(isOn: $isOn)
                            .padding(.trailing)
                    }
                    .frame(maxWidth: .infinity)
                    Divider()
                }
            }
            .padding(.horizontal)
            .scrollIndicators(.hidden)
            
            Button {
                print("배송 알림 전송했습니다.")
                // TODO: 선택상품을 구매한 유저에게 알림 전송 로직
            } label: {
                Text("배송 알림 전송")
                    .foregroundStyle(.white)
                    .font(.title)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background {
                        Capsule(style: .continuous)
                            .fill(.accent)
                            .frame(maxWidth: .infinity)
                    }
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
    }
}
