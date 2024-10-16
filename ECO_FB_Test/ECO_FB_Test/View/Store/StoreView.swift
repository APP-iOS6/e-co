//
//  StoreView.swift
//  ECO_FB_Test
//
//  Created by 이소영 on 10/14/24.
//

import SwiftUI
import Combine
import Nuke
import NukeUI

struct StoreView: View {
    static private var isFirstPresent: Bool = true
    @Binding var selectedTab: Int
    @Environment(GoodsStore.self) private var goodsStore: GoodsStore
    @State private var dataFetchFlow: DataFetchFlow = .loading
    @State var searchText: String = ""
    @State var imageURLs: [GoodsCategory: URL] = [:]
    
    var goodsByCategories: [GoodsCategory : [Goods]] {
        goodsStore.goodsByCategories
    }
    var selectedCategory: GoodsCategory {
        goodsStore.selectedCategory
    }
    var filteredGoodsByCategories: [GoodsCategory : [Goods]] {
        goodsStore.filteredGoodsByCategories
    }
    
    @State var isMapVisible: Bool = false
    @FocusState var focused: Bool
    
    var body: some View {
        ScrollView {
            AppNameView()
            
            LazyVStack(alignment: .leading, pinnedViews: [.sectionHeaders]) {
                Section(header:
                            VStack {
                    HStack {
                        Spacer()
                        
                        Button {
                            isMapVisible.toggle()
                        } label: {
                            Text("오프라인 매장찾기")
                        }
                        .sheet(isPresented: $isMapVisible) {
                            StoreLocationView()
                                .presentationDragIndicator(.visible)
                        }
                        .padding(.horizontal)
                    }
                    
                    HStack {
                        VStack {
                            HStack {
                                TextField("친환경 제품을 찾아보세요", text: $searchText)
                                    .onChange(of: searchText) { oldValue, newValue in
                                        goodsStore.searchAction(newValue)
                                    }
                                    .keyboardType(.default)
                                    .focused($focused)
                                
                                Button {
                                    searchText = ""
                                    focused = false
                                } label: {
                                    Image(systemName: "xmark.circle.fill")
                                }
                                .foregroundStyle(Color(uiColor: .darkGray))
                            }
                            .padding(10)
                            .background {
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(.gray, lineWidth: 1)
                            }
                            .padding(.horizontal)
                        }
                    }
                    .padding(.bottom)
                }
                    .background(Rectangle().foregroundColor(.white))
                ) {
                    if dataFetchFlow == .loading {
                        HStack {
                            Spacer()
                            
                            ProgressView()
                            
                            Spacer()
                        }
                    } else {
                        VStack {
                            ScrollView(.horizontal) {
                                HStack {
                                    Button {
                                        goodsStore.categorySelectAction(GoodsCategory.none)
                                    } label: {
                                        Text("ALL")
                                            .fontWeight(.semibold)
                                            .foregroundStyle(Color(uiColor: .darkGray))
                                    }
                                    .buttonStyle(.bordered)
                                    
                                    ForEach(Array(goodsByCategories.keys), id: \.self) { category in
                                        Button {
                                            goodsStore.categorySelectAction(category)
                                        } label: {
                                            Text(category.rawValue)
                                                .fontWeight(.semibold)
                                                .foregroundStyle(Color(uiColor: .darkGray))
                                        }
                                        .buttonStyle(.bordered)
                                    }
                                }
                            }
                            .scrollIndicators(.hidden)
                            .padding()
                            
                            recommendedItemsView(index: $selectedTab, goodsByCategories: goodsByCategories, imageURL: imageURLs[.passion] ?? URL(string: "https://kean-docs.github.io/nukeui/images/nukeui-preview.png")!)
                            
                            ForEach(Array(filteredGoodsByCategories.keys), id: \.self) { category in
                                
                                ItemListView(index: $selectedTab, imageURL: imageURLs[category] ?? URL(string: "https://png.pngtree.com/png-vector/20190704/ourmid/pngtree-leaf-graphic-icon-design-template-vector-illustration-png-image_1538440.jpg")!, category: category, allGoods: filteredGoodsByCategories[category] ?? [])
                                
                            }
                        }
                        .onTapGesture {
                            focused = false
                        }
                    }
                }
                
                
            }
        }
        .scrollIndicators(.hidden)
        //        .toolbar {
        //            if selectedTab == 1 {
        //                ToolbarItem(placement: .topBarTrailing) {
        //                    Button {
        //                        isMapVisible.toggle()
        //                    } label: {
        //                        Text("오프라인 매장찾기")
        //                    }
        //                    .sheet(isPresented: $isMapVisible) {
        //                        StoreLocationView()
        //                            .presentationDragIndicator(.visible)
        //                    }
        //                }
        //
        //                ToolbarItem(placement: .keyboard) {
        //                    Button {
        //                        focused = false
        //                    } label: {
        //                        Text("return")
        //                    }
        //                }
        //            }
        //        }
        .onAppear {
            if StoreView.isFirstPresent {
                Task {
                    await getGoods()
                    StoreView.isFirstPresent = false
                }
            }
        }
        .refreshable {
            Task {
                await getGoods()
            }
        }
    }
    
