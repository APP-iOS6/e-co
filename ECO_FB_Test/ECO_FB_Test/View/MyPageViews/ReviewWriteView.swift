//
//  ReviewWriteView.swift
//  ECO_FB_Test
//
//  Created by Hwang_Inyoung on 10/22/24.
//

import SwiftUI

struct ReviewWriteView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var starRank: Int = 0
    @State private var bodyContent: String = ""
    @State private var selectedImages: [String] = []
    @FocusState private var isFocused: Bool // 키보드 포커스 상태

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 20) {
                Text("리뷰 작성")
                    .font(.largeTitle)
                    .bold()

                // 별점 선택
                HStack {
                    Text("별점:")
                    Spacer()
                    starRatingView
                }

                // 리뷰 내용 입력
                ZStack(alignment: .topLeading) {
                    if bodyContent.isEmpty {
                        Text("리뷰 내용을 입력하세요...")
                            .foregroundColor(.gray)
                            .padding(.horizontal, 8)
                            .padding(.top, 12)
                    }
                    TextEditor(text: $bodyContent)
                        .frame(height: 250)
                        .padding(4)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                        )
                        .focused($isFocused) // 키보드 포커스 적용
                }

                // 이미지 선택 영역 (임시 아이콘으로 표시)
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(selectedImages, id: \.self) { imageName in
                            Image(systemName: imageName)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 50, height: 50)
                        }
                    }
                }
                .frame(height: 60)

                Spacer()

                // 저장 및 취소 버튼
                HStack(spacing: 10) {
                    Button("취소") {
                        dismiss() // 취소 시 화면 닫기
                    }
                    .frame(maxWidth: .infinity, maxHeight: 50)
                    .background(Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(10)

                    Button("저장") {
                        saveReview()
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
            .onTapGesture {
                isFocused = false // 화면을 탭하면 키보드 숨기기
            }
        }
        .onChange(of: isFocused) { focused in
            // 키보드가 나타나면 버튼이 위로 올라가도록 설정
            withAnimation {
                if focused {
                    print("키보드 올라옴")
                }
            }
        }
        .padding(.bottom, isFocused ? 200 : 0) // 키보드 높이만큼 여유 추가
    }

    // 별점 뷰
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

    // 리뷰 저장 로직 (임시)
    private func saveReview() {
        print("리뷰 저장: \(starRank)점, 내용: \(bodyContent)")
        dismiss() // 작성 후 화면 닫기
    }
}

#Preview {
    ReviewWriteView()
}
