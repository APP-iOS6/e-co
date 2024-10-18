//
//  StoreView.swift
//  ECO_FB_Test
//
//  Created by 이소영 on 10/14/24.
//

import SwiftUI
import Combine

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
                    
                }
                    .padding(.bottom, 10)
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
                            .padding([.horizontal, .bottom])
                            
                            RecommendedItemsView(index: $selectedTab, goodsByCategories: goodsByCategories, imageURL: imageURLs[.passion] ?? URL(string: "https://kean-docs.github.io/nukeui/images/nukeui-preview.png")!)
                            
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
        .padding(.top)
        .scrollIndicators(.hidden)
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

#Preview {
    StoreView(selectedTab: .constant(1)).environment(GoodsStore.shared)
}

