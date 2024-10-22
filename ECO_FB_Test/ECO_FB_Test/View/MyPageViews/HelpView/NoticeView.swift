//
//  NoticeView.swift
//  ECO_FB_Test
//
//  Created by Hwang_Inyoung on 10/14/24.
//

import SwiftUI

struct NoticeView: View {
    @Environment(AnnouncementStore.self) private var announcementStore: AnnouncementStore
    private var dataFlow: DataFlow {
        DataManager.shared.getDataFlow(of: .announcement)
    }
    
    var body: some View {
        Group {
            if dataFlow == .loading {
                ProgressView("공지사항을 불러오는 중입니다...")
                    .progressViewStyle(CircularProgressViewStyle())
                    .font(.subheadline)
                    .foregroundColor(.gray)
            } else {
                List(announcementStore.announcementList) { announcement in
                    VStack(alignment: .leading) {
                        Text(announcement.title)
                            .font(.headline)
                        Text(announcement.content)
                            .font(.subheadline)
                        Text(announcement.formattedCreationDate)
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
                .navigationTitle("공지사항")
                .navigationBarTitleDisplayMode(.inline)
            }
        }
        .onAppear {
            Task {
                _ = try await DataManager.shared.fetchData(type: .announcement, parameter: .announcementAll)
            }
        }
        EmptyView()
    }
}

#Preview {
    NavigationStack {
        NoticeView()
            .environment(AnnouncementStore.shared)
    }
}
