//
//  ReviewListView.swift
//  ECO_FB_Test
//
//  Created by 이소영 on 10/19/24.
//

import SwiftUI

// TODO: Review Model 적용하기
// 임시 리뷰 모델
struct Review: Identifiable {
    let id: UUID = UUID()
    let user: User
    let starRank: Int
    let bodyContent: String
    let bodyImageNames: [String]
    let date: Date
}

struct ReviewListView: View {
    private var reviewList: [Review] = [Review(user: User(id: "", loginMethod: "", isSeller: false, name: "김민수", profileImageName: "", pointCount: 0, cart: [], goodsRecentWatched: []), starRank: 4,  bodyContent: "좋아요좋아요좋아요좋아요좋아요좋아요좋아요좋아요좋아요좋아요좋아요좋아요좋아요좋아요좋아요좋아요좋아요좋아요좋아요좋아요좋아요좋아요좋아요좋아요좋아요좋아요좋아요좋아요좋아요좋아요좋아요좋아요좋아요좋아요좋아요좋아요좋아요", bodyImageNames: ["square.fill","square.fill","square.fill","square.fill","square.fill","square.fill","square.fill","square.fill"], date: Date.now), Review(user: User(id: "", loginMethod: "", isSeller: false, name: "김철수", profileImageName: "", pointCount: 0, cart: [], goodsRecentWatched: []), starRank: 1, bodyContent: "구려요", bodyImageNames: [], date: Date.now), Review(user: User(id: "", loginMethod: "", isSeller: false, name: "김김", profileImageName: "", pointCount: 0, cart: [], goodsRecentWatched: []), starRank: 3,  bodyContent: "싫어요싫어요싫어요싫어요싫어요싫어요싫어요싫어요싫어요싫어요싫어요싫어요싫어요싫어요싫어요싫어요싫어요싫어요싫어요싫어요싫어요싫어요싫어요싫어요싫어요싫어요싫어요싫어요싫어요싫어요싫어요싫어요싫어요싫어요싫어요싫어요싫어요싫어요싫어요싫어요싫어요싫어요싫어요싫어요", bodyImageNames: ["square.fill"], date: Date.now)]
    @State private var showAll: Bool = false
    @State private var clickedReview: UUID?
    
    var body: some View {
        NavigationStack {
            List {
                HStack {
                    Text("리뷰(\(reviewList.count))")
                        .font(.title3)
                        .bold()
                    Spacer()
                    
                    Text("\(String(format: "%.1f", totalRank()))점")
                        .bold()
                    starView(starRank: Int(totalRank()))
                }
                
                ForEach(reviewList) { review in
                    // TODO: 사진 클릭하면 해당사진 크게 보여주기
                    VStack(alignment: .leading, spacing: 15) {
                        HStack {
                            Text(review.user.name)
                                .font(.system(size: 18, weight: .bold))
                            
                            Spacer()
                            starView(starRank: review.starRank)
                        }
                        
                        ScrollView(.horizontal) {
                            HStack(spacing: 10) {
                                ForEach(review.bodyImageNames, id: \.self) { imageName in
                                    Image(systemName: imageName)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 40, height: 40)
                                }
                            }
                        }
                        .scrollIndicators(.hidden)
                        
                        Text(review.bodyContent)
                            .lineLimit(showAll && clickedReview == review.id ? nil : 3)
                        
                        HStack {
                            Spacer()
                            Text(review.date.formatted(.dateTime))
                                .font(.system(size: 12, weight: .light))
                                .foregroundStyle(Color(uiColor: .darkGray))
                        }
                    }
                    .onTapGesture {
                        clickedReview = review.id
                        showAll.toggle()
                    }
                }
            }
            .listStyle(.plain)
        }
        
    }
    
    private func totalRank() -> Double {
        Double(reviewList.reduce(0) { $0 + $1.starRank }) / Double(reviewList.count)
    }
}

#Preview {
    ReviewListView()
}
