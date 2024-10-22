//
//  AllGoodsOfCategoryView.swift
//  ECO_FB_Test
//
//  Created by 이소영 on 10/17/24.
//

import SwiftUI
import Nuke
import NukeUI

struct AllGoodsOfCategoryView: View {
    static private var loadedCategories: [GoodsCategory] = []
    @Environment(GoodsStore.self) private var goodsStore: GoodsStore
    var category: GoodsCategory
    var allGoods: [Goods]
    var gridItems: [GridItem] = [
        GridItem(),
        GridItem()
    ]
    private let itemsPerPage: Int = 10
    @State private var tabSelection: Int = 0
    
    private var dataFetchFlow: DataFlow {
        DataManager.shared.getDataFlow(of: .goods)
    }
    
    private var numberOfPages: Int {
        ((goodsStore.goodsByCategories[category] ?? []).count + itemsPerPage - 1) / itemsPerPage
    }
    
    var body: some View {
        VStack {
            if dataFetchFlow == .loading {
                ProgressView()
            } else {
                TabView(selection: $tabSelection) {
                    ForEach(0 ..< numberOfPages, id: \.self) { index in
                        Tab(value: index) {
                            GoodsPageView(itemRange: getItemCountForPage(index), category: category)
                                .environment(goodsStore)
                        }
                    }
                }
                .tabViewStyle(TabBarOnlyTabViewStyle())
                
                HStack(spacing: 25) {
                    ForEach(1 ... numberOfPages, id: \.self) { index in
                        Button("\(index)") {
                            tabSelection = index - 1
                        }
                        .font(.title2)
                        .fontWeight(.bold)
                        .frame(width: 15)
                        .padding(.bottom, 20)
                        .minimumScaleFactor(0.1)
                    }
                }
            }
        }
        .scrollIndicators(.hidden)
        .navigationTitle(category.rawValue)
        .onAppear {
            Task {
                let isLoaded = AllGoodsOfCategoryView.loadedCategories.contains(where: { $0 == category })
                if !isLoaded && goodsStore.goodsByCategories[category] != nil {
                    _ = try await DataManager.shared.fetchData(type: .goods, parameter: .goodsAll(category: [category], limit: goodsStore.dataCount))
                    
                    AllGoodsOfCategoryView.loadedCategories.append(category)
                }
            }
        }
        .refreshable {
            Task {
                if goodsStore.goodsByCategories[category] != nil {
                    _ = try await DataManager.shared.fetchData(type: .goods, parameter: .goodsAll(category: [category], limit: goodsStore.dataCount))
                }
            }
        }
    }
    
    private func getItemCountForPage(_ index: Int) -> Range<Int> {
        guard let goodsList = goodsStore.goodsByCategories[category] else {
            print(DataError.fetchError(reason: "Still goods are not fetched"))
            return 0 ..< 1
        }
        
        let startIndex = index * itemsPerPage
        let endIndex = min(startIndex + itemsPerPage, goodsList.count)
        
        let result = (startIndex ..< endIndex)
        return result
    }
}

