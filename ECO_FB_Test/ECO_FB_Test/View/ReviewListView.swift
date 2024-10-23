//
//  ReviewListView.swift
//  ECO_FB_Test
//
//  Created by 이소영 on 10/19/24.
//

import SwiftUI
import NukeUI

struct ReviewListView: View {
    var goods: Goods
    @Binding var reviewList: [Review]
    @Binding var reviewFetchFlow: DataFlow
    @State private var showAll: Bool = false
    @State private var clickedReview: String?
     
    var body: some View {
        NavigationStack {
            if reviewFetchFlow == .loading {
                Spacer()
                
                ProgressView()
                
                Spacer()
            } else {
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
                    .padding(.top)
                    
                    ForEach($reviewList, id: \.id) { review in
                        // TODO: 사진 클릭하면 해당사진 크게 보여주기
                        VStack(alignment: .leading, spacing: 15) {
                            HStack {
                                Text("\(review.user.wrappedValue.name)")
                                    .font(.system(size: 18, weight: .bold))
                                
                                Spacer()
                                starView(starRank: review.starCount.wrappedValue)
                            }
                            
                            ScrollView(.horizontal) {
                                HStack(spacing: 10) {
                                    ForEach(review.contentImages, id: \.self) { imageURL in
                                        LazyImage(url: imageURL.wrappedValue) { state in
                                            if let image = state.image {
                                                image
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fit)
                                                    .frame(width: 40, height: 40)
                                            } else {
                                                ProgressView()
                                            }
                                        }
                                    }
                                }
                            }
                            .scrollIndicators(.hidden)
                            
                            Text(review.content.wrappedValue)
                                .lineLimit(showAll && clickedReview == review.id ? nil : 3)
                            
                            HStack {
                                Spacer()
                                Text(review.wrappedValue.formattedCreationDate)
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
    }
    
    private func totalRank() -> Double {
        guard !reviewList.isEmpty else { return 0 }
        
        return Double(reviewList.reduce(0) { $0 + $1.starCount }) / Double(reviewList.count)
    }
}

//#Preview {
//    ReviewListView()
//}
