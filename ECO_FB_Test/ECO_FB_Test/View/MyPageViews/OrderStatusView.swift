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
    @State private var showExchangeAlert = false // 교환/반품 알림 표시
    @State private var showShippingAlert = false // 배송 조회 알림 표시

    var body: some View {
        NavigationStack {
            List {
                ForEach(userStore.userData?.arrayCart ?? [], id: \.id) { cartElement in
                    Section {
                        // 주문 정보와 상세보기 링크
                        HStack {
                            AsyncImage(url: cartElement.goods.thumbnailImageURL) { phase in
                                if let image = phase.image {
                                    image.resizable()
                                        .frame(width: 70, height: 70)
                                        .cornerRadius(8)
                                } else {
                                    ProgressView()
                                }
                            }

                            VStack(alignment: .leading, spacing: 4) {
                                Text(cartElement.goods.name)
                                    .font(.headline)
                                Text("\(cartElement.goods.formattedPrice)   -   \(cartElement.goodsCount)개")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }

                            Spacer()

                            // 주문 상세보기 링크
                            NavigationLink(destination: OrderDetailView(
                                isCredit: .constant(true),
                                isZeroWaste: .constant(true),
                                usingPoint: userStore.userData?.pointCount ?? 0,
                                productsPrice: userStore.userData?.cart.reduce(0) {
                                    $0 + ($1.goods.price * $1.goodsCount)
                                } ?? 0,
                                requestMessage: .constant("문앞에 놔주세요")
                            )) {
                                EmptyView()
                            }
                            .opacity(0) // 링크 표시 숨기기
                        }

                        // 교환 및 배송 조회 버튼
                        HStack {
                            Button("교환, 반품 신청") {
                                showExchangeAlert = true
                            }
                            .buttonStyle(.bordered)
                            .alert("판매자에게 문의해주세요.\nMy-지원-문의하기-1:1문의", isPresented: $showExchangeAlert) {
                                Button("확인", role: .cancel) { }
                            }

                            Spacer()

                            Button("배송 조회") {
                                showShippingAlert = true
                            }
                            .buttonStyle(.borderedProminent)
                            .foregroundColor(.white)
                            .alert("현재 판매자가 주문을 확인하고 있습니다.\n곧 배송이 시작될 예정입니다.\n감사합니다.", isPresented: $showShippingAlert) {
                                Button("확인", role: .cancel) { }
                            }
                        }
                        .padding(.vertical, 2)

                        // 구매 후기 쓰기 버튼을 네비게이션 링크로 구현
                        NavigationLink(destination: ReviewWriteView(order: cartElement)) {
                            Text("구매 후기 쓰기")
                                .frame(maxWidth: .infinity, maxHeight: 50)
//                                .background(Color.blue)
                                .foregroundColor(.gray)
//                                .cornerRadius(10)
                        }
                        .padding(.vertical, 8)
                        
                    }
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("주문 내역")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

}
