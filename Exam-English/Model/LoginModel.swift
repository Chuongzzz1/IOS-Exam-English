//
//  LoginAPI.swift
//  Exam-English
//
//  Created by Trần Văn Chương on 22/04/2024.
//

import Foundation

// MARK: - Access Token
struct LoginData: Codable {
    let username: String
    let password: String
}

struct AccessTokenResponse: Codable {
    let code: Int
    let message: String
    var result: AccessTokenResult?
    init(dictionary: [String: Any]) {
        code = dictionary["code"] as? Int ?? 0
        message = dictionary["message"]  as? String ?? ""
        if let value = dictionary["result"] as? [String: Any] {
            let apiData = AccessTokenResult(dictionary: value)
            result = apiData
        }
    }
}

struct AccessTokenResult: Codable {
    let token: String
    let authenticated: Bool
    init(dictionary: [String: Any]) {
        token = dictionary["token"] as? String ?? ""
        authenticated = dictionary["authenticated"]  as? Bool ?? false
    }
}

// MARK: - Refresh Token
struct RefreshTokenResponse: Codable {
    let code: Int
    let message: String
    var result: RefreshTokenResult?
    init(dictionary: [String: Any]) {
        code = dictionary["code"] as? Int ?? 0
        message = dictionary["message"]  as? String ?? ""
        if let value = dictionary["result"] as? [String: Any] {
            let apiData = RefreshTokenResult(dictionary: value)
            result = apiData
        }
    }
}

struct RefreshTokenResult: Codable {
    let token: String
    let authenticated: Bool
    init(dictionary: [String: Any]) {
        token = dictionary["token"] as? String ?? ""
        authenticated = dictionary["authenticated"]  as? Bool ?? false
    }
}

// MARK: - Validity Access Token
struct TokenValidityResponse: Codable {
    let code: Int
    let message: String
    let result: TokenValidityResult
}

struct TokenValidityResult: Codable {
    let valid: Bool
}

