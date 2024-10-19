//
//  DeliveryInfo.swift
//  ECO_FB_Test
//
//  Created by 이소영 on 10/18/24.
//


import SwiftUI

struct DeliveryInfo: View {
    var name: String
    var address: String
    var isComplete: Bool
    var vSpacing: CGFloat = 11
    @Binding var requestMessage: String
    var requestMessages: [String] = ["문앞에 놔주세요", "경비실에 맡겨주세요", "미리 연락주세요"] // TODO: 직접 입력 추가하기
    var body: some View {
        HStack(alignment: .top, spacing: 15) {
            VStack(alignment: .leading, spacing: vSpacing) {
                Text("받는 사람")
                Text("받는 주소")
                Spacer()
                Text("배송요청사항")
                    .padding(.bottom, 6.5)
            }
            .foregroundStyle(Color(uiColor: .darkGray))
            .fontWeight(.bold)
            .padding(.vertical)
            
            VStack(alignment: .leading, spacing: vSpacing) {
                Text(name)
                    .padding(.leading, 11)
                Text(address)
                    .padding(.leading, 11)
                
                if isComplete {
                    Text(requestMessage)
                        .padding(.leading, 11)
                } else {
                    
                    Picker("배송요청사항", selection: $requestMessage) {
                        ForEach(requestMessages, id: \.self) {
                            Text($0)
                        }
                    }
                    .tint(.black)
                    .background(Color(uiColor: .systemGray6) ,in: RoundedRectangle(cornerRadius: 10))
                }
            }
            .padding(.vertical)
        }
    }
}
