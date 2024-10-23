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
            if let cart = userStore.userData?.arrayCart, !cart.isEmpty {
                List {
                    ForEach(cart, id: \.id) { cartElement in
                        Section {
                            // 주문 정보와 상세보기 링크
                            HStack {
                                AsyncImage(url: cartElement.goods.thumbnailImageURL) { phase in
                                    switch phase {
                                    case .empty:
                                        // 이미지가 아직 로드되지 않았을 때 (로딩 중일 때)
                                        ProgressView()
                                            .frame(width: 100, height: 100) // 고정된 프레임
                                            .background(Color.gray.opacity(0.2)) // 배경 색으로 빈 영역 표시 (선택)
                                            .cornerRadius(8)
                                        
                                    case .success(let image):
                                        // 이미지 로드가 성공했을 때
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 100, height: 100) // 고정된 프레임
                                            .cornerRadius(8)
                                        
                                    case .failure:
                                        // 이미지 로드가 실패했을 때
                                        Image(systemName: "photo")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 100, height: 100) // 고정된 프레임
                                            .foregroundColor(.gray)
                                            .cornerRadius(8)
                                    @unknown default:
                                        EmptyView()
                                    }
                                }
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(cartElement.goods.name)
                                        .font(.headline)
                                        .lineLimit(2) // 최대 두 줄까지 허용 (더 넓게 사용)
                                        .multilineTextAlignment(.leading) // 왼쪽 정렬
                                    Text("\(cartElement.goods.formattedPrice)   \(cartElement.goodsCount)개")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                                .layoutPriority(1) // 텍스트가 공간을 우선 차지하게 함
                                
                                Spacer()
                                
                                // 작은 크기의 투명한 NavigationLink
                                NavigationLink(destination: OrderDetailView(
                                    isCredit: .constant(true),
                                    isZeroWaste: .constant(true),
                                    usingPoint: userStore.userData?.pointCount ?? 0,
                                    productsPrice: userStore.userData?.cart.reduce(0) {
                                        $0 + ($1.goods.price * $1.goodsCount)
                                    } ?? 0,
                                    requestMessage: .constant("문앞에 놔주세요")
                                )) {
                                    
                                }
                                .frame(width: 20) // 최소한의 공간만 차지
                            }
                            
                            // 교환 및 배송 조회 버튼
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
                            
                            // 구매 후기 쓰기 버튼을 네비게이션 링크로 구현
                            NavigationLink(destination: ReviewWriteView(order: cartElement)) {
                                Text("구매 후기 쓰기")
                                    .frame(maxWidth: .infinity, maxHeight: 50)
                                    .foregroundColor(.gray)
                            }
                        }
                        .listRowSeparator(.hidden)
                    }
                }
                .listStyle(.insetGrouped)
            } else {
                // 주문 내역이 비어 있을 때 표시할 뷰
                VStack {
                    Spacer()
                    Text("주문 내역이 없습니다.")
                        .font(.headline)
                        .padding()
                    Spacer()
                }
            }
        }
        .navigationTitle("주문 내역")
        .navigationBarTitleDisplayMode(.inline)
    }
}
