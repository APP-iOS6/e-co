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
    @Environment(GoodsStore.self) private var goodsStore: GoodsStore
    @State var searchText: String = ""
    @State var dataFetchFlow: DataFlow = .none
    
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
    @State var isShowToast = false
    @State private var dataUpdateFlow: DataFlow = .none
    
    @Environment(UserStore.self) private var userStore: UserStore
    
    var body: some View {
        ZStack {
            ScrollView {
                AppNameView()
                
                LazyVStack(alignment: .leading, pinnedViews: [.sectionHeaders]) {
                    Section(header:
                                VStack {
                        HStack {
                            Spacer()
                            
                            NavigationLink(destination: StoreLocationView()) {
                                Text("오프라인 매장찾기")
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
                        VStack {
                            ScrollView(.horizontal) {
                                HStack {
                                    Button {
                                        goodsStore.categorySelectAction(GoodsCategory.none)
                                    } label: {
                                        Text("ALL")
                                            .fontWeight(selectedCategory == GoodsCategory.none ? .semibold : .regular)
                                            .foregroundStyle(selectedCategory == GoodsCategory.none ? Color.black : Color(uiColor: .darkGray))
                                    }
                                    .buttonStyle(.bordered)
                                    
                                    ForEach(Array(goodsByCategories.keys), id: \.self) { category in
                                        Button {
                                            goodsStore.categorySelectAction(category)
                                        } label: {
                                            Text(category.rawValue)
                                                .fontWeight(selectedCategory == category ? .semibold : .regular)
                                                .foregroundStyle(selectedCategory == category ? Color.black : Color(uiColor: .darkGray))
                                        }
                                        .buttonStyle(.bordered)
                                    }
                                }
                            }
                            .scrollIndicators(.hidden)
                            .padding([.horizontal, .bottom])
                            
                            RecommendedItemsView(goodsByCategories: goodsByCategories)
                            
                            ForEach(Array(filteredGoodsByCategories.keys), id: \.self) { category in
                                
                                ItemListView(category: category, allGoods: filteredGoodsByCategories[category] ?? [], dataUpdateFlow: $dataUpdateFlow, isNeedLogin: $isShowToast)
                            }
                        }
                        .onTapGesture {
                            focused = false
                        }
                    }
                }
            }
            .padding(.top)
            .scrollIndicators(.hidden)
            
            Spacer()
            SignUpToastView(isVisible: $isShowToast, message: "로그인이 필요합니다")
                .padding()
            
            if dataFetchFlow == .loading {
                ProgressView()
            }
        }
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
        .disabled(dataFetchFlow == .loading)
    }
    
    private func getGoods() async {
        do {
            _ = try await DataManager.shared.fetchData(type: .goods, parameter: .goodsAll(category: GoodsCategory.allCases, limit: 4), flow: $dataFetchFlow)
        } catch {
            print("Error in StoreView, getGoods(): \(error)")
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
                        
                        _ = try await DataManager.shared.updateData(type: .goods, parameter: .goodsUpdate(id: id, goods: goods), flow: $dataUpdateFlow)
                    }
                }
            }
        }
    }
}

#Preview {
    StoreView().environment(GoodsStore.shared)
}

