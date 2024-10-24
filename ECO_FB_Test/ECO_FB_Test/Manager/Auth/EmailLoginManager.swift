//
//  EmailLoginManager.swift
//  ECO_FB_Test
//
//  Created by Jaemin Hong on 10/17/24.
//

import Foundation
import FirebaseAuth

final class EmailLoginManager: LoginControllable {
    static let shared: EmailLoginManager = EmailLoginManager()
    
    private init() {}
    
    func login(parameter: LoginParam) async throws {
        guard case .email(let email, let password) = parameter else {
            throw LoginError.parameterError(reason: "The parameter is not email paramter")
        }
        
        do {
            let userExist = await DataManager.shared.checkIfUserExists(parameter: .userSearch(id: email))
            
            if userExist {
                let loginMethod = await DataManager.shared.getUserLoginMethod(parameter: .userSearch(id: email))
                if loginMethod != LoginMethod.email.rawValue {
                    throw LoginError.emailError(reason: "계정이 \(loginMethod) 로그인으로 연결되어 있습니다.")
                }
            } else {
                throw LoginError.userError(reason: "A user that logged in with email doesn't exist")
            }
            
            _ = try await DataManager.shared.fetchData(type: .user, parameter: .userLoad(id: email, shouldReturnUser: false))
            _ = try await Auth.auth().signIn(withEmail: email, password: password)
        } catch {
            throw error
        }
    }
    
    @MainActor
    func signUpWithEmail(_ email: String, password: String, name: String) async throws {
        do {
            _ = try await Auth.auth().createUser(withEmail: email, password: password)
       
            let user = User(id: email, loginMethod: LoginMethod.email.rawValue, isSeller: false, name: name, profileImageURL: URL(string: "https://firebasestorage.googleapis.com/v0/b/e-co-4f9aa.appspot.com/o/user%2Fdefault_profile.png?alt=media&token=afe3a2fd-d85b-49c8-8d4d-dcf773e928ef")!, pointCount: 0, cart: [], goodsRecentWatched: [], goodsFavorited: [])
            
            _ = try await DataManager.shared.updateData(type: .user, parameter: .userUpdate(id: email, user: user))
        } catch  {
            throw error
        }
    }
    
    @MainActor
    func reauthenticateUser(password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let user = Auth.auth().currentUser, let email = user.email else {
            let error = NSError(domain: "UserError", code: -1, userInfo: [NSLocalizedDescriptionKey: "사용자 정보를 가져올 수 없습니다."])
            completion(.failure(error))
            return
        }
        
        let credential = EmailAuthProvider.credential(withEmail: email, password: password)
        user.reauthenticate(with: credential) { _, error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
}
