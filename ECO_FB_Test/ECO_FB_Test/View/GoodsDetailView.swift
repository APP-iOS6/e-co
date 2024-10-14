//
//  GoodsDetailView.swift
//  ECO_FB_Test
//
//  Created by wonhoKim on 10/14/24.
//

import SwiftUI

struct GoodsDetailView: View {
    var goods: Goods
    
    var body: some View {
        //이미지 > 회사이름 조그맣게 > 디바이더 > 카테고리 > 상품이름 > 금액 > 디바이더 > 상품설명 > 장바구니담기버튼및구매버튼
        VStack {
            VStack(spacing: 5) {
                Image(goods.thumbnailImageName)
                    .resizable()
                    .frame(width: 400, height: 250)
                Text(goods.seller.name)
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            Divider()
            
            VStack(spacing: 10) {
                Text(goods.category.rawValue)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text(goods.name)
                    .font(.title)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text(goods.formattedPrice)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            Divider()
            
            ScrollView {
                Text(goods.bodyContent)
                    .multilineTextAlignment(.leading)
                    .lineSpacing(7)
            }
            .padding(5)
            
            Spacer()
            
            HStack {
                Button {
                    //장바구니 담기 로직
                    print("\(goods.name) 장바구니 담기 ")
                } label: {
                    Text("장바구니 담기")
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .foregroundStyle(.black)
                        .background(Color.blue)
                        .font(.headline)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                
                Button {
                    //구매로직
                    print("\(goods.name) 바로 구매")
                } label: {
                    Text("바로 구매하기")
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .foregroundStyle(.black)
                        .background(Color.blue)
                        .font(.headline)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
            }
            
            Spacer()
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
    
    
    GoodsDetailView(goods: sampleGoods)
}
