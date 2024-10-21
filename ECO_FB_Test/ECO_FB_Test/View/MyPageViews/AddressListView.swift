//
//  AdressFixView.swift
//  ECO_FB_Test
//
//  Created by 배문성 on 10/21/24.
//

import SwiftUI

struct Address: Identifiable {
    let id = UUID()
    var name: String
    var address: String
    var phoneNumber: String
}

struct AddressListView: View {
    @State private var addresses = [
        Address(name: "김민준", address: "경기 용인시 수지구 만현로 79 507-1003", phoneNumber: "010-8950-7687")
    ]
    @State private var isAddingAddress = false

    var body: some View {
        NavigationView {
            VStack {
                List {
                        Button(action: { isAddingAddress.toggle() }) {
                            Text("배송지 추가하기")
                                .frame(maxWidth: .infinity, maxHeight: 3)
                                .padding()
                                .background(Color.white)
                                .foregroundColor(.black)
                                .cornerRadius(5)
                                .overlay(RoundedRectangle(cornerRadius: 5)
                                        .stroke(Color.black, lineWidth: 1)
                                )
                    }
                    ForEach(addresses) { address in
                        VStack(alignment: .leading) {
                            Text(address.name)
                                .font(.headline)
                            Text(address.address)
                                .font(.subheadline)
                            Text(address.phoneNumber)
                                .font(.subheadline)
                        }
                        .padding(.vertical, 5)
                    }
                }
                .padding()
            }
            .navigationTitle("배송지 정보")
            .sheet(isPresented: $isAddingAddress) {
                AddressAddView(addresses: $addresses)
            }
        }
    }
}

struct AddressAddView: View {
    @Binding var addresses: [Address]
    @Environment(\.dismiss) var dismiss
    
    @State private var name = ""
    @State private var address = ""
    @State private var phoneNumber = ""
    @State private var request = "없음"
    
    let requests = ["없음", "문 앞에 놓아주세요", "경비실에 맡겨주세요"]

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("배송지 정보")) {
                    TextField("이름", text: $name)
                    TextField("휴대전화", text: $phoneNumber)
                    TextField("주소", text: $address)

                    Picker("배송 요청사항", selection: $request) {
                        ForEach(requests, id: \.self) { request in
                            Text(request)
                        }
                    }
                }
                
                Button(action: saveAddress) {
                    Text("저장하기")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
            .navigationTitle("배송지 추가")
        }
    }

    private func saveAddress() {
        let newAddress = Address(name: name, address: address, phoneNumber: phoneNumber)
        addresses.append(newAddress)
        dismiss()
    }
}
             
#Preview {
    AddressListView()
}
