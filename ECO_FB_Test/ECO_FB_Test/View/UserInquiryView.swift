//
//  UserInquiryView.swift
//  ECO_FB_Test
//
//  Created by wonhoKim on 10/21/24.
//

import SwiftUI

struct UserInquiryView: View {
    @Environment(UserStore.self) private var userStore: UserStore
    @State private var title: String = ""
    @State private var message: String = ""
    @State private var isSubmitted: Bool = false
    let inquiryStore = OneToOneInquiryStore.shared
    @State private var sellers: [User] = []
    @State private var selectedSellerID: String? = nil
    @State private var selectedSeller: User? {
        didSet {
            // 선택된 셀러가 업데이트 될 때마다, ID도 업데이트
            selectedSellerID = selectedSeller?.id
        }
    }
    @State private var isLoading: Bool = true
    var body: some View {
        VStack(spacing: 10) {
            //유아이 이따가 다듬기
            List{
                Picker("문의할 셀러", selection: $selectedSellerID) {
                    ForEach(sellers, id: \.id) { seller in
                        Text(seller.name).tag(seller.id as String?)
                    }
                }
            }.onChange(of: selectedSellerID) { newValue in
                // 선택된 ID에 따라 셀러를 업데이트
                if let id = newValue {
                    selectedSeller = sellers.first { $0.id == id }
                } else {
                    selectedSeller = nil
                }
            }
            //            }
            
            TextField("제목을 입력하세요.", text: $title)
                .frame(height: 10)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)
            
            TextEditor(text: $message)
                .frame(height: 400)
                .padding(4)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                )
            
            Button(action: {
                print("전송 버튼 클릭")
                isSubmitted = true
                //inquiryStore.saveInquiry(inquiry: )
                guard let user = userStore.userData else {
                    print("유저 정보가 없습니다.")
                    return
                }
                guard let seller = selectedSeller else {
                    print("셀러를 선택해야 합니다.")
                    return
                }
                
                let newInquiry = OneToOneInquiry(
                    id: UUID().uuidString,
                    creationDate: Date(),
                    user: user,
                    seller: seller, // 셀러를 피커에서 선택하여 지정 -> 셀러뷰에선 본인 계정에 들어온 문의만 받아야햄 
                    title: title,
                    question: message,
                    answer: ""
                )
                Task {
                    do {
                        try await inquiryStore.saveInquiry(inquiry: newInquiry)
                        isSubmitted = true
                        // 필드 초기화
                        title = ""
                        message = ""
                    } catch {
                        print("파베 업로드 안됌")
                    }
                }
            }) {
                Text("전송하기")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .cornerRadius(8)
            }
            .alert(isPresented: $isSubmitted) {
                Alert(title: Text("문의 완료"), message: Text("1:1 문의가 성공적으로 전송되었습니다."), dismissButton: .default(Text("확인")))
            }
            Spacer()
        }
        .padding()
        .frame(maxHeight: .infinity, alignment: .top)
        .navigationTitle("1:1 문의하기")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await loadSellers()
        }
        
    }
    
    private func loadSellers() async {
        do {
            // 셀러 목록 로딩
            let fetchedSellers = try await UserStore.shared.fetchSellers()
            DispatchQueue.main.async {
                sellers = fetchedSellers
                selectedSellerID = sellers.first?.id  // 기본 선택
                isLoading = false // 로딩 완료
            }
        } catch {
            print("Error fetching sellers: \(error)")
            DispatchQueue.main.async {
                isLoading = false // 로딩 실패
            }
        }
    }
    
}

#Preview {
    UserInquiryView()
        .environment(UserStore.shared)
}
