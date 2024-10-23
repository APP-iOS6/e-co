//
//  ProductSubmitView.swift
//  ECO_FB_Test
//
//  Created by Hwang_Inyoung on 10/21/24.
//


import SwiftUI

struct ProductSubmitView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var isUploaded: Bool
    
    var goodsCategories = GoodsCategory.allCases.filter{ $0.rawValue != "none" }.sorted { a, b in
        a.rawValue > b.rawValue
    }
    @State var selectedCategory: GoodsCategory? = nil
    @State var goodsName: String = ""
    @State var goodsContent: String = ""
    @State var goodsPrice: String = ""
    @State var goodsImage: Image? = nil
    @State var selectedUIImage: UIImage? = nil
    @State var showImagePicker: Bool = false
    @State var inputText: String = ""
    
    private var isEmptyAnyFields: Bool {    //
        selectedCategory == nil || goodsName.isEmpty || goodsContent.isEmpty || goodsPrice.isEmpty || goodsImage == nil
    }
    
    var body: some View {
        AppNameView()
        ScrollView(.vertical){
            VStack(alignment: .leading){
                Text("카테고리 선택")
                    .bold()
                ScrollView(.horizontal) {   // storeView의 스크롤뷰를 재활용 했습니다.
                    HStack {
                        ForEach(goodsCategories, id: \.self) { category in
                            Button {
                                selectedCategory = category
                            } label: {
                                Text(category.rawValue)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(selectedCategory == category ? .black : Color(uiColor: .darkGray))
                            }
                            .buttonStyle(.bordered)
                        }
                    }
                }
                .scrollIndicators(.hidden)
                .padding(.bottom)
                
                VStack(alignment: .leading){
                    Text("상품이름")
                        .bold()
                    TextField("등록하려는 상품 이름을 입력해주세요.", text: $goodsName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.bottom)
                    Text("상품가격")
                        .bold()
                    HStack{
                        TextField("등록하려는 상품 가격을 입력해주세요.", text: $goodsPrice)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.numberPad)
                            .onChange(of: goodsPrice) { oldValue, newValue in
                                let filtered = newValue.filter(\.isNumber)
                                if filtered != newValue {
                                    goodsPrice = filtered
                                }
                            }
                        Text("원")
                            .bold()
                    }
                    .padding(.bottom)
                    Text("상품설명")
                        .bold()
                    TextEditor(text: $goodsContent)
                        .frame(height: 150)
                        .overlay {
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color(UIColor.systemGray6), lineWidth: 2)
                        }
                }
                
                Text("상품사진")
                    .bold()
                    .padding(.top)
                if let image = goodsImage {
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: .infinity)
                } else {
                    Button {
                        showImagePicker.toggle()
                    } label: {
                        ZStack {
                            Rectangle()
                                .fill(Color(UIColor.placeholderText))
                                .frame(height: 200)
                                .padding(.bottom)
                            Image(systemName: "plus.circle")
                                .foregroundStyle(.gray)
                        }
                    }
                    .sheet(isPresented: $showImagePicker, onDismiss: { loadImage() }) {
                        ImagePicker(image: $selectedUIImage)
                    }
                }
                
                Button {
                    print("상품 등록 하기")
                    // TODO: 서버에 판매자 상품을 등록하는 로직
                    Task {
                        let id = UUID().uuidString
                        let uploadResult = try await StorageManager.shared.upload(type: .goods, parameter: .uploadGoodsThumbnail(goodsID: id, image: selectedUIImage!))
                        
                        if case let .single(url) = uploadResult, let user = UserStore.shared.userData {
                            let goods = Goods(id: UUID().uuidString,
                                              name: goodsName,
                                              category: selectedCategory!,
                                              thumbnailImageURL: url,
                                              bodyContent: goodsContent,
                                              bodyImageNames: [],
                                              price: Int(goodsPrice)!,
                                              seller: user)
                            
                            _ = try await DataManager.shared.updateData(type: .goods, parameter: .goodsUpdate(id: id, goods: goods))
                        }
                    }
                    print("등록 완료")
                    isUploaded.toggle()
                    dismiss()
                } label: {
                    Text("등록 하기")
                        .foregroundStyle(.white)
                        .font(.title)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background {
                            Capsule(style: .continuous)
                                .fill(isEmptyAnyFields ? Color(UIColor.placeholderText) : .accent)
                                .frame(maxWidth: .infinity)
                        }
                }
                .disabled(isEmptyAnyFields)
            }
            .padding()
        }
        .scrollIndicators(.hidden)
        .navigationTitle("물품 등록")
    }
    
    private func loadImage() {
        guard let selectedImage = selectedUIImage else { return }
        goodsImage = Image(uiImage: selectedImage)
    }
}

//MARK: 이미지 피커
struct ImagePicker: UIViewControllerRepresentable {
    
    @Binding var image: UIImage?
    @Environment(\.presentationMode) var mode
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
}

extension ImagePicker {
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            guard let image = info[.originalImage] as? UIImage else { return }
            parent.image = image
            parent.mode.wrappedValue.dismiss()
        }
    }
}
