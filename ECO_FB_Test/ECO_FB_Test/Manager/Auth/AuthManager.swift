//
//  AuthManager.swift
//  ECO_FB_Test
//
//  Created by Jaemin Hong on 10/12/24.
// 

import Foundation
import Combine
import FirebaseAuth
import GoogleSignIn
import KakaoSDKUser

@MainActor
@Observable
final class AuthManager {
    static let shared: AuthManager = AuthManager()
    @ObservationIgnored private lazy var loginManagers: [LoginControllable] = [
        GoogleLoginManager.shared,
        KaKaoLoginManager.shared,
        EmailLoginManager.shared
    ]
    private var cancellable: AnyCancellable? = nil
    private var currLoginType: LoginType = .none
    private(set) var signUpErrorMessage: String? = nil
    private(set) var emailExistErrorMessage: String? = nil
    private(set) var tryToLoginNow: Bool = false

    var isUserLoggedIn: Bool {
        Auth.auth().currentUser != nil
    }

    private init() {}
    
    /**
     회원가입 메소드
     
     - parameters:
        - email: 회원가입 시 사용 할 이메일
        - password: 회원가입 시 사용 할 비밀번호
        - name: 회원가입 시 사용 할 유저의 이름
    */
    func signUp(email: String, password: String, name: String) async throws {
        do {
            try await EmailLoginManager.shared.signUpWithEmail(email, password: password, name: name)
        } catch {
            print("Error: \(error)")
            throw error
        }
    }
    
    /**
     로그인 메소드
     
     - parameters:
        - type: 로그인 제공자, 예) 구글 로그인이라면 .google
        - parameter: 로그인 시 필요한 인자, 이메일 로그인의 경우 필요합니다
    */
    func login(type: LoginType, parameter: LoginParam = .none) async throws {
        do {
            tryToLoginNow = true
            
            try await loginManagers[type.rawValue].login(parameter: parameter)
            emailExistErrorMessage = nil
            
            tryToLoginNow = false
            currLoginType = type
        } catch {
            if (error as NSError).code == GIDSignInError.canceled.rawValue {
                tryToLoginNow = false
            }
            
            if let loginError = error as? LoginError, case let .emailError(reason) = loginError {
                emailExistErrorMessage = reason
            } else {
                print("Error: \(error.localizedDescription)")
            }
            
            throw error
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
        
        if currLoginType == .kakao {
            UserApi.shared.logout { error in
                if let error {
                    print("\(error)")
                }
            }
        }
    }
    
    /**
     로그인 되어있을 시 유저 정보를 가져오는 메소드
     */
    func getLoggedInUserData() async {
        do {
            tryToLoginNow = true
            
            let id = try getUserID()
            _ = await DataManager.shared.fetchData(type: .user, parameter: .userLoad(id: id, shouldReturnUser: false)) { _ in
           
            }
            let method = LoginMethod(rawValue: await DataManager.shared.getUserLoginMethod(parameter: .userSearch(id: id)))!
            
            currLoginType = if method == .kakao {
                .kakao
            } else if method == .google {
                .google
            } else {
                .email
            }
            
            cancellable = Just(false)
                .delay(for: .seconds(8), scheduler: RunLoop.main)
                .sink { [weak self] value in
                    self?.tryToLoginNow = value
                    self?.cancellable = nil
                }
        } catch {
            print("Error: \(error)")
        }
    }
    
    /**
     유저의 아이디(현재는 이메일)을 가져오는 메소드
     */
    func getUserID() throws -> String {
        guard let user = Auth.auth().currentUser else { throw LoginError.userError(reason: "You Don't Login!") }
        guard let email = user.email else { throw LoginError.emailError(reason: "User doesn't have a email")}
        
        return email
    }
    
    /**
     현재 유저의 계정을 삭제하는 메소드
     */
    func deleteUser() throws {
        guard let user = Auth.auth().currentUser else { throw LoginError.userError(reason: "You Don't Login!") }
        user.delete { error in  // authentication에서 유저 삭제
            if error != nil {
                print("회원삭제 에러발생")
            } else {
                print("회원삭제 성공")
            }
        }
    }
}
