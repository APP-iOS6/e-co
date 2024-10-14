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

    private init() {}
    
    /**
     로그인 메소드
     
     - parameter type: 로그인 제공자, 예) 구글 로그인이라면 .google
    */
    func login(type: LoginType) async {
        do {
            try await loginManagers[type.rawValue].login()
            emailExistErrorMessage = nil
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
            DataManager.shared.setLogout()
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
}
