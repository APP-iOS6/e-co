//
//  AddressFixView.swift
//  ECO_FB_Test
//
//  Created by 배문성 on 10/22/24.
//
import SwiftUI
import WebKit

struct AddressFixView: View {
    @Binding var addresses: [AddressData]
    @State var addressToFix: AddressData
    @Environment(\.presentationMode) var presentationMode
    
    @State private var name: String
    @State private var phoneNumber: String
    @State private var postalCode: String
    @State private var address: String
    @State private var detailAddress: String
    @State private var request: String?
    @State private var isDefaultAddress: Bool
    @State private var showRequestPicker = false
    @State private var isShowingWebView = false
    
    let requests = ["문 앞에 놓아주세요", "경비실에 맡겨주세요", "도착 전 연락바랍니다", "노크,초인종 하지말아주세요"]

    init(addresses: Binding<[AddressData]>, addressToFix: AddressData) {
        self._addresses = addresses
        self._addressToFix = State(initialValue: addressToFix)
        _name = State(initialValue: addressToFix.name)
        _phoneNumber = State(initialValue: addressToFix.phoneNumber)
        _address = State(initialValue: addressToFix.address)
        _postalCode = State(initialValue: "")
        _detailAddress = State(initialValue: "")
        _isDefaultAddress = State(initialValue: false)
    }

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {
                Text("이름")
                TextField("받는 분의 이름을 입력해주세요", text: $name)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Text("휴대전화번호")
                TextField("010-", text: $phoneNumber)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Text("주소")
                HStack {
                    TextField("우편번호", text: $postalCode)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Button(action: { isShowingWebView = true }) {
                        Text("주소 찾기")
                            .frame(height: 5)
                            .foregroundColor(.gray)
                            .padding()
                            .background(Color.white.opacity(0.1))
                            .cornerRadius(5)
                            .overlay(RoundedRectangle(cornerRadius: 5)
                                .stroke(Color.gray, lineWidth: 0.1))
                    }
                }
                
                TextField("주소", text: $address)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                TextField("상세주소", text: $detailAddress)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Text("배송 요청사항 (선택)")
                
                Button(action: { showRequestPicker = true }) {
                    HStack {
                        Text(request ?? "배송 요청사항을 선택해주세요")
                            .foregroundColor(.gray)
                        Spacer()
                        Image(systemName: "chevron.down")
                            .foregroundColor(.gray)
                    }
                    .padding()
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(5)
                    .overlay(RoundedRectangle(cornerRadius: 5)
                        .stroke(style: StrokeStyle(lineWidth: 0.1)))
                }
                .actionSheet(isPresented: $showRequestPicker) {
                    ActionSheet(title: Text("배송 요청사항 선택"),
                                buttons: requests.map { request in
                            .default(Text(request)) {
                                self.request = request
                            } } + [.cancel()])
                }
                
                HStack {
                    Button(action: { isDefaultAddress.toggle() }) {
                        Image(systemName: isDefaultAddress ? "checkmark.square" : "square")
                            .foregroundColor(isDefaultAddress ? .accentColor : .gray)
                    }
                    Text("기본 배송지로 설정")
                }
                
                Spacer()
                
                Button(action: updateAddress) {
                    Text("수정하기")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.accentColor)
                        .foregroundColor(.white)
                        .cornerRadius(5)
                }
            }
            .padding()
            .navigationTitle("배송지 수정")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $isShowingWebView) {
                AddressSearchManager.presentAddressSearch(postalCode: $postalCode, address: $address)
            }
        }
    }

    private func updateAddress() {
        if let index = addresses.firstIndex(where: { $0.id == addressToFix.id }) {
            addresses[index].name = name
            addresses[index].address = address
            addresses[index].phoneNumber = phoneNumber
        }
        
        if isDefaultAddress {
            print("기본 배송지로 설정되었습니다")
        }
        
        presentationMode.wrappedValue.dismiss()
    }
}


#Preview {
    //임시 데이터를 사용하여 Binding을 제공.
    @Previewable @State var previewAddresses = [AddressData(name: "김민수", address: "서울시 강남구", phoneNumber: "010-1234-5678")]

    AddressFixView(addresses: $previewAddresses, addressToFix: previewAddresses[0])
}
