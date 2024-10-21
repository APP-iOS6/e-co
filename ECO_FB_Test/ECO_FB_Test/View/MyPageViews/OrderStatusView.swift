//
//  OrderStatusView.swift
//  ECO_FB_Test
//
//  Created by 이소영 on 10/18/24.
//

import SwiftUI

struct OrderStatusView: View {
    @Environment(UserStore.self) private var userStore: UserStore
    @State private var selectedPaymentInfo: PaymentInfo? = nil // 선택한 주문 정보

    var body: some View {
        NavigationStack {
            List {
                // 유저의 결제 내역을 날짜별로 정렬하여 표시
                ForEach(userStore.userData?.cart.map { $0.goods } ?? [], id: \.id) { goods in
                    Section(header: Text(goods.name)) {
                        OrderRowView(goods: goods)
                            .onTapGesture {
                                selectedPaymentInfo = createPaymentInfo(for: goods) // 선택한 주문 정보 설정
                            }
                    }
                }
            }
            .listStyle(.inset)
            .navigationTitle("주문 내역")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(item: $selectedPaymentInfo) { paymentInfo in
                OrderDetailView( // 기존 OrderDetailView 호출
                    isCredit: .constant(true),
                    isZeroWaste: .constant(true),
                    usingPoint: userStore.userData?.pointCount ?? 0, productsPrice: userStore.userData?.cart.reduce(0) {
                        $0 + ($1.goods.price * $1.goodsCount)
                    } ?? 0,
                    //productsPrice: paymentInfo.paymentMethodInfo?.amount ?? 0,
                    requestMessage: .constant("문앞에 놔주세요")
                )
            }
        }
    }

    // 주문 정보를 기반으로 PaymentInfo 생성
    private func createPaymentInfo(for goods: Goods) -> PaymentInfo {
        PaymentInfo(
            id: UUID().uuidString,
            userID: userStore.userData?.id ?? "",
            recipientName: "김민수",
            phoneNumber: "010-1234-5678",
            paymentMethod: .card, // 적절한 PaymentMethod 케이스 사용
            paymentMethodInfo: CardInfo(
                id: UUID().uuidString,
                cvc: "123",
                ownerName: "김민수",
                cardNumber: "1234-5678-1234-5678",
                cardPassword: "12",
                expirationDate: Date() // Date 타입으로 전달
            ),
            address: "서울시 강남구 역삼동 철수 아파트"
        )
    }
}

// MARK: - 주문 행(Row) 뷰
struct OrderRowView: View {
    let goods: Goods

    var body: some View {
        HStack {
            AsyncImage(url: goods.thumbnailImageURL) { phase in
                if let image = phase.image {
                    image.resizable()
                        .frame(width: 60, height: 60)
                        .cornerRadius(8)
                } else {
                    ProgressView()
                }
            }
            VStack(alignment: .leading, spacing: 4) {
                Text(goods.name).font(.headline)
                Text(goods.formattedPrice)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            Spacer()
        }
        .padding(.vertical, 8)
    }
}
