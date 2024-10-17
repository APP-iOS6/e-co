//
//  GoodsDetailView.swift
//  ECO_FB_Test
//
//  Created by wonhoKim on 10/14/24.
//

import SwiftUI
import NukeUI

struct GoodsDetailView: View {
    @Environment(\.dismiss) private var dismiss
    var goods: Goods
    var thumbnail: URL
    @State var moveToCart: Bool = false
    @State var isBought: Bool = false
    
    var body: some View {
        GeometryReader { GeometryProxy in
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
                            HStack(alignment: .bottom) {
                                Text(goods.name)
                                    .font(.title)
                                Spacer()
                                Text(goods.formattedPrice)
                                    .font(.title2)
                            }
                            .padding(.top)
                            
                            Divider()
                            
                            Section(header:
                                        Text("상세정보")
                                .font(.system(size: 14))
                                .padding(.vertical, 5)
                                .foregroundStyle(Color(uiColor: .darkGray))
                            ) {
                                Text("분류: \(goods.category.rawValue)")
                                Text("판매자: \(goods.seller.name)")
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
                        .frame(width: GeometryProxy.size.width)
                    }

                .scrollIndicators(.hidden)
                
                HStack {
                    Button {
                        if var user = UserStore.shared.userData {
                            Task {
                                user.cart.insert(goods)
                                await DataManager.shared.updateData(type: .user, parameter: .userUpdate(id: user.id, user: user)) { _ in
                                    

                                }
                            }
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
                VStack {
                    Spacer()
                    SignUpToastView(isVisible: $isBought, message: "물품 구매가 완료되었습니다.")
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    moveToCart = true
                } label: {
                    Image(systemName: "cart")
                }
                .sheet(isPresented: $moveToCart) {
                    CartView(isBought: $isBought)
                }
                .foregroundStyle(Color(uiColor: .darkGray))
            }
        }
        .padding()
    }
}

#Preview {
    
    let sampleGoods = Goods(
        id: "1",
        name: "멋진 에코백",
        category: .passion,
        thumbnailImageName: "ecoBags",
        bodyContent: """
"자연을 닮은 친환경 에코백"
가볍고 실용적인 디자인으로 일상에서 언제나 손쉽게 사용할 수 있는 에코백입니다. 내구성이 뛰어나며, 다양한 용도로 활용 가능해 장보기, 출퇴근, 여행 등 어디서든 편리하게 사용할 수 있습니다. 이 에코백은 단순한 가방 그 이상으로, 우리의 작은 실천이 지구를 지키는 데 큰 역할을 한다는 메시지를 담고 있습니다. 자연을 생각하는 당신의 선택, 친환경 에코백과 함께 더 나은 미래를 만들어가세요. 더불어, 이 에코백은 세탁이 가능해 오래도록 깨끗하게 사용할 수 있으며, 심플한 디자인으로 다양한 스타일에 잘 어울립니다. 플라스틱 사용을 줄이고 환경 보호를 실천하는 첫걸음으로, 작은 선택이 큰 변화를 만듭니다. 환경을 지키기 위한 실용적인 선택, 지금부터 함께 시작하세요. 우리의 미래는 여러분의 손에 달려 있습니다.
""",
        bodyImageNames: [],
        price: 15000,
        seller: Seller(id: "seller1", name: "(주) 멋사 ", profileImageName: "dd")
    )
    
    
    GoodsDetailView(goods: sampleGoods, thumbnail: URL(string: "https://kean-docs.github.io/nukeui/images/nukeui-preview.png")!)
}
