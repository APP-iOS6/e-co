//
//  GoodsDetailView.swift
//  ECO_FB_Test
//
//  Created by wonhoKim on 10/14/24.
//

import SwiftUI
import NukeUI

struct GoodsDetailView: View {
    @Environment(UserStore.self) private var userStore: UserStore
    @Environment(\.dismiss) private var dismiss
    var goods: Goods
    var thumbnail: URL
    @State private var isShowReview: Bool = false
    @State private var isShowToast = false
    @State private var toastMessage: String = ""
    private var dataUpdateFlow: DataFlow {
        DataManager.shared.getDataFlow(of: .goods)
    }
    private var isUpdating: Bool {
        dataUpdateFlow == .loading ? true : false
    }
    
    var body: some View {
        VStack {
            ZStack {
                VStack {
                    ScrollView {
                        VStack {
                            LazyImage(url: thumbnail) { state in
                                if let image = state.image {
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(maxWidth: .infinity)
                                        .padding(.bottom)
                                } else if state.isLoading {
                                    ProgressView()
                                }
                            }
                        }
                        
                        LazyVStack(alignment: .leading) {
                            HStack(alignment: .center) {
                                LazyImage(url: goods.seller.profileImageURL) { state in
                                    if let image = state.image {
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 25, height: 25)
                                    } else {
                                        ProgressView()
                                            .frame(minHeight: 80)
                                    }
                                    
                                    if let error = state.error {
                                        Text("Lazy Image Error: \(error)")
                                    }
                                }
                                .priority(.high)
                                
                                Text("\(goods.seller.name)")
                                    .fontWeight(.semibold)
                            }
                            
                            Divider()
                            
                            HStack {
                                Text("카테고리")
                                Image(systemName: "chevron.right")
                                Text("\(goods.category.rawValue)")
                                Spacer()
                            }
                            .font(.system(size: 14))
                            .padding(.vertical, 5)
                            .foregroundStyle(Color(uiColor: .darkGray))
                            
                            HStack(alignment: .center) {
                                Text(goods.name)
                                    .font(.title2)
                                    .fontWeight(.semibold)
                                
                                Spacer()
                                
                                Button {
                                    if var user = userStore.userData {
                                        Task {
                                            if  user.goodsFavorited.contains(goods) {
                                                user.goodsFavorited.remove(goods)
                                            } else {
                                                user.goodsFavorited.insert(goods)
                                            }
                                            
                                            _ = try await DataManager.shared.updateData(type: .user, parameter: .userUpdate(id: user.id, user: user))
                                        }
                                    } else {
                                        toastMessage = "로그인이 필요합니다"
                                        isShowToast = true
                                    }
                                } label: {
                                    if let user = userStore.userData {
                                        if user.goodsFavorited.contains(goods) {
                                            Image(systemName: "heart.fill")
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: 25, height: 25)
                                                .foregroundStyle(.pink)
                                                .shadow(color: .black, radius: 1)
                                        } else {
                                            Image(systemName: "heart")
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: 25, height: 25)
                                                .foregroundStyle(.white)
                                                .shadow(color: .black, radius: 1)
                                        }
                                    } else {
                                        Image(systemName: "heart")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 25, height: 25)
                                            .foregroundStyle(.white)
                                            .shadow(color: .black, radius: 1)
                                    }
                                }
                                .font(.title2)
                            }
                            .padding(.bottom, 5)
                            
                            HStack {
                                Text(goods.formattedPrice)
                                    .font(.title2)
                                    .bold()
                                
                                Spacer()
                                
                                Button {
                                    isShowReview.toggle()
                                } label: {
                                    Text("리뷰보기")
                                        .underline()
                                }
                                .foregroundStyle(Color(uiColor: .darkGray))
                            }
                            .sheet(isPresented: $isShowReview) {
                                ReviewListView(goods: goods)
                            }
                            Divider()
                            
                            Section(header:
                                        Text("상품설명")
                                .font(.system(size: 14))
                                .padding(.vertical, 5)
                                .foregroundStyle(Color(uiColor: .darkGray))
                            ) {
                                
                                Text(goods.bodyContent)
                                    .multilineTextAlignment(.leading)
                                    .lineSpacing(7)
                                    .padding(.bottom, 30)
                            }
                        }
                    }
                    .scrollIndicators(.hidden)
                    
                    
                }
                Spacer()
                SignUpToastView(isVisible: $isShowToast, message: toastMessage)
                
                if isUpdating {
                    ProgressView()
                }
            }
            
            HStack {
                Button {
                    if var user = userStore.userData {
                        Task {
                            let cartElement = CartElement(id: UUID().uuidString, goods: goods, goodsCount: 1)
                            user.cart.insert(cartElement)
                            
                            _ = try await DataManager.shared.updateData(type: .user, parameter: .userUpdate(id: user.id, user: user))
                        }
                        toastMessage = "장바구니에 추가되었습니다"
                    } else {
                        toastMessage = "로그인이 필요합니다"
                    }
                    isShowToast = true
                } label: {
                    Text("장바구니 담기")
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .foregroundStyle(.white)
                        .font(.headline)
                        .background(Color.green)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
            }
            .padding(.top, 5)
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink {
                    CartView()
                } label: {
                    Image(systemName: "cart")
                }
                .foregroundStyle(Color(uiColor: .darkGray))
            }
        }
        .padding()
        .disabled(isUpdating)
        .onAppear {
            Task {
                if var user = userStore.userData {
                    user.goodsRecentWatched.insert(goods)
                    
                    _ = try await DataManager.shared.updateData(type: .user, parameter: .userUpdate(id: user.id, user: user))
                }
            }
        }
    }
}

