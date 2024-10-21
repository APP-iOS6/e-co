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
                ForEach(userStore.userData?.arrayCart ?? [], id: \.id) { cartElement in
                    Section(header: Text(cartElement.goods.name).font(.headline)) {
                        OrderRowView(cartElement: cartElement)
                            .onTapGesture {
                                selectedPaymentInfo = createPaymentInfo(for: cartElement.goods)
                            }
                    }
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("주문 내역")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(item: $selectedPaymentInfo) { paymentInfo in
                OrderDetailView(
                    isCredit: .constant(true),
                    isZeroWaste: .constant(true),
                    usingPoint: userStore.userData?.pointCount ?? 0,
                    productsPrice: userStore.userData?.cart.reduce(0) {
                        $0 + ($1.goods.price * $1.goodsCount)
                    } ?? 0,
                    requestMessage: .constant("문앞에 놔주세요")
                )
            }
        }
    }

    private func createPaymentInfo(for goods: Goods) -> PaymentInfo {
        PaymentInfo(
            id: UUID().uuidString,
            userID: userStore.userData?.id ?? "",
            recipientName: "김민수",
            phoneNumber: "010-1234-5678",
            paymentMethod: .card,
            paymentMethodInfo: CardInfo(
                id: UUID().uuidString,
                cvc: "123",
                ownerName: "김민수",
                cardNumber: "1234-5678-1234-5678",
                cardPassword: "12",
                expirationDate: Date()
            ),
            address: "서울시 강남구 역삼동 철수 아파트"
        )
    }
}

// MARK: - 주문 행(Row) 뷰
struct OrderRowView: View {
    let cartElement: CartElement

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                AsyncImage(url: cartElement.goods.thumbnailImageURL) { phase in
                    if let image = phase.image {
                        image.resizable()
                            .frame(width: 60, height: 60)
                            .cornerRadius(8)
                    } else {
                        ProgressView()
                    }
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(cartElement.goods.name).font(.headline)
                    Text("\(cartElement.goods.formattedPrice) - \(cartElement.goodsCount)개")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                Text("")
            }

            HStack {
                Button("교환, 반품 신청") {
                    print("교환/반품 신청")
                }
                .buttonStyle(.bordered)
                .foregroundColor(.black)

                Spacer()

                Button("배송 조회") {
                    print("배송 조회")
                }
                .buttonStyle(.borderedProminent)
                .foregroundColor(.white)

            }

            Button("구매 후기 쓰기") {
                print("구매 후기 쓰기")
            }
            .frame(maxWidth: .infinity)
            .buttonStyle(.borderless)
            .foregroundColor(.black)
            .padding(.top, 5)
        }
        .padding(.vertical, 10)
    }
}
