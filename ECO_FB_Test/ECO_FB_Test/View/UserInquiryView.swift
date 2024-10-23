//
//  UserInquiryView.swift
//  ECO_FB_Test
//
//  Created by wonhoKim on 10/21/24.
//
import SwiftUI

struct UserInquiryView: View {
    
    @Environment(UserStore.self) private var userStore: UserStore
    @Environment(\.presentationMode) var presentationMode
    @State private var title: String = ""
    @State private var message: String = ""
    @State private var isSubmitted: Bool = false
    @State var inquiryStore = OneToOneInquiryStore.shared
    @State private var sellers: [User] = []
    @State private var selectedSellerID: String? = nil
    @State private var selectedSeller: User? {
        didSet {
            selectedSellerID = selectedSeller?.id
        }
    }
    @State private var isLoading: Bool = true
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                HStack {
                    Text("문의할 셀러")
                        .font(.headline)
                    Spacer()
                    Picker("셀러 선택", selection: $selectedSellerID) {
                        ForEach(sellers, id: \.id) { seller in
                            Text(seller.name).tag(seller.id as String?)
                        }
                    }.onChange(of: selectedSellerID) { newValue in
                        // 선택된 ID에 따라 셀러를 업데이트
                        if let id = newValue {
                            selectedSeller = sellers.first { $0.id == id }
                        } else {
                            selectedSeller = nil
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)
                
                
                TextField("제목을 입력하세요.", text: $title)
                    .frame(height: 44)
                    .padding(.horizontal)
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
                        seller: seller,
                        title: title,
                        question: message,
                        answer: ""
                    )
                    
                    Task {
                        _ = try await DataManager.shared.updateData(
                            type: .oneToOneInquiry,
                            parameter: .oneToOneInquiryUpdate(id: newInquiry.id, inquiry: newInquiry)
                        )
                        isSubmitted = true
                        title = ""
                        message = ""
                        inquiryStore.removeALL()
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
                    Alert(
                        title: Text("문의 완료"),
                        message: Text("1:1 문의가 성공적으로 전송되었습니다."),
                        dismissButton: .default(Text("확인")){
                            presentationMode.wrappedValue.dismiss()
                        }
                    )
                }
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
        let fetchedSellers = await DataManager.shared.getAllSellers()
        DispatchQueue.main.async {
            sellers = fetchedSellers
            selectedSellerID = sellers.first?.id
            isLoading = false
        }
    }
}

#Preview {
    UserInquiryView()
        .environment(UserStore.shared)
}