#Preview {
    let sampleGoods = Goods(
        id: "1",
        name: "멋진 에코백",
        category: .passion,
        thumbnailImageURL: URL(string: "https://png.pngtree.com/png-vector/20190704/ourmid/pngtree-leaf-graphic-icon-design-template-vector-illustration-png-image_1538440.jpg")!,
        bodyContent: """
"자연을 닮은 친환경 에코백"
가볍고 실용적인 디자인으로 일상에서 언제나 손쉽게 사용할 수 있는 에코백입니다. 내구성이 뛰어나며, 다양한 용도로 활용 가능해 장보기, 출퇴근, 여행 등 어디서든 편리하게 사용할 수 있습니다. 이 에코백은 단순한 가방 그 이상으로, 우리의 작은 실천이 지구를 지키는 데 큰 역할을 한다는 메시지를 담고 있습니다. 자연을 생각하는 당신의 선택, 친환경 에코백과 함께 더 나은 미래를 만들어가세요. 더불어, 이 에코백은 세탁이 가능해 오래도록 깨끗하게 사용할 수 있으며, 심플한 디자인으로 다양한 스타일에 잘 어울립니다. 플라스틱 사용을 줄이고 환경 보호를 실천하는 첫걸음으로, 작은 선택이 큰 변화를 만듭니다. 환경을 지키기 위한 실용적인 선택, 지금부터 함께 시작하세요. 우리의 미래는 여러분의 손에 달려 있습니다.
""",
        bodyImageNames: [],
        price: 15000,
        seller: UserStore.shared.userData ?? User(id: UUID().uuidString, loginMethod: LoginMethod.google.rawValue, isSeller: true, name: "Lucy", profileImageURL: URL(string: "https://firebasestorage.googleapis.com/v0/b/e-co-4f9aa.appspot.com/o/user%2Fdefault_profile.png?alt=media&token=afe3a2fd-d85b-49c8-8d4d-dcf773e928ef")!, pointCount: 0, cart: [], goodsRecentWatched: [], goodsFavorited: [])
    )
    
    
    GoodsDetailView(goods: sampleGoods, thumbnail: URL(string: "https://kean-docs.github.io/nukeui/images/nukeui-preview.png")!)
        .environment(UserStore.shared)
}
