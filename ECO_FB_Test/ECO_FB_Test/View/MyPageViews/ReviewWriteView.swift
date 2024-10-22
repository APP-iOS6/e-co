import SwiftUI

struct ReviewWriteView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var starRank: Int = 0
    @State private var bodyContent: String = ""
    let order: CartElement // 주문 정보를 전달받음

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 20) {
                Text("리뷰 작성")
                    .font(.largeTitle)
                    .bold()

                HStack {
                    Text("별점:")
                    Spacer()
                    starRatingView
                }

                TextEditor(text: $bodyContent)
                    .frame(height: 250)
                    .padding(4)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                    )

                Spacer()

                HStack(spacing: 10) {
                    Button("취소") {
                        dismiss() // 취소 시 화면 닫기
                    }
                    .frame(maxWidth: .infinity, maxHeight: 50)
                    .background(Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(10)

                    Button("저장") {
                        saveReview() // 저장 로직 호출
                    }
                    .frame(maxWidth: .infinity, maxHeight: 50)
                    .background(Color.blue)
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

    private func saveReview() {
        // 새로운 리뷰 생성
//        let newReview = Review(
//            id: UUID().uuidString,
//            user: UserStore.shared.userData!, // 현재 로그인한 유저 정보
//            title: order.goods.name, // 상품명
//            content: bodyContent,
//            contentImages: [], // 이미지 배열 (추후 구현 가능)
//            starCount: starRank,
//            creationDate: Date()
//        )

        /*
        // ReviewStore 싱글톤 인스턴스 사용
        Task {
            do {
                try await ReviewStore.shared.addReview(for: order.goods.id, review: newReview)
                print("리뷰가 성공적으로 저장되었습니다.")
                dismiss() // 화면 닫기
            } catch {
                print("리뷰 저장 중 오류 발생: \(error.localizedDescription)")
            }
        }
         */
    }
}