    private func getGoods() async {
        let refill = await StorageManager.shared.fetch(type: .goods, parameter: .goodsThumbnail(goodsID: "0A44DC63-AFCB-4E7B-96A3-8C2E0926564D"))
        let food = await StorageManager.shared.fetch(type: .goods, parameter: .goodsThumbnail(goodsID: "07AE6761-E5D0-4546-847D-48098E47393E"))
        let passion = await StorageManager.shared.fetch(type: .goods, parameter: .goodsThumbnail(goodsID: "0C0723FC-2839-47DA-BCA5-F3EC7F2CD471"))
        
        if case .single(let url) = refill {
            imageURLs[.food] = url
        }
        
        if case .single(let url) = food {
            imageURLs[.refill] = url
        }
        
        if case .single(let url) = passion {
            imageURLs[.passion] = url
        }
        
        _ = await DataManager.shared.fetchData(type: .goods, parameter: .goodsAll(category: [.food, .refill, .passion], limit: 4)) { flow in
            dataFetchFlow = flow
        }
    }
}

// 카테고리 별 대표 상품 보여주면 좋을거 같아요!
// 필수 뷰는 아닙니다!
struct recommendedItemsView: View {
    @Binding var index: Int
    var goodsByCategories: [GoodsCategory : [Goods]]
    var imageURL: URL
    
    var body: some View {
        HStack {
            Text("이런 상품은 어때요?")
                .font(.system(size: 18, weight: .semibold))
            Spacer() 
        }
        .padding(.horizontal)
        
        ScrollView(.horizontal) {
            LazyHStack {
                ForEach(Array(goodsByCategories.keys), id: \.self) { category in
                    if let goods = goodsByCategories[category]?.last {
                        NavigationLink {
                            GoodsDetailView(index: $index, goods: goods, thumbnail: imageURL)
                        } label: {
                            Image(goods.thumbnailImageName)
                            Image(.ecoBags)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(minHeight: 100)
                        }
                    }
                }
            }
            .padding(.horizontal)
        }
        .scrollTargetBehavior(.paging)
        .scrollIndicators(.hidden)
    }
}

struct ItemListView: View {
    @Binding var index: Int
    var imageURL: URL
    var category: GoodsCategory
    var allGoods: [Goods]
    var gridItems: [GridItem] = [
        GridItem(),
        GridItem()
    ]
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(category.rawValue)
                    .font(.system(size: 20, weight: .semibold))
                Spacer()
                
