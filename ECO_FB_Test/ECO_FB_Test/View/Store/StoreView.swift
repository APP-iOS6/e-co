//
//  StoreView.swift
//  ECO_FB_Test
//
//  Created by 이소영 on 10/14/24.
//

import SwiftUI
import Combine

struct StoreView: View {
    @Binding var index: Int
    @Environment(GoodsStore.self) private var goodsStore: GoodsStore
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
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading) {
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
                                } label: {
                                    Image(systemName: "xmark.circle.fill")
                                }
                                .foregroundStyle(.black)
                            }
                            .padding(10)
                            .background {
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(.gray, lineWidth: 1)
                            }
                            .padding(.horizontal)
                            
                            
                        }
                        .padding(.vertical)
                    }
                    
                    if DataManager.shared.dataFetchFlow == .loading {
                        HStack {
                            Spacer()
                            ProgressView()
                            Spacer()
                        }
                    } else {
                        ScrollView(.horizontal) {
                            HStack {
                                ForEach(Array(goodsByCategories.keys), id: \.self) { category in
                                    
                                    Button {
                                        goodsStore.categorySelectAction(category)
                                    } label: {
                                        Text(category.rawValue)
                                    }
                                    .buttonStyle(.bordered)
                                    .foregroundStyle(selectedCategory == category ? .gray : .black)
                                }
                            }
                        }
                        .padding()
                        
                        recommendedItemsView(index: $index, goodsByCategories: goodsByCategories)
                    }
                    ForEach(Array(filteredGoodsByCategories.keys), id: \.self) { category in
                        ItemListView(index: $index, imageURL: imageURLs[category]!, category: category, allGoods: filteredGoodsByCategories[category] ?? [])
                    }
                }
                .navigationTitle("스토어")
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            isMapVisible.toggle()
                        } label: {
                            Text("오프라인 매장찾기")
                        }
                        .sheet(isPresented: $isMapVisible) {
                            StoreLocationView()
                                .presentationDragIndicator(.visible)
                        }
                    }
                    
                    ToolbarItemGroup(placement: .keyboard) {
                        Button {
                            focused = false
                        } label: {
                            Text("return")
                        }
                    }
                }
            }
        }
        .onAppear {
            Task {
                let refil = await StorageManager.shared.fetch(type: .goods, parameter: .goodsThumbnail(goodsID: "0A44DC63-AFCB-4E7B-96A3-8C2E0926564D"))
                let food = await StorageManager.shared.fetch(type: .goods, parameter: .goodsThumbnail(goodsID: "07AE6761-E5D0-4546-847D-48098E47393E"))
                let passion = await StorageManager.shared.fetch(type: .goods, parameter: .goodsThumbnail(goodsID: "0C0723FC-2839-47DA-BCA5-F3EC7F2CD471"))
                
                if case .single(let url) = refil {
                    imageURLs[.food] = url
                }
                
                if case .single(let url) = food {
                    imageURLs[.refill] = url
                }
                
                if case .single(let url) = passion {
                    imageURLs[GoodsCategory.passion] = url
                }
            }
        }
    }
}

// 카테고리 별 대표 상품 보여주면 좋을거 같아요!
// 필수 뷰는 아닙니다!
struct recommendedItemsView: View {
    @Binding var index: Int
    var goodsByCategories: [GoodsCategory : [Goods]]
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
                            GoodsDetailView(index: $index, goods: goods)
                        } label: {
                            Image(.ecoBags)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(maxWidth: 200)
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
                
                NavigationLink(destination: allGoodsOfCategoryView(index: $index, category: category, allGoods: allGoods)) {
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
                        GoodsDetailView(index: $index, goods: allGoods[index])
                    } label: {
                        VStack(alignment: .leading) {
                            
                            AsyncImage(url: imageURL) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(minHeight: 80)
                            } placeholder: {
                                ProgressView()
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
    @Binding var index: Int
    var category: GoodsCategory
    var allGoods: [Goods]
    var gridItems: [GridItem] = [
        GridItem(),
        GridItem()
    ]
    var body: some View {
        ScrollView {
            LazyVGrid(columns: gridItems) {
                ForEach(allGoods) { goods in
                    NavigationLink {
                        GoodsDetailView(index: $index, goods: goods)
                    } label: {
                        VStack(alignment: .leading) {
                            Image(.ecoBags)
                            //                        Image(goods.thumbnailImageName)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(minHeight: 80)
                            
                            HStack {
                                Text(goods.name)
                                    .font(.system(size: 14, weight: .semibold))
                                Spacer()
                                Text("\(goods.price)")
                                    .font(.system(size: 12))
                            }
                            .padding(.bottom)
                            .foregroundStyle(.black)
                        }
                        .padding()
                    }
                }
            }
        }
        .scrollIndicators(.hidden)
        .navigationTitle(category.rawValue)
        //        .navigationBarBackButtonHidden()
    }
}

#Preview {
    StoreView(index: .constant(1)).environment(GoodsStore.shared)
}
