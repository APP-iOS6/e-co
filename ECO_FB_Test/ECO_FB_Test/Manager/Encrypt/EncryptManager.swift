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
    private let key: String = "2b8v524k81fn9ahtg9x0q136dw377yzr"
    private let iv: String = "grq53nxxns5u8kdr"
    
    private init() {}
    
    func encrypt(_ data: String) throws -> String {
        guard !data.isEmpty else { return "" }
        
        do {
            let result = try getAESObject().encrypt(data.bytes).toBase64()
            return result
        } catch {
            print("Error detected while encrypting! \(error)")
            throw error
        }
    }
    
    func decode(_ encodedData: String) throws -> String {
        let data = Data(base64Encoded: encodedData)
        
        guard let data else { return "" }
        
        do {
            let decoded = try getAESObject().decrypt(data.bytes)
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
