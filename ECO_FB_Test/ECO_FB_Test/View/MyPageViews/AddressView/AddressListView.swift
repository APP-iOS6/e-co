//
//  AdressListView.swift
//  ECO_FB_Test
//
//  Created by 배문성 on 10/21/24.
//
import SwiftUI

struct AddressData: Identifiable {
    let id = UUID()
    var name: String
    var address: String
    var phoneNumber: String
}

struct AddressListView: View {
    @State private var addresses = [
        AddressData(name: "김길동", address: "서울시 중구 이순신로 1길 1", phoneNumber: "010-1234-1234")
    ]
    @State private var selectedAddress: UUID?
    @State private var addressToFix: AddressData?
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Text("배송지 정보")
                        .font(.headline)
                    Spacer()
                    Button(action: { presentationMode.wrappedValue.dismiss() }) {
                        Image(systemName: "xmark")
                            .foregroundColor(.black)
                    }
                }
                .padding()

                ScrollView {
                    VStack(spacing: 10) {
                        NavigationLink(destination: AddressAddView(addresses: $addresses)) {
                            Text("배송지 추가하기")
                                .frame(maxWidth: .infinity, maxHeight: 5)
                                .padding()
                                .background(Color.white)
                                .foregroundColor(.black)
                                .cornerRadius(5)
                                .overlay(RoundedRectangle(cornerRadius: 5)
                                    .stroke(Color.black, lineWidth: 0.2)
                                )
                        }
                        .padding(.horizontal, 16)

                        ForEach(addresses) { address in
                            HStack(alignment: .top) {
                                Image(systemName: selectedAddress == address.id ? "checkmark.circle.fill" : "circle")
                                    .foregroundColor(selectedAddress == address.id ? .green : .gray)
                                    .onTapGesture {
                                        selectedAddress = address.id
                                    }

                                VStack(alignment: .leading) {
                                    Text(address.name)
                                        .font(.headline)
                                    Text(address.address)
                                        .font(.subheadline)
                                    Text(address.phoneNumber)
                                        .font(.subheadline)

                                    NavigationLink(destination: AddressFixView(addresses: $addresses, addressToFix: address)) {
                                        Text("수정")
                                            .font(.caption)
                                            .foregroundColor(.black)
                                            .padding(5)
                                            .background(Color.white.opacity(0.2))
                                            .cornerRadius(5)
                                            .overlay(RoundedRectangle(cornerRadius: 5)
                                                .stroke(Color.black, lineWidth: 0.1))
                                    }
                                }
                            }
                            .frame(maxWidth : .infinity, alignment: .leading)
                            .padding(.vertical, 5)
                            .padding(.horizontal, 10)
                            .background(RoundedRectangle(cornerRadius: 8).stroke(Color.white, lineWidth: 1))
                        }
                    }
                    .padding(.horizontal, 16)
                }

                Button(action: changeAddress) {
                    Text("변경하기")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding()
            }
        }
    }

    private func changeAddress() {
        if let selectedId = selectedAddress,
           let index = addresses.firstIndex(where: { $0.id == selectedId }) {
            let selectedAddress = addresses[index]
            print("Changed address to: \(selectedAddress.name), \(selectedAddress.address)")
            presentationMode.wrappedValue.dismiss()
        }
    }
}

#Preview {
    AddressListView()
}
