//
//  UserModel.swift
//  Exam-English
//
//  Created by Trần Văn Chương on 26/06/2024.
//

import Foundation

struct UserResponse {
    let code: Int
    let message: String
    var result: User?
    init(dictionary: [String: Any]) {
        self.code = dictionary["code"] as? Int ?? 0
        self.message = dictionary["message"] as? String ?? ""
        
        if let userDict = dictionary["result"] as? [String: Any] {
            self.result = User(dictionary: userDict)
        } else {
            self.result = nil
        }
    }
}

struct User {
    let userName: String
    let firstName: String
    let lastName: String
    let middleName: String
    let localMail: String?
    let admin: Bool
    init(dictionary: [String: Any]) {
        self.userName = dictionary["username"] as? String ?? ""
        self.firstName = dictionary["firstName"] as? String ?? ""
        self.lastName = dictionary["lastName"] as? String ?? ""
        self.middleName = dictionary["middleName"] as? String ?? ""
        self.localMail = dictionary["localMail"] as? String ?? ""
        self.admin = dictionary["admin"] as? Bool ?? false

    }
}

