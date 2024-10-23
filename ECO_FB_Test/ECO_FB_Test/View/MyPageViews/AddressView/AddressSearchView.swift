//
//  AddressSearchView.swift
//  ECO_FB_Test
//
//  Created by 배문성 on 10/22/24.
//

import SwiftUI
import WebKit

struct AddressSearchView: View {
    @State private var documents: [Document] = []
    @State private var input: String = ""
    
    var body: some View {
        VStack {
            TextField("주소를 입력해 주세요.", text: $input)
                .textInputAutocapitalization(.never)
                .padding(10)
                .background {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.gray, lineWidth: 1)
                }
                .padding(.top, 8)
                .padding(.horizontal)
            
            List(documents) { document in
                VStack(alignment: .leading) {
                    Text(document.addressName)
                        .font(.headline)
                        .bold()
                    Text("\(document.roadAddress.region1DepthName) \(document.roadAddress.region2DepthName) \(document.roadAddress.region3DepthName)")
                        .font(.subheadline)
                }
            }
            .listStyle(.plain)
        }
        .onChange(of: input) {
            Task {
                let result = try await SearchedAddressStore.shared.getAddresses(query: input)
                documents = result.documents
            }
        }
        .onAppear {
            UITextField.appearance().clearButtonMode = .whileEditing
        }
    }
}
