//
//  KaKaoLoginManager.swift
//  ECO_FB_Test
//
//  Created by Jaemin Hong on 10/11/24.
//

import Foundation
import FirebaseAuth
import KakaoSDKAuth
import KakaoSDKUser

final class KaKaoLoginManager: LoginControllable {
    static let shared: KaKaoLoginManager = KaKaoLoginManager()
    
    private init() {}
    
    func login() async throws {
        if UserApi.isKakaoTalkLoginAvailable() { // 카카오톡 앱 실행 가능 여부 확인
            do {
                // 실제 카카오 SDK는 동기로 작동해서 직접 비동기로 변환한 함수 사용
                var oauthToken = try await loginWithKakaoTalkAsync()
                // 이메일 권한이 필요한지 검사(최초 로그인이라면 동의하지 않았으므로 필요함)
                let needEmailPermission = try await checkIfNeedEmailPermission()
                
                if needEmailPermission {
                    // oauthToken을 이메일 권한 포함해서 새로 받아옴
                    oauthToken = try await loginWithEmailPermissionAsync()
                }
                
                // 이후 과정은 구글 로그인과 비슷함
                guard let idToken = oauthToken.idToken else { throw LoginError.tokenError(reason: "ID token missing") }
                
                let accessToken = oauthToken.accessToken
                let credential = OAuthProvider.credential(providerID: .custom("oidc.kakao"), idToken: idToken, accessToken: accessToken)
                
                let id = try await getUserEmail()
                let userExist = await DataManager.shared.checkIfUserExists(parameter: .userSearch(id: id))
                
                if !userExist {
                    let user: User = User(id: id, loginMethod: LoginMethod.kakao.rawValue, isAdmin: false, name: "KaKao User", profileImageName: "Test.png", pointCount: 0, cart: [], goodsRecentWatched: [])
                    
                    await DataManager.shared.updateData(type: .user, parameter: .userUpdate(id: id, user: user))
                } else {
                    let loginMethod = await DataManager.shared.getUserLoginMethod(parameter: .userSearch(id: id))
                    
                    if loginMethod != LoginMethod.kakao.rawValue {
                        throw LoginError.emailError(reason: "계정이 \(loginMethod) 로그인으로 연결되어 있습니다.")
                    }
                }
                
                _ = try await Auth.auth().signIn(with: credential)
                _ = await DataManager.shared.fetchData(type: .user, parameter: .userLoad(id: id, shouldReturnUser: false))
            } catch {
                throw error
            }
        }
    }
    
    private func loginWithKakaoTalkAsync() async throws -> OAuthToken {
        // 비동기 코드가 아닌 것을 비동기로 실행할 수 있도록 하는 함수, 오류 반환 가능
        try await withCheckedThrowingContinuation { continuation in
            UserApi.shared.loginWithKakaoTalk { oauthToken, error in
                if let error {
                    continuation.resume(throwing: error)
                }
                
                if let oauthToken {
                    continuation.resume(returning: oauthToken)
                }
            }
        }
    }
    
    private func checkIfNeedEmailPermission() async throws -> Bool {
        try await withCheckedThrowingContinuation { continuation in
            UserApi.shared.me { user, error in
                if let error {
                    continuation.resume(throwing: error)
                }
                
                if let user, let emailNeedsAgreement = user.kakaoAccount?.emailNeedsAgreement {
                    continuation.resume(returning: emailNeedsAgreement)
                }
            }
        }
    }
    
    private func loginWithEmailPermissionAsync() async throws -> OAuthToken {
        try await withCheckedThrowingContinuation { continuation in
            let scopes: [String] = ["openid", "account_email"]
            
            UserApi.shared.loginWithKakaoAccount(scopes: scopes) { oauthToken, error in
                if let error {
                    continuation.resume(throwing: error)
                }
                
                if let oauthToken {
                    continuation.resume(returning: oauthToken)
                }
            }
        }
    }
    
    private func getUserEmail() async throws -> String {
        try await withCheckedThrowingContinuation { continuation in
            UserApi.shared.me { user, error in
                if let error {
                    continuation.resume(throwing: error)
                }
                
                if let user, let email = user.kakaoAccount?.email {
                    continuation.resume(returning: email)
                }
            }
        }
    }
}
