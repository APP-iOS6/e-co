//
//  OrderView.swift
//  ECO_FB_Test
//
//  Created by 이소영 on 10/18/24.
//

import SwiftUI

// 유저 정보가 있는 경우에만 주문할 수 있음
struct OrderView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(UserStore.self) private var userStore: UserStore
    @State private var isCredit: Bool = true
    @State private var isZeroWaste: Bool = true // 친환경 앱이기 때문에 친환경 포장방식을 기본값으로 했습니다.
    @State private var usingPoint: Int = 0
    @State private var productsPrice: Int = 0
    @State private var deliveryPrice: Int = 3000
    private var totalPrice: Int {
        isZeroWaste ? productsPrice - usingPoint : productsPrice + deliveryPrice - usingPoint
    }
    @State private var requestMessage = "문앞에 놔주세요"
    @State private var isShowToast: Bool = false
    @State private var isShowAlert: Bool = false
    @State private var isComplete: Bool = false // true: 주문완료, false: 주문하기
    @State private var progress: Int = 0
    @State private var dataUpdateFlow: DataFlow = .none

    private var isDidUpdate: Bool {
        dataUpdateFlow == .didLoad
    }
    @State  private var isUpdateOfPaymentFlow = false
    
    var body: some View {
        VStack {
            if var user = userStore.userData {
                ZStack {
                    VStack {
                        ScrollView {
                            LazyVStack(alignment: .center, pinnedViews: [.sectionHeaders]) {
                                Text(isComplete ? "주문완료" : "주문하기")
                                    .font(.title2)
                                    .bold()
                                
                                Divider()
                                
                                // 대표주소 있어야 될 것 같습니다.
                                DeliveryInfo(name: user.name, address: "철수구 철수동 철수로 11 철수 아파트 120동 1202호       ", isComplete: isComplete, requestMessage: $requestMessage)
                                
                                Divider()
                                
                                if !isComplete {
                                    Section(header:
                                                PointInfoView(usingPoint: $usingPoint, point: user.pointCount)
                                        .padding(.bottom, 10)
                                        .background(Rectangle().foregroundColor(.white))
                                    ) {
                                        Divider()
                                        
                                        // 결제 방법 선택 부분
                                        ChooseMethodView(isCredit: $isCredit, isZeroWaste: $isZeroWaste, isPaymentView: true)
                                        
                                        Divider()
                                        
                                        ProductListView(cart: user.arrayCart, usingPoint: usingPoint)
                                        
                                        Divider()
                                        
                                        // 포장 방법 선택 부분
                                        ChooseMethodView(isCredit: $isCredit, isZeroWaste: $isZeroWaste, isPaymentView: false)
                                        
                                        Divider()
                                    }
                                }
                                
                                PriceInfoView(productsPrice: productsPrice, deliveryPrice: deliveryPrice, usingPoint: usingPoint, isZeroWaste: isZeroWaste)
                                
                                Divider()
                                
                                HStack {
                                    Text("총 결제 금액")
                                    Spacer()
                                    Text("\(totalPrice)원")
                                }
                                .bold()
                                .padding(.vertical)
                            }
                        }
                        .padding([.horizontal, .top])
                        .scrollIndicators(.hidden)
                    }
                    VStack{
                        Spacer()
                        SignUpToastView(isVisible: $isShowToast, message: "결제가 완료되었습니다")
                            .padding(.horizontal)
                    }
                    
                    if progress > 0 {
                        ProgressView()
                    }
                }
                
                Button {
                    if isComplete {
                        // TODO: 홈으로 이동하는 로직 구현
                        dismiss()
                    } else {
                        isShowAlert = true
                    }
                } label: {
                    Text(isComplete ? "홈으로" : "결제하기")
                        .foregroundStyle(.white)
                        .font(.title2)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, maxHeight: 50)
                        .background {
                            RoundedRectangle(cornerRadius: 5)
                                .foregroundStyle(.accent)
                        }
                }
                .alert("결제를 완료 하시겠습니까?", isPresented: $isShowAlert, actions: {
                    Button(role: .cancel) {
                        
                    } label: {
                        Text("취소")
                    }
                    
                    Button(role: .destructive) {
                        progress = 1
                        
                        Task {
// TODO: 장바구니 비우기
//                            isUpdateOfPaymentFlow = true
//                            user.cart.removeAll()
//                            _ = try await DataManager.shared.updateData(type: .user, parameter: .userUpdate(id: user.id, user: user))
                            _ = try await DataManager.shared.updateData(type: .paymentInfo, parameter: .paymentInfoUpdate(id: user.id, paymentInfo: PaymentInfo(id: UUID().uuidString, userID: user.id, deliveryRequest: requestMessage, paymentMethod: isCredit ? .card : .bank, addressInfos: [AddressInfo(id: UUID().uuidString, recipientName: user.name, phoneNumber: "010-0000-0000", address: "철수구 철수동 철수로 11 철수 아파트 120동 1202호")])), flow: $dataUpdateFlow)
                        }
                    } label: {
                        Text("결제하기")
                    }
                })
                .padding()
            }
        }
        .disabled(progress > 0)
        .onAppear {
            Task {
                if let user = userStore.userData {
                    isUpdateOfPaymentFlow = false
                    
                    _ = try await DataManager.shared.fetchData(type: .paymentInfo, parameter: .paymentInfoAll(userID: user.id), flow: $dataUpdateFlow)
                }
            }
        }
        .onChange(of: isDidUpdate) { oldValue, newValue in
            if newValue && isUpdateOfPaymentFlow {
                isComplete = true
                isShowToast = true
                progress = 0
            } else if newValue && !isUpdateOfPaymentFlow {
                getProducsPrice()
            }
        }
    }
    
    private func getProducsPrice() {
        productsPrice = 0 // 중복 호출 되는 경우 방지
        
        if let user = userStore.userData {
            for element in user.arrayCart {
                productsPrice = productsPrice + (element.goods.price * element.goodsCount)
            }
        }
    }
}

#Preview {
    OrderView()
        .environment(UserStore.shared)
}
