//
//  KeychainHandler.swift
//  YeonBa
//
//  Created by 김민솔 on 5/3/24.
//

import Foundation
import SwiftKeychainWrapper

struct KeychainHandler {
    static var shared = KeychainHandler()
    
    private let keychain = KeychainWrapper(serviceName: "YeonBa", accessGroup: "YeonBa.iOS")
    private let accessTokenKey: KeychainWrapper.Key = "accessToken"
    private let refreshTokenKey: KeychainWrapper.Key = "refreshToken"
    private let kakaoUserIDKey: KeychainWrapper.Key = "kakaoUserID"
    private let providerTokenKey: KeychainWrapper.Key = "providerToken"
    
    var accessToken: String {
        get {
            return KeychainWrapper.standard.string(forKey: accessTokenKey) ?? ""
        }
        set {
            KeychainWrapper.standard.set(newValue, forKey: accessTokenKey.rawValue)
        }
    }
    
    var refreshToken: String {
        get {
            return KeychainWrapper.standard.string(forKey: refreshTokenKey) ?? ""
        }
        set {
            KeychainWrapper.standard.set(newValue, forKey: refreshTokenKey.rawValue)
        }
    }
    
    var kakaoUserID: String {
        get {
            return KeychainWrapper.standard.string(forKey: kakaoUserIDKey) ?? ""
        }
        set {
            KeychainWrapper.standard.set(newValue, forKey: kakaoUserIDKey.rawValue)
        }
    }
    
    var providerToken: String {
        get {
            return KeychainWrapper.standard.string(forKey: providerTokenKey) ?? ""
        }
        set {
            KeychainWrapper.standard.set(newValue, forKey: providerTokenKey.rawValue)
        }
    }
    
    func clearTokens() {
        KeychainWrapper.standard.remove(forKey: accessTokenKey)
        KeychainWrapper.standard.remove(forKey: refreshTokenKey)
        KeychainWrapper.standard.remove(forKey: kakaoUserIDKey)
        KeychainWrapper.standard.remove(forKey: providerTokenKey)
    }
}

