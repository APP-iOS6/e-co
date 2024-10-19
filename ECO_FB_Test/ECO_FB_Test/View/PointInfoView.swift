//
//  PointInfoView.swift
//  ECO_FB_Test
//
//  Created by 이소영 on 10/18/24.
//


import SwiftUI
import UIKit

struct PointInfoView: View {
    @Binding var usingPoint: Int
    @State var notice: String = ""
    var point: Int
    var vSpacing: CGFloat = 11
    
    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: vSpacing) {
                Text("보유 포인트")
                Text("사용 포인트")
                    .padding(.top, 6)
            }
            .foregroundStyle(Color(uiColor: .darkGray))
            .fontWeight(.bold)
            .padding(.vertical)
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: vSpacing) {
                Text("\(point)")
                TextField("", value: $usingPoint, formatter: NumberFormatter())
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.numberPad)
                    .multilineTextAlignment(.trailing)
                if notice.count > 0 {
                    Text(notice)
                        .font(.system(size: 12))
                        .foregroundStyle(.red)
                }
            }
            .onChange(of: usingPoint) { oldValue, newValue in
                if newValue > point {
                    notice = "사용 포인트는 보유 포인트보다 클 수 없습니다"
                    usingPoint = oldValue
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                    notice = ""
                })
            }
            .padding(.vertical)
        }
    }
}

#Preview {
    PointInfoView(usingPoint: .constant(0), point: .init(100))
}
