//
//  SellerHomeView.swift
//  ECO_FB_Test
//
//  Created by 최승호 on 10/20/24.
//


//
//  SellerHomeView.swift
//  ECO_FB_Test
//
//  Created by 최승호 on 10/20/24.
//

import SwiftUI

struct SellerHomeView: View {
    var body: some View {
        VStack{
            GeometryReader{ proxy in
                VStack(alignment: .center){
                    HStack {
                        Image(systemName: "leaf.fill")
                            .foregroundStyle(.accent)
                        
                        Text("이코")
                            .fontWeight(.bold)
                    }
                }
                .font(.largeTitle)
                .frame(width: proxy.size.width, height: proxy.size.height * (3/7))
                
                SellerBottomView()
            }
        }
    }
}

#Preview("판매자 홈") {
    NavigationStack{
        SellerHomeView()
    }
}

// 판매자 홈뷰의 하단영역 뷰
struct SellerBottomView: View {
    var body: some View {
        GeometryReader{ proxy in
            VStack {
                NavigationLink(destination: ProductSubmitView()) {
                    ZStack{
                        Rectangle()
                            .cornerRadius(20)
                            .frame(width: proxy.size.width * (9/10), height: proxy.size.height / 10)
                        Text("상품 등록")
                            .foregroundStyle(.white)
                            .font(.title)
                            .fontWeight(.bold)
                    }
                }
                .padding()
                
                NavigationLink(destination: OrderManageView()) {
                    ZStack{
                        Rectangle()
                            .cornerRadius(20)
                            .frame(width: proxy.size.width * (9/10), height: proxy.size.height / 10)
                        Text("주문 관리")
                            .foregroundStyle(.white)
                            .font(.title)
                            .fontWeight(.bold)
                    }
                }
                .padding()
                
                NavigationLink(destination: HelpManageView()) {
                    ZStack{
                        Rectangle()
                            .cornerRadius(20)
                            .frame(width: proxy.size.width * (9/10), height: proxy.size.height / 10)
                        Text("문의 관리")
                            .foregroundStyle(.white)
                            .font(.title)
                            .fontWeight(.bold)
                    }
                }
                .padding()
            }
            .frame(width: proxy.size.width, height: proxy.size.height * (4/7))
            .offset(x: 0, y: proxy.size.height * (3/7))
        }
    }
}

// 상품 등록 뷰
struct ProductSubmitView: View {
    private var goodsCategories = GoodsCategory.allCases.filter{ $0.rawValue != "none" }.sorted { a, b in
        a.rawValue > b.rawValue
    }
    @State private var selectedCategory: GoodsCategory? = nil
    @State private var goodsName: String = ""
    @State private var goodsContent: String = ""
    @State private var goodsPrice: String = ""
    //    @State private var goodsImage: Image? = nil   // 판매자는 사진 업로드 하는 방식...?
    private var isEmptyAllFields: Bool {
        selectedCategory == nil && goodsName.isEmpty && goodsContent.isEmpty && goodsPrice.isEmpty
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
                                    .foregroundStyle(Color(uiColor: .darkGray))
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
                                .fill(isEmptyAllFields ? Color(UIColor.placeholderText) : .accent)
                                .frame(maxWidth: .infinity)
                        }
                }
                .disabled(isEmptyAllFields)
            }
            .padding()
        }
    }
}

struct SellerCapsuleTitleView: View {
    var title: String
    var body: some View {
        Text("\(title)")
            .foregroundStyle(.white)
            .font(.title3)
            .fontWeight(.bold)
            .padding()
            .background {
                Capsule()
                    .foregroundStyle(.accent)
                    .shadow(radius: 5)
            }
    }
}

#Preview("상품등록") {
    NavigationStack{
        ProductSubmitView()
    }
}

// 주문 관리 뷰
struct OrderManageView: View {
    @State private var isOn: Bool = false
    
    var body: some View {
        AppNameView()
        VStack(alignment: .leading){
            SellerCapsuleTitleView(title: "주문 관리")
                .padding(.bottom)
            Text("현재 들어온 주문들입니다.")
                .bold()
                .padding(.bottom)
            
            ScrollView(.vertical){
                ForEach(0..<10){ index in
                    HStack{
                        Text("\(index)")
                            .bold()
                            .foregroundStyle(.white)
                            .padding()
                            .background {
                                Circle()
                                    .fill(Color.accentColor)
                            }
                            .padding(.trailing)
                        Text("가방")
                        Spacer()
                        CheckBox(isOn: $isOn)
                            .padding(.trailing)
                    }
                    .frame(maxWidth: .infinity)
                    Divider()
                }
            }
            .padding(.horizontal)
            
            Button {
                print("배송 알림 전송했습니다.")
                // TODO: 선택상품을 구매한 유저에게 알림 전송 로직
            } label: {
                Text("배송 알림 전송")
                    .foregroundStyle(.white)
                    .font(.title)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background {
                        Capsule(style: .continuous)
                            .fill(.accent)
                            .frame(maxWidth: .infinity)
                    }
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
    }
}

#Preview("주문관리") {
    NavigationStack{
        OrderManageView()
    }
}

// 문의 관리 뷰
struct HelpManageView: View {
    var body: some View {
        Text("문의 관리 뷰")
    }
}
