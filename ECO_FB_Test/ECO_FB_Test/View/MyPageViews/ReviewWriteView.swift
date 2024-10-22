import SwiftUI

struct ReviewWriteView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(UserStore.self) private var userStore: UserStore
    @State private var starRank: Int = 0
    @State private var bodyContent: String = ""
    let order: CartElement // 주문 정보를 전달받음

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 20) {
                
                // 상품 정보 표시
                HStack(spacing: 15) {
                    AsyncImage(url: order.goods.thumbnailImageURL) { phase in
                        if let image = phase.image {
                            image.resizable()
                                .frame(width: 120, height: 120)
                                .cornerRadius(8)
                        } else {
                            ProgressView()
                        }
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        Text(order.goods.name)
                            .font(.headline)
                            .multilineTextAlignment(.leading)
                            .lineLimit(2) // 제목 최대 두 줄
                        Text("\(order.goods.formattedPrice) - \(order.goodsCount)개")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
                .padding(.bottom, 10)

                // 별점 선택
                HStack {
                    Text("별점:")
                    Spacer()
                    starRatingView
                }

                // 텍스트 에디터
                TextEditor(text: $bodyContent)
                    .frame(height: 250)
                    .padding(4)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                    )

                Spacer()

                // 취소 및 등록하기 버튼
                HStack(spacing: 10) {
                    Button("취소") {
                        dismiss() // 취소 시 화면 닫기
                    }
                    .frame(maxWidth: .infinity, maxHeight: 50)
                    .background(Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(10)

                    Button("등록하기") {
                        saveReview() // 저장 로직 호출
                    }
                    .frame(maxWidth: .infinity, maxHeight: 50)
                    .background(Color.accentColor) // 엑센트 컬러 사용
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .padding(.bottom, 10)
            }
            .padding()
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("구매 후기 작성")
        }
    }

    // 별점 선택 뷰
    private var starRatingView: some View {
        HStack {
            ForEach(1...5, id: \.self) { star in
                Image(systemName: star <= starRank ? "star.fill" : "star")
                    .foregroundColor(star <= starRank ? .yellow : .gray)
                    .onTapGesture {
                        starRank = star
                    }
            }
        }
    }

    // 리뷰 저장 로직
    private func saveReview() {
        guard let user = UserStore.shared.userData else {
            print("유저 정보가 없습니다.")
            return
        }

        // 새로운 리뷰 데이터 생성
        let newReview = Review(
            id: UUID().uuidString,
            user: user,
            goodsID: order.goods.id,
            title: order.goods.name,
            content: bodyContent,
            contentImages: [],
            starCount: starRank,
            creationDate: Date()
        )

        // 데이터 저장 작업 실행
        Task {
            // DataManager를 통한 데이터 업데이트
            await DataManager.shared.updateData(
                type: .review,
                parameter: .reviewUpdate(id: newReview.id, review: newReview)
            ) { updateFlow in
                print("Update Flow: \(updateFlow)")
            }

            print("리뷰가 성공적으로 저장되었습니다.")
            dismiss() // 화면 닫기
        }
    }
}
