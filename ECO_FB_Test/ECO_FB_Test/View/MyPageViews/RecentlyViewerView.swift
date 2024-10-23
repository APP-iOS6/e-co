//
//  RecentlyViewedView.swift
//  ECO_FB_Test
//
//  Created by 배문성 on 10/15/24.
//

import SwiftUI
import FirebaseFirestore
import NukeUI

struct RecentlyViewedView: View {
    
    @Environment(UserStore.self) private var userStore: UserStore
    
    var body: some View {
        NavigationView{
            if let user = userStore.userData {
                if user.arrayRecentWatched.isEmpty {
                    Text("최근 본 상품이 없습니다.")
                        .font(.headline)
                        .padding()
                } else {
                    List(user.arrayRecentWatched, id: \.self) { recentWatched in
                        HStack {
                            // LazyImage 사용: goods의 thumbnailImageURL을 접근합니다.
                            LazyImage(url: recentWatched.goods.thumbnailImageURL) { state in
                                if let image = state.image {
                                    image
                                        .resizable()
                                        .frame(width: 100, height: 100)
                                        .cornerRadius(8)
                                } else {
                                    ProgressView()
                                        .frame(width: 100, height: 100) // 프로그레스 뷰도 동일한 크기로 유지
                                }
                            }

                            VStack(alignment: .leading) {
                                // goods의 이름과 가격을 표시합니다.
                                Text(recentWatched.goods.name)
                                    .font(.headline)

                                Text(recentWatched.goods.formattedPrice)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)

                                // 본 날짜를 표시합니다.
                                Text(recentWatched.formattedWatchedDate)
                                    .font(.footnote)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .navigationTitle("최근 본 상품")
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        RecentlyViewedView()
            .environment(UserStore.shared)
    }
}
