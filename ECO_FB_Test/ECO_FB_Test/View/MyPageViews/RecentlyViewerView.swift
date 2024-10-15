//
//  RecentlyViewedView.swift
//  ECO_FB_Test
//
//  Created by 배문성 on 10/15/24.
//

import SwiftUI
import FirebaseFirestore

struct RecentlyViewedView: View {
    
    @Environment(UserStore.self) private var userStore: UserStore
    
    var body: some View {
        NavigationView{
            if let user = userStore.userData {
                if user.recentWatchedArray.isEmpty {
                    Text("최근 본 상품이 없습니다.")
                        .font(.headline)
                        .padding()
                } else {
                    List(user.recentWatchedArray, id: \.id) { goods in
                        HStack {
                            Image(goods.thumbnailImageName)
                                .resizable()
                                .frame(width: 100, height: 100)
                                .cornerRadius(8)
                            VStack(alignment: .leading) {
                                Text(goods.name)
                                    .font(.headline)
                                Text(goods.formattedPrice)
                                    .font(.subheadline)
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
    RecentlyViewedView()
}
