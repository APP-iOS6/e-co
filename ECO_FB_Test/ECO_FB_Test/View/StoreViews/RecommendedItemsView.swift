//
//  RecommendedItemsView.swift
//  ECO_FB_Test
//
//  Created by 이소영 on 10/17/24.
//

import SwiftUI
import Combine
import Nuke
import NukeUI
import UIKit

struct RecommendedItemsView: View {
    var goodsByCategories: [GoodsCategory : [Goods]]

    var width = 0
    
    @State private var anyCancellable: AnyCancellable? = nil
    @State private var currentScrollIndex: Int = 0
    @State private var isReverse: Bool = false
    @State private var scrollObjectIDs: [GoodsCategory] = []
    
    var body: some View {
        ScrollViewReader { proxy in
            HStack {
                Text("이런 상품은 어때요?")
                    .font(.system(size: 18, weight: .semibold))
                Spacer()
            }
            .padding(.horizontal)
            .onAppear {
                autoScroll(proxy)
                scrollObjectIDs = Array(goodsByCategories.keys)
            }
            .onDisappear {
                anyCancellable?.cancel()
                anyCancellable = nil
            }
            
            ScrollView(.horizontal) {
                LazyHStack(spacing: 8) {
                    ForEach(Array(goodsByCategories.keys), id: \.self) { category in
                        if let goods = goodsByCategories[category]?.randomElement() {
                            NavigationLink {
                                GoodsDetailView(goods: goods, thumbnail: goods.thumbnailImageURL)
                            } label: {
                                LazyImage(url: goods.thumbnailImageURL) { state in
                                    if let image = state.image {
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: UIScreen.main.bounds.width - 32, height: 400)
                                            .scrollTransition { content, phase in
                                                content
                                                    .opacity(phase.isIdentity ?  1 : 0.5 )
                                                    .scaleEffect(y: phase.isIdentity ?  1 : 0.7 )
                                            }
                                    } else {
                                        ProgressView()
                                            .frame(width: UIScreen.main.bounds.width - 32, height: 400)
                                    }
                                }
                            }
                            .id(category)
                        }
                    }
                }
                .scrollTargetLayout()
            }
            .contentMargins(16, for: .scrollContent)
            .scrollTargetBehavior(.viewAligned)
            .scrollTargetBehavior(.paging)
            .scrollIndicators(.hidden)
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width*2/3)
            .gesture(
                DragGesture()
                    .onEnded { value in
                        if value.translation.width < 0 {
                            currentScrollIndex = min(currentScrollIndex + 1, scrollObjectIDs.endIndex - 1)
                        } else if value.translation.width > 0 {
                            currentScrollIndex = max(currentScrollIndex - 1, 0)
                        }
                        
                        anyCancellable?.cancel()
                        anyCancellable = nil
                        
                        autoScroll(proxy)
                    }
            )
        }
    }
    
    private func autoScroll(_ proxy: ScrollViewProxy) {
        let timerSubject = Timer.publish(every: 3.5, on: .main, in: .default).autoconnect()
        anyCancellable = timerSubject
            .sink { _ in
                if currentScrollIndex == scrollObjectIDs.endIndex - 1 {
                    isReverse = true
                } else if currentScrollIndex == 0 {
                    isReverse = false
                }
                
                if isReverse {
                    currentScrollIndex = max(currentScrollIndex - 1, 0)
                } else {
                    currentScrollIndex = min(currentScrollIndex + 1, scrollObjectIDs.endIndex - 1)
                }
                
                withAnimation {
                    proxy.scrollTo(scrollObjectIDs[currentScrollIndex], anchor: .center)
                }
            }
    }
}
