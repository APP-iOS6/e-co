//
//  AuthManager.swift
//  ECO_FB_Test
//
//  Created by Jaemin Hong on 10/12/24.
// 

import Foundation
import FirebaseAuth

@MainActor
@Observable
final class AuthManager {
    static let shared: AuthManager = AuthManager()
    @ObservationIgnored private lazy var loginManagers: [LoginControllable] = [
        GoogleLoginManager.shared,
        KaKaoLoginManager.shared
    ]
    private(set) var isLoggedIn: Bool = false
    private(set) var signUpErrorMessage: String? = nil
    private(set) var emailExistErrorMessage: String? = nil


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
    
    func signUp(withEmail email: String, password: String, name: String) async throws {
        do {
            
            _ = try await Auth.auth().createUser(withEmail: email, password: password)
       
            // 초기값 추가 id = email, loginmethod > email로 설정 포인트 프로필등 초기값
            let user = User(id: email, loginMethod: LoginMethod.email.rawValue, isAdmin: false, name: name, profileImageName: "Test.png", pointCount: 0, cart: [])
            await DataManager.shared.updateData(type: .user, parameter: .userUpdate(id: email, user: user))
            
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
                let user: User = User(id: email, loginMethod: LoginMethod.email.rawValue, isAdmin: false, name: currentUser.displayName ?? "이름 없음", profileImageName: "Test.png", pointCount: 0, cart: [])
                await DataManager.shared.updateData(type: .user, parameter: .userUpdate(id: email, user: user))
            }
            
            // 데이터 갱신
            _ = await DataManager.shared.fetchData(type: .user, parameter: .userLoad(id: email, shouldReturnUser: false))
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
    /**
     게스트 로그인 메소드
    */
    func guestLogin() async throws {
            // 게스트로그인
            // 게스트 임시 프로필 생성
            let guestEmail = "guest_\(UUID().uuidString)@example.com"
            let guestUser = User(
                id: guestEmail,
                loginMethod: LoginMethod.guest.rawValue,
                isAdmin: false,
                name: "게스트 사용자",
                profileImageName: "Guest.png",
                pointCount: 0,
                cart: []
            )
            
            // Firebase에 사용자 데이터 저장 및 로드
            await DataManager.shared.updateData(type: .user, parameter: .userUpdate(id: guestEmail, user: guestUser))
        
        _ = await DataManager.shared.fetchData(type: .user, parameter: .userLoad(id: guestEmail, shouldReturnUser: false))
            
            isLoggedIn = true
            print("비회원 로그인 성공: \(guestEmail)")
        }
}