                NavigationLink(destination: allGoodsOfCategoryView(index: $index, imageURL: imageURL, category: category, allGoods: allGoods).environment(GoodsStore.shared)) {
                    HStack {
                        Text("더보기")
                        Image(systemName: "chevron.right")
                    }
                    .foregroundStyle(.black)
                }
                .bold()
            }
            .font(.footnote)
            .padding(.top)
            Divider()
        }
        .padding(.horizontal)
        
        LazyVGrid(columns: gridItems) {
            ForEach(0..<4) { index in
                if allGoods.count > index {
                    NavigationLink {
                        GoodsDetailView(index: $index, goods: allGoods[index], thumbnail: imageURL)
                    } label: {
                        VStack(alignment: .leading) {
                            LazyImage(url: imageURL) { state in
                                if let image = state.image {
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(minHeight: 80)
                                } else if state.isLoading {
                                    ProgressView()
                                }
                                
                                if let error = state.error {
                                    Text("Lazy Image Error: \(error)")
                                }
                            }
                            
                            HStack {
                                Text(allGoods[index].name)
                                    .font(.system(size: 14, weight: .semibold))
                                Spacer()
                                Text("\(allGoods[index].price)원")
                                    .font(.system(size: 12))
                            }
                            .padding(.bottom)
                            .foregroundStyle(.black)
                        }
                        .padding(5)
                    }
                }
            }
            .padding(.bottom)
        }
        .padding(.horizontal, 10)
    }
}

struct allGoodsOfCategoryView: View {
    static private var loadedCategories: [GoodsCategory] = []
    @Environment(GoodsStore.self) private var goodsStore: GoodsStore
    @Binding var index: Int
    var imageURL: URL
    var category: GoodsCategory
    var allGoods: [Goods]
    var gridItems: [GridItem] = [
        GridItem(),
        GridItem()
    ]
    private let itemsPerPage: Int = 10
    @State private var tabSelection: Int = 0
    @State private var dataFetchFlow: DataFetchFlow = .none
    
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
                            GoodsPageView(itemRange: getItemCountForPage(index), imageURL: imageURL, category: category, index: self.$index)
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
                let isLoaded = allGoodsOfCategoryView.loadedCategories.contains(where: { $0 == category })
                if !isLoaded && goodsStore.goodsByCategories[category] != nil {
                    dataFetchFlow = .loading
                    _ = await DataManager.shared.fetchData(type: .goods, parameter: .goodsAll(category: [category], limit: goodsStore.dataCount)) { flow in
                        dataFetchFlow = flow
                        
                        allGoodsOfCategoryView.loadedCategories.append(category)
                    }
                }
            }
        }
        .refreshable {
            Task {
                if goodsStore.goodsByCategories[category] != nil {
                    _ = await DataManager.shared.fetchData(type: .goods, parameter: .goodsAll(category: [category], limit: goodsStore.dataCount)) { flow in
                        dataFetchFlow = flow
                    }
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

struct GoodsPageView: View {
    var itemRange: Range<Int>
    var imageURL: URL
    var category: GoodsCategory
    @Binding var index: Int
    @Environment(GoodsStore.self) private var goodsStore: GoodsStore
    
    var body: some View {
        VStack {
            if let filteredGoods = goodsStore.filteredGoodsByCategories[category] {
                List(filteredGoods[itemRange]) { goods in
                    NavigationLink {
                        GoodsDetailView(index: $index, goods: goods, thumbnail: imageURL)
                    } label: {
                        HStack(spacing: 15) {
                            LazyImage(url: imageURL) { state in
                                if let image = state.image {
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(height: 80)
                                } else if state.isLoading {
                                    ProgressView()
                                }
                            }
                            
                            VStack(alignment: .leading) {
                                Text(goods.name)
                                    .font(.system(size: 20, weight: .semibold))
                                Text("\(goods.formattedPrice)")
                                    .font(.system(size: 15))
                            }
                        }
                        .foregroundStyle(.black)
                    }
                }
                .listStyle(.plain)
            }
        }
    }
}

#Preview {
    StoreView(selectedTab: .constant(1)).environment(GoodsStore.shared)
}
 
