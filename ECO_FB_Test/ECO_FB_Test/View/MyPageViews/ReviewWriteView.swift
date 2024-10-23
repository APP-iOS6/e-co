//
//  ReviewWriteView.swift
//  ECO_FB_Test
//
//  Created by Hwang_Inyoung on 10/22/24.
//

import SwiftUI

struct ReviewWriteView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(UserStore.self) private var userStore: UserStore
    @State private var starRank: Int = 0
    @State private var bodyContent: String = ""
    @State private var title: String = "" // 리뷰 제목 상태 추가
    @State private var selectedImages: [UIImage] = [] // 선택한 이미지 배열
    @State private var uploadedURLs: [URL] = [] // 업로드된 URL 저장
    @State private var isUploading = false // 업로드 상태
    @State private var isShowingPhotoPicker = false // 포토 피커 표시 플래그
    let order: CartElement // 주문 정보를 전달받음

    var body: some View {
        NavigationStack {
            ScrollView { // 전체 내용을 스크롤 가능하게 감싸기
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
                                .lineLimit(2)
                            Text("\(order.goods.formattedPrice) - \(order.goodsCount)개")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.bottom, 10)

                    // 리뷰 제목 입력 필드
                    TextField("리뷰 제목을 입력하세요", text: $title)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.5)))
                        .padding(.bottom, 10)

                    // 별점 선택
                    HStack {
                        Text("별점:")
                        Spacer()
                        starRatingView
                    }

                    // 텍스트 에디터
                    TextEditor(text: $bodyContent)
                        .frame(height: 200)
                        .padding(4)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                        )
                    
                    // 이미지 추가 및 미리보기
                    VStack(alignment: .leading) {
                        Button(action: {
                            isShowingPhotoPicker = true
                        }) {
                            HStack {
                                Image(systemName: "photo.on.rectangle.angled")
                                Text("이미지 추가")
                            }
                            .frame(maxWidth: .infinity, maxHeight: 70) // 최소 높이 설정
                            .padding() // 여유로운 패딩 추가
                            .background(Color.accentColor)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                        }
                        .padding(.bottom, 10)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 10) {
                                ForEach(selectedImages, id: \.self) { image in
                                    ZStack(alignment: .topTrailing) { // ZStack으로 이미지와 버튼을 정렬
                                        Image(uiImage: image)
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 80, height: 80)
                                            .cornerRadius(8)
                                            .clipped() // 이미지를 프레임 안에 잘리게 함
                                        
                                        // X 버튼 오버레이
                                        Button(action: {
                                            removeImage(image) // 이미지 삭제 함수 호출
                                        }) {
                                            Image(systemName: "xmark.circle.fill")
                                                .foregroundColor(.white)
                                                .background(Circle().fill(Color.black.opacity(0.7)))
                                        }
                                        .frame(width: 24, height: 24) // 버튼 크기 조정
                                        .padding(4) // 이미지 모서리와 간격 추가
                                    }
                                }
                            }
                        }
                        .frame(height: 80)
                    }
                    .padding(.vertical)

                    

                    // 취소 및 등록하기 버튼
                    HStack(spacing: 10) {
                        Button("취소") {
                            dismiss()
                        }
                        .frame(maxWidth: .infinity, minHeight: 50)
                        .background(Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(10)

                        Button("등록하기") {
                            saveReview()
                        }
                        .frame(maxWidth: .infinity, minHeight: 50)
                        .background(isUploading ? Color.gray : Color.accentColor)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .disabled(isUploading)
                    }
                    .padding(.bottom, 10)
                }
                .padding()
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("구매 후기 작성")
            .sheet(isPresented: $isShowingPhotoPicker) {
                PhotoPicker(selectedImages: $selectedImages)
            }
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

    // 이미지 삭제 로직
    private func removeImage(_ image: UIImage) {
        selectedImages.removeAll { $0 == image }
    }

    // 리뷰 저장 로직
    private func saveReview() {
        guard let user = UserStore.shared.userData else {
            print("유저 정보가 없습니다.")
            return
        }

        isUploading = true

        Task {
            do {
                let urls = try await uploadImages()
                let newReview = Review(
                    id: UUID().uuidString,
                    user: user,
                    goodsID: order.goods.id,
                    title: title.isEmpty ? order.goods.name : title, // 제목이 비어 있으면 상품명 사용
                    content: bodyContent,
                    contentImages: urls,
                    starCount: starRank,
                    creationDate: Date()
                )
              
                _ = try await DataManager.shared.updateData(
                    type: .review,
                    parameter: .reviewUpdate(id: newReview.id, review: newReview)
                )

                print("리뷰가 성공적으로 저장되었습니다.")
                dismiss()
            } catch {
                print("이미지 업로드 중 오류 발생: \(error.localizedDescription)")
            }
            isUploading = false
        }
    }

    // 이미지 업로드 로직
    private func uploadImages() async throws -> [URL] {
        var uploadedURLs: [URL] = []

        for image in selectedImages {
            guard let imageData = image.jpegData(compressionQuality: 0.8) else { continue }
            let parameter = StorageParam.uploadGoodsThumbnail(goodsID: UUID().uuidString, image: image)

            let result = try await StorageManager.shared.upload(type: .goods, parameter: parameter)

            if case let .single(url) = result {
                uploadedURLs.append(url)
            }
        }

        return uploadedURLs
    }
}
