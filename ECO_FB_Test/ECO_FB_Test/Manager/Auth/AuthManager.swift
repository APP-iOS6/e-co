//
//  AuthManager.swift
//  ECO_FB_Test
//
//  Created by Jaemin Hong on 10/12/24.
// 

import Foundation
import FirebaseAuth

@MainActor
final class AuthManager: ObservableObject {
    static let shared: AuthManager = AuthManager()
    private lazy var loginManagers: [LoginControllable] = [
        GoogleLoginManager.shared,
        KaKaoLoginManager.shared
    ]
    
    @Published private(set) var emailExistErrorMessage: String? = nil
    @Published var loggedInUserName: String? = nil  // 로그인한 사용자 이름 저장

    private init() {}
    
    /**
     로그인 메소드
     
     - parameter type: 로그인 제공자, 예) 구글 로그인이라면 .google
    */
    func login(type: LoginType) async {
        do {
            try await loginManagers[type.rawValue].login()
            emailExistErrorMessage = nil
            
            // 로그인 후 Firebase에서 현재 로그인한 사용자 정보 가져오기
            if let currentUser = Auth.auth().currentUser {
                loggedInUserName = currentUser.displayName ?? currentUser.email // 이름이 없으면 이메일 사용
            }
        } catch {
            if let loginError = error as? LoginError, case let .emailError(reason) = loginError {
                emailExistErrorMessage = reason
            } else {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    /**
     로그아웃 메소드
    */
    func logout() {
        do {
            try Auth.auth().signOut()
            loggedInUserName = nil // 로그아웃 시 사용자 이름 초기화
            DataManager.shared.setLogout()
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
}
