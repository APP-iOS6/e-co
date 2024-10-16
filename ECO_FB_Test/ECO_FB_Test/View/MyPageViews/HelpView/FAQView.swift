//
//  FAQView.swift
//  ECO_FB_Test
//
//  Created by Hwang_Inyoung on 10/16/24.
//

import SwiftUI

struct FAQView: View {
    @State private var expandedQuestion: Int? = nil  // 확장된 질문의 인덱스
    
    // 자주 묻는 질문 데이터
    let faqs = [
        ("Q. 회원가입은 어떻게 하나요?", "앱 첫 화면에서 '회원가입' 버튼을 눌러 이메일과 비밀번호를 입력하고 가입할 수 있습니다. Google과 Kakao 계정으로도 가입할 수 있습니다."),
        ("Q. 포인트는 어떻게 적립되나요?", "친환경 활동을 통해서 포인트를 받을 수 있습니다. 추가로 구매 금액의 일정 비율이 포인트로도 적립됩니다."),
        ("Q. 주문한 상품의 배송 상태는 어디서 확인하나요?", "마이페이지에서 '주문 관리' 메뉴를 통해 실시간으로 배송 상태를 확인할 수 있습니다."),
        ("Q. 교환 및 반품은 어떻게 하나요?", "마이페이지의 '주문 관리'에서 교환 및 반품 신청을 할 수 있습니다."),
        ("Q. 건강 데이터 권한이 필요한 이유는 무엇인가요?", "걸음 수 등 건강 데이터를 활용해 친환경 활동 포인트를 적립하기 위해 사용됩니다. 설정에서 권한을 활성화해 주세요."),
        ("Q: 내 개인정보는 안전하게 보호되나요?", "A: 네, 모든 개인 정보는 SSL 암호화를 통해 안전하게 보호됩니다. 또한, 앱 내에서는 고객 동의 없이 정보를 외부에 제공하지 않습니다."),
        ("Q: 개인정보를 수정하거나 삭제할 수 있나요?", "A: 마이페이지의 ‘개인정보 수정’에서 직접 수정할 수 있으며, 삭제 요청은 고객센터를 통해 가능합니다."),
        ("Q: 오프라인 매장도 있나요?", "A: 네, 일부 상품은 오프라인 매장에서 구매할 수 있으며, 매장 위치는 ‘오프라인 매장 찾기’ 탭에서 확인하실 수 있습니다.")
    ]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 15) {
                ForEach(Array(faqs.enumerated()), id: \.offset) { index, faq in
                    VStack {
                        HStack {
                            Text(faq.0)
                                .font(.headline)
                                .padding(.vertical)
                                .foregroundColor(.black)
                            Spacer()
                            Image(systemName: expandedQuestion == index ? "chevron.up" : "chevron.down")
                                .foregroundColor(.gray)
                        }
                        .contentShape(Rectangle())  // 탭 가능하도록 설정
                        .onTapGesture {
                            withAnimation {
                                if expandedQuestion == index {
                                    expandedQuestion = nil  // 이미 선택된 질문이면 닫기
                                } else {
                                    expandedQuestion = index  // 선택된 질문 열기
                                }
                            }
                        }
                        
                        if expandedQuestion == index {
                            Divider()
                            Text(faq.1)
                                .font(.body)
                                .padding(.top, 5)
                                .foregroundColor(.black)
                                .padding(.bottom, 10)
                        }
                    }
                    .padding()
                    .background(Color.white)  // 배경을 흰색으로 설정
                    .cornerRadius(10)
                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)  // 카드 스타일 효과
                    .padding(.horizontal, 20)  // 양옆에 여백 추가
                }
            }
            .padding(.top, 10)
            //                .background(Color(UIColor.systemGroupedBackground))  // 전체 배경 색상 설정
        }
        .navigationTitle("자주 묻는 질문")
        .navigationBarTitleDisplayMode(.inline)  // 네비게이션 타이틀 정렬 설정
        
    }
}

#Preview {
    FAQView()
}
