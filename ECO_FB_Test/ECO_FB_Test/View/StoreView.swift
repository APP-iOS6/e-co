//
//  StoreView.swift
//  ECO_FB_Test
//
//  Created by 이소영 on 10/14/24.
//

import SwiftUI
import Combine

struct StoreView: View {
    @EnvironmentObject private var goodsStore: GoodsStore
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
    
    var body: some View {
        
        NavigationStack {
            if DataManager.shared.dataFetchFlow == .loading {
                ProgressView()
            } else {
                ScrollView {
                    VStack(alignment: .leading) {
                        HStack {
                            VStack {
                                HStack {
                                    Text("이코 E-co")
                                        .font(.system(size: 25, weight: .bold))
                                    Image(systemName: "leaf.fill")
                                    Spacer()
                                }
                                .padding(.horizontal)
                                
                                HStack {
                                    TextField("", text: $searchText)
                                        .textFieldStyle(.roundedBorder)
                                        .onChange(of: searchText) { oldValue, newValue in
                                            goodsStore.searchAction(newValue)
                                        }
                                    
                                    Button {
                                        searchText = ""
                                    } label: {
                                        Image(systemName: "xmark.circle.fill")
                                    }
                                }
                                .padding(.horizontal)
                                
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
                                
                                recommendedItemsView(goodsByCategories: goodsByCategories)
                            }
                        }
                        .padding(.vertical)
                        
                        ForEach(Array(filteredGoodsByCategories.keys), id: \.self) { category in
                            ItemListView(category: category, allGoods: filteredGoodsByCategories[category] ?? [])
                        }
                    }
                }
            }
        }
    }
}

// 카테고리 별 대표 상품 보여주면 좋을거 같아요!
// 필수 뷰는 아닙니다!
struct recommendedItemsView: View {
    var goodsByCategories: [GoodsCategory : [Goods]]
    var body: some View {
        HStack {
            Text("이런 상품은 어때요?")
                .font(.system(size: 20, weight: .bold))
            Spacer()
        }
        .padding(.horizontal)
        
        ScrollView(.horizontal) {
            LazyHStack {
                ForEach(Array(goodsByCategories.keys), id: \.self) { category in
                    //  TODO: 상품 상세 페이지 만들고 네비게이션 링크로 바꾸기
                    //                    Image(goodsByCategories[category]?.last?.thumbnailImageName ?? "")
                    Image(systemName: "photo.artframe")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(minHeight: 100)
                }
            }
            .padding(.horizontal)
        }
        .scrollIndicators(.hidden)
    }
}

struct ItemListView: View {
    var category: GoodsCategory
    var allGoods: [Goods]
    var gridItems: [GridItem] = [
        GridItem(),
        GridItem()
    ]
    
    var body: some View {
        VStack(alignment: .leading) {
            NavigationLink(destination: allGoodsOfCategoryView(category: category, allGoods: allGoods)) {
                Image(systemName: "chevron.forward")
                Text(category.rawValue)
                Spacer()
            }
            .bold()
            .padding(EdgeInsets(top: 10, leading: 10, bottom: 0, trailing: 10))
        }
        
        LazyVGrid(columns: gridItems) {
            ForEach(0..<4) { index in
                if allGoods.count > index {
                    
                    NavigationLink {
                        GoodsDetailView(goods: allGoods[index])
                    } label: {
                        VStack(alignment: .leading) {
                            Image(systemName: "photo.artframe")
                            //                        Image(goods.thumbnailImageName)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(minHeight: 80)
                            
                            HStack {
                                Text(allGoods[index].name)
                                    .font(.system(size: 14, weight: .semibold))
                                Spacer()
                                Text("\(allGoods[index].price)")
                                    .font(.system(size: 12))
                            }
                            .padding(.bottom)
                        }
                        .padding(5)
                    }
                    
                }
            }
        }
        .padding(.horizontal, 10)
    }
}

struct allGoodsOfCategoryView: View {
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
                        GoodsDetailView(goods: goods)
                    } label: {
                        VStack(alignment: .leading) {
                            Image(systemName: "photo.artframe")
                            //                        Image(goods.thumbnailImageName)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(minHeight: 70)
                            
                            HStack {
                                Text(goods.name)
                                    .font(.system(size: 14, weight: .semibold))
                                Spacer()
                                Text("\(goods.price)")
                                    .font(.system(size: 12))
                            }
                            .padding(.bottom)
                        }
                    }
                }
            }
        }
        .scrollIndicators(.hidden)
        .padding()
        .navigationTitle(category.rawValue)
        //        .navigationBarBackButtonHidden()
    }
}

#Preview {
    StoreView().environmentObject(GoodsStore.shared)
}
