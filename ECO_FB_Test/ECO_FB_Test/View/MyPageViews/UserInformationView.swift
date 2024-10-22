//
//  UserInformationView.swift
//  ECO_FB_Test
//
//  Created by 이소영 on 10/17/24.
//

import SwiftUI
import NukeUI

struct UserInformationView: View {
    @State private var showLogoutAlert: Bool = false // 로그아웃 알림 표시 여부
    @State private var isShowingAddressList: Bool = false // 배송지 수정화면 표시 여부
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .center, spacing: 10) {
                Image(systemName: "person")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 50, height: 50)
                    .padding()
                    .background(Color(uiColor: .lightGray), in: Circle())
                    .foregroundStyle(.white)
                
                Text("김민수")
                    .font(.title2)
                    .fontWeight(.semibold)
                Spacer()
            }
            .padding(.bottom)
            
            Divider()
            
            HStack {
                Text("회원정보")
                    .font(.system(size: 14))
                    .padding(.vertical, 5)
                    .foregroundStyle(.gray)
                
                Spacer()
                
                Button {
                    
                } label: {
                    HStack {
                        Text("회원정보 수정")
                        Image(systemName: "chevron.right")
                    }
                    .foregroundStyle(.black)
                }
                .bold()
            }
            
            HStack {
                VStack(alignment: .leading, spacing: 15) {
                    Text("이름")
                    Text("연락처")
                    Text("이메일")
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 15) {
                    Text("김민수")
                    Text("010-00**-00**")
                    Text("minsu@zzang.com")
                }
            }
            .font(.system(size: 17))
            .foregroundStyle(Color(uiColor: .darkGray))
            .padding(.vertical)
            
            Divider()
            
            HStack {
                Text("배송지정보")
                    .font(.system(size: 14))
                    .padding(.vertical, 5)
                    .foregroundStyle(Color(uiColor: .darkGray))
                
                Spacer()
                
                Button {
                    isShowingAddressList = true
                } label: {
                    HStack {
                        Text("배송지 수정")
                        Image(systemName: "chevron.right")
                    }
                    .foregroundStyle(.black)
                }
                .bold()
            }
            
            HStack {
                VStack(alignment: .leading, spacing: 15) {
                    Text("수령인")
                    Text("주소")
                    Text("연락처")
                }
                .font(.system(size: 17))
                .foregroundStyle(Color(uiColor: .darkGray))
                .padding(.vertical)
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 15) {
                    Text("김민수")
                    Text("서울시 강남구 역삼동 12-1")
                    Text("010-00**-00**")
                }
            }
            Spacer()
            
            HStack {
                Spacer()
                Button {
                    showLogoutAlert = true
                } label: {
                    Text("로그아웃")
                        .foregroundColor(.red)
                }
                .alert("로그아웃", isPresented: $showLogoutAlert, actions: {
                    Button("로그아웃", role: .destructive) {
                        AuthManager.shared.logout()
                        dismiss()
                    }
                    
                    Button("취소", role: .cancel) { }
                }, message: {
                    Text("로그아웃 하시겠습니까?")
                })
                Spacer()
            }
        }
        .padding()
        .sheet(isPresented: $isShowingAddressList) {
            AddressListView()
        }
    }
}

#Preview {
    UserInformationView()
}
 
