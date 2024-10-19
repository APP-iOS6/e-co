//
//  GoogleLoginManager.swift
//  ECO_FB_Test
//
//  Created by Jaemin Hong on 10/12/24.
//

import Foundation
import FirebaseCore
import FirebaseAuth
import GoogleSignIn

final class GoogleLoginManager: LoginControllable {
    static let shared: GoogleLoginManager = GoogleLoginManager()
    
    private init() {}
    
    func login(parameter: LoginParam) async throws {
        guard let clientID = FirebaseApp.app()?.options.clientID else { throw LoginError.tokenError(reason: "Client ID missing") }
        
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first,
              let rootViewController = window.rootViewController else {
            
            throw CommonError.windowSceneError(reason: "There is no root view controller")
        }
        
        do {
            let userAuth = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController)
            let googleUser = userAuth.user
            
            guard let idToken = googleUser.idToken else { throw LoginError.tokenError(reason: "ID token missing") }
            
            let accessToken = googleUser.accessToken
            let credential = GoogleAuthProvider.credential(withIDToken: idToken.tokenString, accessToken: accessToken.tokenString)
            
            guard let profile = googleUser.profile else { throw LoginError.userError(reason: "Google user doesn't have profile") }
            
            let id = profile.email
            let userExist = await DataManager.shared.checkIfUserExists(parameter: .userSearch(id: id))
            
            if !userExist {
                let user: User = User(id: id, loginMethod: LoginMethod.google.rawValue, isSeller: false, name: "Google User", profileImageURL: URL(string: "https://firebasestorage.googleapis.com/v0/b/e-co-4f9aa.appspot.com/o/user%2Fdefault_profile.png?alt=media&token=afe3a2fd-d85b-49c8-8d4d-dcf773e928ef")!, pointCount: 0, cart: [], goodsRecentWatched: [])
                // TODO: 최초 로그인 시 이름 받기, 프로필 설정하기(기본 프로필도 하나 정하기)
                await DataManager.shared.updateData(type: .user, parameter: .userUpdate(id: id, user: user)) { _ in
                    
                }
            } else {
                let loginMethod = await DataManager.shared.getUserLoginMethod(parameter: .userSearch(id: id))
                
                if loginMethod != LoginMethod.google.rawValue {
                    throw LoginError.emailError(reason: "계정이 \(loginMethod) 로그인으로 연결되어 있습니다.")
                }
            }
            
            _ = try await Auth.auth().signIn(with: credential)
            _ = await DataManager.shared.fetchData(type: .user, parameter: .userLoad(id: id, shouldReturnUser: false)) { _ in
                
            }
        } catch {
            throw error
        }
    }
}
