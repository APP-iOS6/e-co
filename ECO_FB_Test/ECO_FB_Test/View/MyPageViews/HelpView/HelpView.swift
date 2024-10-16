//
//  HelpView.swift
//  ECO_FB_Test
//
//  Created by 배문성 on 10/16/24.
//

import SwiftUI

struct HelpView: View {
    var body: some View {
        List {
            Section(header: Text("지원")
                .font(.headline)
                .foregroundColor(.gray)
                ) {
                    NavigationLink("공지사항", destination: NoticeView())  // NoticeView로 이동
                    NavigationLink("FAQ", destination: FAQView())
                    NavigationLink("1:1 문의", destination: InquiriesView())
                    NavigationLink("개인정보 고지", destination: PrivacyPolicyView())
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("도움말")
        }
    }

#Preview {
    NavigationStack {
        HelpView()
    }
}
