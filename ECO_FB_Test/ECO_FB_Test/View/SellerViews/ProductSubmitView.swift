//
//  ProductSubmitView.swift
//  ECO_FB_Test
//
//  Created by Hwang_Inyoung on 10/21/24.
//


import SwiftUI

struct ProductSubmitView: View {
    private var goodsCategories = GoodsCategory.allCases.filter{ $0.rawValue != "none" }.sorted { a, b in
        a.rawValue > b.rawValue
    }
    @State private var selectedCategory: GoodsCategory? = nil
    @State private var goodsName: String = ""
    @State private var goodsContent: String = ""
    @State private var goodsPrice: String = ""
    //    @State private var goodsImage: Image? = nil   // 판매자는 사진 업로드 하는 방식...?
    private var isEmptyAnyFields: Bool {    //
        selectedCategory == nil || goodsName.isEmpty || goodsContent.isEmpty || goodsPrice.isEmpty
    }
    
    var body: some View {
        AppNameView()
        ScrollView(.vertical){
            VStack(alignment: .leading){
                SellerCapsuleTitleView(title: "상품 등록")
                    .padding(.bottom)
                Text("카테고리 선택")
                    .bold()
                ScrollView(.horizontal) {   // storeView의 스크롤뷰를 재활용 했습니다.
                    HStack {
                        ForEach(goodsCategories, id: \.self) { category in
                            Button {
                                selectedCategory = category
                            } label: {
                                Text(category.rawValue)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(selectedCategory == category ? .accent : Color(uiColor: .darkGray))
                            }
                            .buttonStyle(.bordered)
                        }
                    }
                }
                .scrollIndicators(.hidden)
                .padding(.bottom)
                
                VStack(alignment: .leading){
                    Text("상품이름")
                        .bold()
                    TextField("등록하려는 상품 이름을 입력해주세요.", text: $goodsName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.bottom)
                    Text("상품가격")
                        .bold()
                    HStack{
                        TextField("등록하려는 상품 가격을 입력해주세요.", text: $goodsPrice)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        Text("원")
                            .bold()
                    }
                    .padding(.bottom)
                    Text("상품설명")
                        .bold()
                    TextEditor(text: $goodsContent)
                        .frame(height: 150)
                        .overlay {
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color(UIColor.systemGray6), lineWidth: 2)
                        }
                }
                
                Text("상품사진")
                    .bold()
                    .padding(.top)
                Rectangle()
                    .fill(Color(UIColor.placeholderText))
                    .frame(height: 200)
                    .padding(.bottom)
                
                Button {
                    print("상품 등록 하기")
                    // TODO: 서버에 판매자 상품을 등록하는 로직
                } label: {
                    Text("등록 하기")
                        .foregroundStyle(.white)
                        .font(.title)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background {
                            Capsule(style: .continuous)
                                .fill(isEmptyAnyFields ? Color(UIColor.placeholderText) : .accent)
                                .frame(maxWidth: .infinity)
                        }
                }
                .disabled(isEmptyAnyFields)
            }
            .padding()
        }
    }
}