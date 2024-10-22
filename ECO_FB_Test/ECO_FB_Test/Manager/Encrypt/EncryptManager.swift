//
//  EncryptManager.swift
//  ECO_FB_Test
//
//  Created by Jaemin Hong on 10/19/24.
//

import Foundation
import CryptoSwift

final class EncryptManager {
    static let shared: EncryptManager = EncryptManager()
    private var aes: AES? = nil
    private let key: String = Bundle.main.infoDictionary?["EncryptKey"] as! String
    private let iv: String = Bundle.main.infoDictionary?["IVKey"] as! String
    
    private init() {
        do {
            aes = try getAESObject()
        } catch {
            print("Error detected while initializing AES! \(error)")
        }
    }
    
    /**
     암호화 하는 메소드
     
     - parameters:
        - data: 암호화를 할 문자열
     */
    func encrypt(_ data: String) throws -> String {
        guard !data.isEmpty else { return "" }
        guard let aes else {
            throw EncryptError.initializeError(result: "AES Object not initialized")
        }
        
        do {
            let result = try aes.encrypt(data.bytes).toBase64()
            return result
        } catch {
            print("Error detected while encrypting! \(error)")
            throw error
        }
    }
    
    /**
     복호화 하는 메소드
     
     - parameters:
        - encodedData: 복호화를 할 암호화된 문자열
     */
    func decode(_ encodedData: String) throws -> String {
        let data = Data(base64Encoded: encodedData)
        
        guard let data else { return "" }
        guard let aes else {
            throw EncryptError.initializeError(result: "AES Object not initialized")
        }
        
        do {
            let decoded = try aes.decrypt(data.bytes)
            let result = String(bytes: decoded, encoding: .utf8) ?? ""
            
            return result
        } catch {
            print("Error detected while decoding! \(error)")
            throw error
        }
    }
    
    private func getAESObject() throws -> AES {
        do {
            let keyArray: Array<UInt8> = Array(key.utf8)
            let ivArray: Array<UInt8> = Array(iv.utf8)
            let aes = try AES(key: keyArray, blockMode: CBC(iv: ivArray), padding: .pkcs7)
            return aes
        } catch {
            print("Can't get aes object")
            throw error
        }
    }
}
