//
//  NoticeView.swift
//  ECO_FB_Test
//
//  Created by Hwang_Inyoung on 10/14/24.
//

import SwiftUI

struct NoticeView: View {
    @EnvironmentObject var store: NoticeStore // NoticeStore를 환경 객체로 가져옴

    var body: some View {
        NavigationView {
            List(store.notices) { notice in
                VStack(alignment: .leading) {
                    Text(notice.title)
                        .font(.headline)
                    Text(notice.content)
                        .font(.subheadline)
                    Text(notice.date)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            .navigationTitle("공지사항")
        }
    }
}
