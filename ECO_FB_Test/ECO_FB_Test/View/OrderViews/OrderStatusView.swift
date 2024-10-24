//
//  OrderStatusView.swift
//  ECO_FB_Test
//
//  Created by 이소영 on 10/18/24.
//

import SwiftUI

struct OrderStatusView: View {
    @Environment(UserStore.self) private var userStore: UserStore
    @State private var orderDetails: [OrderDetail] = [] // 주문 내역 데이터
    @State private var showExchangeAlert = false // 교환/반품 알림 표시
    @State private var showShippingAlert = false // 배송 조회 알림 표시
    private static var isFirstLoad: Bool = true

    var body: some View {
        NavigationStack {
            VStack {
                if orderDetails.isEmpty {
                    // 주문 내역이 없을 때
                    Spacer()
                    Text("주문 내역이 없습니다.")
                        .font(.headline)
                        .padding()
                    Spacer()
                } else {
                    List {
                        ForEach(orderDetails) { orderDetail in
                            Section {
                                ForEach(orderDetail.orderedGoodsInfos) { goodsInfo in
                                    ForEach(goodsInfo.goodsList) { orderedGoods in
                                        orderRow(for: orderedGoods)
                                    }
                                }
                                actionButtons() // 교환, 배송 조회 버튼
                                reviewButton(orderDetail: orderDetail) // 후기 작성 버튼
                            }
                            .listRowSeparator(.hidden)
                        }
                    }
                    .listStyle(.insetGrouped)
                }
            }
            .navigationTitle("주문 내역")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                Task {
                    if OrderStatusView.isFirstLoad {
                        await loadOrderDetails()
                        OrderStatusView.isFirstLoad = false
                    }
                    self.orderDetails = OrderDetailStore.shared.orderDetailList
                }
            }
        }
    }

    // 주문 데이터를 비동기적으로 로드
    private func loadOrderDetails() async {
        guard let userID = userStore.userData?.id else { return }
        do {
            // fetchData의 결과를 강제 캐스팅하여 처리합니다.
            let result = try await DataManager.shared.fetchData(type: .orderDetail,
                parameter: .orderDetailAll(userID: userID, limit: 10)
            )
            
            
        } catch {
            print("주문 내역을 불러오는 중 오류 발생: \(error.localizedDescription)")
        }
    }

    // 주문 정보 행
    private func orderRow(for orderedGoods: OrderedGoods) -> some View {
        HStack {
            AsyncImage(url: orderedGoods.goods.thumbnailImageURL) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .frame(width: 100, height: 100)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 100, height: 100)
                        .cornerRadius(8)
                case .failure:
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .foregroundColor(.gray)
                        .cornerRadius(8)
                @unknown default:
                    EmptyView()
                }
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(orderedGoods.goods.name)
                    .font(.headline)
                Text("\(orderedGoods.goods.formattedPrice) x \(orderedGoods.count)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
    }

    // 교환 및 배송 조회 버튼
    private func actionButtons() -> some View {
        HStack {
            Button("교환, 반품 신청") {
                showExchangeAlert = true
            }
            .buttonStyle(.bordered)
            .foregroundStyle(.black)
            .alert(isPresented: $showExchangeAlert) {
                Alert(
                    title: Text("판매자에게 문의해주세요.")
                        .font(.headline)
                        .foregroundColor(.black),
                    message: Text("My-지원-문의하기-1:1문의")
                        .font(.subheadline)
                        .foregroundColor(.gray),
                    dismissButton: .default(Text("확인"))
                )
            }

            Spacer()

            Button("배송 조회") {
                showShippingAlert = true
            }
            .buttonStyle(.borderedProminent)
            .foregroundColor(.white)
            .alert(isPresented: $showShippingAlert) {
                Alert(
                    title: Text("현재 판매자가 주문을 확인하고 있습니다.")
                        .font(.headline)
                        .foregroundColor(.black),
                    message: Text("곧 배송이 시작될 예정입니다.\n감사합니다.")
                        .font(.subheadline)
                        .foregroundColor(.gray),
                    dismissButton: .default(Text("확인"))
                )
            }
        }
    }

    // 구매 후기 작성 버튼
    private func reviewButton(orderDetail: OrderDetail) -> some View {
        NavigationLink(destination: ReviewWriteView(orderDetail: orderDetail)) {
            Text("구매 후기 쓰기")
                .frame(maxWidth: .infinity, maxHeight: 50)
                .foregroundColor(.gray)
        }
    }
}
