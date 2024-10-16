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
        KaKaoLoginManager.shared
    ]
    private var cancellable: AnyCancellable? = nil
    private(set) var signUpErrorMessage: String? = nil
    private(set) var emailExistErrorMessage: String? = nil
    private(set) var tryToLoginNow: Bool = false

    var isUserLoggedIn: Bool {
        Auth.auth().currentUser != nil
    }

    private init() {}
    
    /**
     로그인 메소드
     
     - parameter type: 로그인 제공자, 예) 구글 로그인이라면 .google
    */
    func login(type: LoginType) async {
        do {
            tryToLoginNow = true
            
            try await loginManagers[type.rawValue].login()
            emailExistErrorMessage = nil
            
            tryToLoginNow = false
        } catch {
            if (error as NSError).code == GIDSignInError.canceled.rawValue {
                tryToLoginNow = false
            }
            
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
        
        UserApi.shared.logout { error in
            if let error {
                print("\(error)")
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
    
    func signUp(withEmail email: String, password: String, name: String) async throws {
        do {
            tryToLoginNow = true
            
            _ = try await Auth.auth().createUser(withEmail: email, password: password)
       
            // 초기값 추가 id = email, loginmethod > email로 설정 포인트 프로필등 초기값
            let user = User(id: email, loginMethod: LoginMethod.email.rawValue, isAdmin: false, name: name, profileImageName: "Test.png", pointCount: 0, cart: [], goodsRecentWatched: [])
            await DataManager.shared.updateData(type: .user, parameter: .userUpdate(id: email, user: user))
            
            tryToLoginNow = false
        } catch let error as NSError {
            // Firebase Auth의 오류 처리
            switch AuthErrorCode(rawValue: error.code) {
            case .emailAlreadyInUse:
                let errorMessage = "해당 이메일은 이미 사용 중입니다."
                print("회원가입 오류: \(errorMessage)")
                throw LoginError.emailError(reason: errorMessage)
                
            default:
                print("회원가입 오류: \(error.localizedDescription)") // 기타 오류 메시지 출력
                throw error // 기본 오류 throw
            }
        }
    }
    /**
     이메일로그인 메소드
    */
    func EmailLogin(withEmail email: String, password: String) async throws {
        do {
           
            let authResult = try await Auth.auth().signIn(withEmail: email, password: password)
            emailExistErrorMessage = nil
            
            // 로그인된 사용자 정보 가져오기
            let currentUser = authResult.user
            
            // 사용자의 id로 데이터 확인
            let userExist = await DataManager.shared.checkIfUserExists(parameter: .userSearch(id: email))
            
            if userExist {
                // 사용자가 이미 존재하는 경우// 이메일 로그인은 이미 사인업에서 데이터를 박아넣기때문에 존재할것이라고 예상
                let loginMethod = await DataManager.shared.getUserLoginMethod(parameter: .userSearch(id: email))
                if loginMethod != LoginMethod.email.rawValue {
                    throw LoginError.emailError(reason: "계정이 \(loginMethod) 로그인으로 연결되어 있습니다.")
                }
            } else {
                // 혹시몰라 추가
                let user: User = User(id: email, loginMethod: LoginMethod.email.rawValue, isAdmin: false, name: currentUser.displayName ?? "이름 없음", profileImageName: "Test.png", pointCount: 0, cart: [], goodsRecentWatched: [])
                await DataManager.shared.updateData(type: .user, parameter: .userUpdate(id: email, user: user))
            }
            
            // 데이터 갱신
            _ = await DataManager.shared.fetchData(type: .user, parameter: .userLoad(id: email, shouldReturnUser: false)) { _ in
                
            }
        } catch {
            // 오류 출력문들 처리 ui에 처리 어떻게 해야할지 생각필요 
            print("로그인 오류 발생: \(error.localizedDescription)")
            if let loginError = error as? LoginError {
                switch loginError {
                case .emailError(let reason):
                    print("이메일 오류: \(reason)")
                case .tokenError(let reason):
                    print("토큰 오류: \(reason)")
                case .userError(let reason):
                    print("사용자 오류: \(reason)")
                }
            }
            throw error 
        }
    }
}
