//
//  CartView.swift
//  ECO_FB_Test
//
//  Created by Jaemin Hong on 10/14/24.
// 

import SwiftUI

//struct CartView: View {
//    @EnvironmentObject private var userStore: UserStore
//    
//    @State private var cartDummy: [Goods] = [
//        Seller(id: "Q6awSoN6OCHcbUDeMxyd", name: "Seller", profileImageName: "It will be replace to id matches seller")
//    ]
//    
//    var body: some View {
//        if let user = userStore.userData {
//            ScrollView {
//                LazyVStack(spacing: 10) {
//                    ForEach(user.arrayCart) { goods in
//                        GroupBox {
//                            Text("썸네일: \(goods.thumbnailImageName)")
//                            Text("상품이름: \(goods.name)")
//                            Text("가격: \(goods.formattedPrice)")
//                            Text("판매자: \(goods.seller.name)")
//                            Text("카테고리: \(goods.category)")
//                            Text("본문: \(goods.bodyContent)")
//                            Text("본문사진: \(goods.bodyImageNames)")
//                        }
//                    }
//                }
//            }
//        }
//    }
//}
//
//#Preview {
//    CartView()
//        .environmentObject(UserStore.shared)
//}
