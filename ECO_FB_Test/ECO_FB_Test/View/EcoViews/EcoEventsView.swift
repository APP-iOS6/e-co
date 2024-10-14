//
//  EcoEventsView.swift
//  ECO_FB_Test
//
//  Created by 최승호 on 10/14/24.
//

import SwiftUI

struct EcoEventsView: View {
    // TODO: 실제 환경 이벤트정보로 변경
    var sampleData: [String] = ["환경 마라톤", "분리수거 캠페인", "북극곰 구조"]
    
    var body: some View {
        VStack {
            HStack {
                Text("친환경 행사")
                    .font(.headline)
                    .fontWeight(.regular)
                Spacer()
                
                // TODO: 환경이벤트 페이지로 이동하는 버튼으로 변경
                Text("더보기")
                Image(systemName: "chevron.right")
            }
            .font(.footnote)
            
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    ForEach(sampleData, id: \.self) { data in
                        VStack(alignment: .leading) {
                            Image(systemName: "photo")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(maxWidth: 120)
                            Text("\(data)")
                                .font(.footnote)
                        }
                        .frame(maxHeight: 120)
                    }
                }
            }
            .padding(.top)
        }
        .padding()
    }
}

#Preview {
    EcoEventsView()
}
