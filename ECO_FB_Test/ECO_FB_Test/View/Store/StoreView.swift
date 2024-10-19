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
                            
                            RecommendedItemsView(index: $selectedTab, goodsByCategories: goodsByCategories)
                            
                            ForEach(Array(filteredGoodsByCategories.keys), id: \.self) { category in
                                
                                ItemListView(index: $selectedTab, category: category, allGoods: filteredGoodsByCategories[category] ?? [])
                                
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
        _ = await DataManager.shared.fetchData(type: .goods, parameter: .goodsAll(category: GoodsCategory.allCases, limit: 4)) { flow in
            dataFetchFlow = flow
        }
    }
    
    private func setDummy() {
        let dummyImages: [UIImage] = [
            UIImage(resource: .GoodsDummyImages.avocado),
            UIImage(resource: .GoodsDummyImages.bostonBag),
            UIImage(resource: .GoodsDummyImages.organicBrownRiceCake),
            UIImage(resource: .GoodsDummyImages.sconeLaptopPouch),
            UIImage(resource: .GoodsDummyImages.workingBag)
        ]
        for (i, category) in GoodsCategory.allCases.enumerated() {
            if category == .none { continue }
            
            for j in 0 ..< 20 {
                Task {
                    let id = UUID().uuidString
                    let price = Int.random(in: 10 ... 99999)
                    let uploadResult = try await StorageManager.shared.upload(type: .goods, parameter: .uploadGoodsThumbnail(goodsID: id, image: dummyImages[i - 1]))
                    
                    if case let .single(url) = uploadResult, let user = UserStore.shared.userData {
                        let goods = Goods(id: UUID().uuidString, name: "\(category): \(j)", category: category, thumbnailImageURL: url, bodyContent: "Hi", bodyImageNames: [], price: price, seller: user)
                        
                        await DataManager.shared.updateData(type: .goods, parameter: .goodsUpdate(id: id, goods: goods)) { _ in
                            
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    StoreView(selectedTab: .constant(1)).environment(GoodsStore.shared)
}

