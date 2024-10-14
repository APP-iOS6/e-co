//
//  PrivacyPolicyView.swift
//  ECO_FB_Test
//
//  Created by Hwang_Inyoung on 10/14/24.
//

import SwiftUI

struct PrivacyPolicyView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                Text("개인정보 처리방침")
                    .font(.largeTitle)
                    .bold()
                    .padding(.bottom, 20)
                
                Text("1. 개인정보의 수집 및 이용 목적")
                    .font(.headline)
                Text("""
eco 앱은 서비스 제공을 위한 최소한의 개인정보를 수집합니다. 수집된 개인정보는 다음의 목적에 따라 이용됩니다:
- 회원 관리: 회원가입 의사 확인, 본인 식별 및 인증, 회원 자격 유지·관리
- 서비스 제공: 콘텐츠 제공, 맞춤 서비스 제공, 구매 및 요금 결제, 물품 배송
- 마케팅 및 광고 활용: 이벤트 정보 및 참여 기회 제공, 광고성 정보 제공
""")
                
                Text("2. 수집하는 개인정보의 항목")
                    .font(.headline)
                Text("""
- 필수 항목: 이름, 이메일, 비밀번호, 연락처
- 선택 항목: 생년월일, 성별, 주소
""")
                
                Text("3. 개인정보의 보유 및 이용 기간")
                    .font(.headline)
                Text("""
- 회원 탈퇴 시까지, 관련 법령에 의한 보존 기간을 따름. (전자상거래법에 따른 계약 또는 청약철회 기록: 5년)
""")
                
                Text("4. 개인정보의 제3자 제공")
                    .font(.headline)
                Text("""
eco 앱은 원칙적으로 이용자의 개인정보를 외부에 제공하지 않습니다. 다만, 이용자의 사전 동의를 받거나 법령의 규정에 따라 제공이 필요한 경우에만 예외적으로 제공할 수 있습니다.
""")
                
                Text("5. 개인정보의 위탁")
                    .font(.headline)
                Text("""
서비스 향상을 위해 개인정보 처리를 위탁할 경우, 위탁받는 자와 그 업무 내용을 사전에 고지하고 동의를 받습니다. 예시로, 결제 처리를 위한 외부 결제 대행 서비스가 있습니다.
""")
                
                Text("6. 개인정보의 파기 절차 및 방법")
                    .font(.headline)
                Text("""
- 파기 절차: 이용자가 서비스 해지 요청 시, 보유 기간이 종료된 개인정보는 파기 절차를 거칩니다.
- 파기 방법: 전자 파일 형태는 복구 불가능한 방법으로 삭제되며, 출력물은 분쇄기로 파쇄합니다.
""")
                
                Text("7. 이용자의 권리 및 행사 방법")
                    .font(.headline)
                Text("""
- 이용자는 언제든지 개인정보 열람, 정정, 삭제를 요청할 수 있습니다.
- 개인정보 관련 문의는 고객센터를 통해 접수하며, 접수 후 10일 이내에 처리됩니다.
""")
                
                Text("8. 개인정보 보호책임자")
                    .font(.headline)
                Text("""
eco 앱은 개인정보 보호와 관련한 요청을 처리하기 위해 개인정보 보호책임자를 지정하고 있습니다.
""")
            }
            .padding()
        }
        .navigationTitle("개인정보 처리방침")
    }
}

#Preview {
    PrivacyPolicyView()
}
