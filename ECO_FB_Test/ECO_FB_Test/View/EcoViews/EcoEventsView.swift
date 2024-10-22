//
//  EcoEventsView.swift
//  ECO_FB_Test
//
//  Created by 최승호 on 10/14/24.
//

import SwiftUI

struct EcoEventsView: View {
    // TODO: 실제 환경 이벤트정보로 변경
    private var sampleData: [String] = ["환경 마라톤", "분리수거 캠페인", "북극곰 보호 캠페인"]
    private var sampleImage: [Image] = [Image(.maraton), Image(.recycle), Image(.bear)]
    private var sampleURL: [String] = ["https://event.kakaobank.com/p/saverace",
                               "http://sunhanmedia.com/board_gald66/174756",
                               "https://givingplus.or.kr/BEAR/"]
    @State private var selectedIndex: Int = 0
    
    @State private var isShowSafari: Bool = false
    @State private var isShowMoreEvent: Bool = false
    
    var body: some View {
        VStack {
            HStack {
                Text("친환경 행사")
                    .font(.headline)
                    .fontWeight(.semibold)
                Spacer()
                
                // TODO: 환경이벤트 페이지로 이동하는 버튼으로 변경
                HStack {
                    Text("더보기")
                    Image(systemName: "chevron.right")
                }
                .onTapGesture {
                    isShowMoreEvent.toggle()
                }
                .sheet(isPresented: $isShowMoreEvent) {
                    MoreEventsView()
                }
                
            }
            .font(.footnote)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    ForEach((0..<3), id: \.self) { index in
                        VStack(alignment: .leading) {
                            sampleImage[index]
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(maxWidth: 120)
                                .onTapGesture {
                                    self.selectedIndex = index
                                    isShowSafari.toggle()
                                }
                                .sheet(isPresented: $isShowSafari) {
                                    SafariView(url: URL(string: sampleURL[selectedIndex])!)
                                }
                            Text(sampleData[index])
                                .font(.footnote)
                        }
                        .frame(maxHeight: 120)
                    }
                }
            }
        }
        .padding(.horizontal)
    }
}

#Preview {
    EcoEventsView()
}
