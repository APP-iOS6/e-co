//
//  AddressSearchManager.swift
//  ECO_FB_Test
//
//  Created by 배문성 on 10/22/24.
//

import SwiftUI

struct AddressSearchManager {
    static func presentAddressSearch(postalCode: Binding<String>, address: Binding<String>) -> some View {
        AddressSearchView(postalCode: postalCode, address: address)
    }
}
