//
//  NoticeView.swift
//  ECO_FB_Test
//
//  Created by Hwang_Inyoung on 10/14/24.
//

import SwiftUI

struct NoticeView: View {
    @Environment(AnnouncementStore.self) private var announcementStore: AnnouncementStore
    @State private var dataFetchFlow: DataFetchFlow = .none
    
    var body: some View {
        
        Group {
            if announcementStore.announcementList.isEmpty {
                //                Text("공지사항이 없습니다.")
                //                    .font(.subheadline)
                //                    .foregroundColor(.gray)
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
                _ = await DataManager.shared.fetchData(type: .announcement, parameter: .announcementAll) { flow in
                    dataFetchFlow = flow
                }
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
