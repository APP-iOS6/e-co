//
//  AddressAddView.swift
//  ECO_FB_Test
//
//  Created by 배문성 on 10/22/24.
//

import SwiftUI
import WebKit

struct AddressAddView: View {
    @Binding var addresses: [AddressData]
    @Environment(\.dismiss) var dismiss
    
    @State private var name = ""
    @State private var phoneNumber = "010-"
    @State private var postalCode = ""
    @State private var address = ""
    @State private var detailAddress = ""
    @State private var request: String? = nil //배송요청사항 피커 관련
    @State private var isDefaultAddress = false //배송요청사항 피커 관련
    @State private var showRequestPicker = false //배송요청사항 피커 관련
    @State private var isShowingWebView = false // 우편번호찾기
    
    let requests = ["문 앞에 놓아주세요", "경비실에 맡겨주세요", "도착 전 연락바랍니다", "노크,초인종 하지말아주세요"]

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
                
                Button(action: {
                    showRequestPicker.toggle()
                }) {
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
                            .foregroundColor(isDefaultAddress ? .accent : .gray)
                        }
                        Text("기본 배송지로 설정")
                    }
                    Spacer()
                            
                    Button(action: saveAddress) {
                        Text("저장하기")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.accent)
                            .foregroundColor(.white)
                            .cornerRadius(5)
                }
            }
            .padding()
            .navigationTitle("배송지 추가")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $isShowingWebView) {
                AddressSearchManager.presentAddressSearch(postalCode: $postalCode, address: $address)
                
            }
        }
    }

    private func saveAddress() {
        let newAddress = AddressData(name: name, address: address, phoneNumber: phoneNumber)
        
        if isDefaultAddress {
            print("기본 배송지로 설정되었습니다")
        }
        
        addresses.append(newAddress)
        dismiss()
    }
}



#Preview {
    //임시 데이터를 사용하여 Binding을 제공.
    @Previewable @State var previewAddresses = [AddressData(name: "김민수", address: "서울시 강남구", phoneNumber: "010-1234-5678")]

    AddressAddView(addresses: $previewAddresses)
}
