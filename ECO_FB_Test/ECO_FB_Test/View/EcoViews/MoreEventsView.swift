//
//  MoreEventsView.swift
//  ECO_FB_Test
//
//  Created by 최승호 on 10/15/24.
//

import SwiftUI

struct MoreEventsView: View {
    private var sampleData: [String] = ["환경 마라톤", "분리수거 캠페인", "북극곰 보호 캠페인"]
    private var sampleImage: [Image] = [Image(.maraton), Image(.recycle), Image(.bear)]
    private var sampleURL: [String] = ["https://event.kakaobank.com/p/saverace",
                                       "http://sunhanmedia.com/board_gald66/174756",
                                       "https://givingplus.or.kr/BEAR/"]
    @State private var selectedIndex: Int = 0
    
    @State private var isShowSafari: Bool = false
    var body: some View {
        NavigationStack {
            List {
                ForEach(0..<3) { index in
                    HStack {
                        sampleImage[index]
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: 120)
                        VStack(alignment: .leading) {
                            Text(sampleData[index])
                                .font(.headline)
                                .fontWeight(.semibold)
                            Text("부가 설명")
                                .font(.caption)
                                .foregroundStyle(.gray)
                        }
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.caption)
                    }
                    .onTapGesture {
                        self.selectedIndex = index
                        isShowSafari.toggle()
                    }
                }
            }
            .listStyle(.plain)
            .sheet(isPresented: $isShowSafari) {
                SafariView(url: URL(string: sampleURL[selectedIndex])!)
            }
            .navigationTitle("친환경 행사")
        }
    }
}

#Preview {
    MoreEventsView()
}
