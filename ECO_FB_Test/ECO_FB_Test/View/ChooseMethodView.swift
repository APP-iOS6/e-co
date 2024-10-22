//
//  MethodOfPaymentView.swift
//  ECO_FB_Test
//
//  Created by 이소영 on 10/18/24.
//


import SwiftUI

/**
결제방법 또는 포장방법을 선택하는 화면
 - parameter isCredit: 신용카드 결제인지 무통장입금인지 구분하는 불리언
 - parameter isZeroWaste: 친환경 포장인지 일반포장인지 구분하는 불리언
 - parameter isPaymentView: 결제방법 화면인지 포장방법 화면인지 구분하는 불리언
 */
struct ChooseMethodView: View {
    @Binding var isCredit: Bool
    @Binding var isZeroWaste: Bool
    var isPaymentView: Bool // true: 결제방법 선택 뷰, false: 포장방법 선택 뷰
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(isPaymentView ? "결제방법" : "포장방법")
                .foregroundStyle(Color(uiColor: .darkGray))
                .fontWeight(.bold)
                .padding(.top)
                .padding(.bottom, 5)
            
            if !isPaymentView {
                Text("친환경 포장 이용시 배송비를 할인해드립니다")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(.gray)
            }
            
            HStack(spacing: 30) {
                Button {
                    if isPaymentView {
                        isCredit = true
                    } else {
                        isZeroWaste = true
                    }
                } label: {
                    HStack {
                        Circle()
                            .frame(width: 5, height: 5)
                            .foregroundStyle(isPaymentView ? (isCredit ? .accent : .gray) : (isZeroWaste ? .accent : .gray))
                        Text(isPaymentView ? "신용카드" : "친환경 포장")
                    }
                }
                .fontWeight(isPaymentView ? (isCredit ? .bold : .thin) : (isZeroWaste ? .bold : .thin))
                
                Button {
                    if isPaymentView {
                        isCredit = false
                    } else {
                        isZeroWaste = false
                    }
                } label: {
                    HStack {
                        Circle()
                            .frame(width: 5, height: 5)
                            .foregroundStyle(isPaymentView ? (!isCredit ? .accent : .gray) : (!isZeroWaste ? .accent : .gray))
                        Text(isPaymentView ? "무통장 입금" : "일반 포장")
                    }
                }
                .fontWeight(isPaymentView ? (!isCredit ? .bold : .thin) : (!isZeroWaste ? .bold : .thin))
                
                Spacer()
            }
            .foregroundStyle(Color(uiColor: .darkGray))
        }
    }
}
