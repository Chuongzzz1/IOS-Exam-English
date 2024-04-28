//
//  LoginAPI.swift
//  Exam-English
//
//  Created by Trần Văn Chương on 22/04/2024.
//

import Foundation
//struct loginRequest {
//    var login: String
//    var password: String
//}

struct LoginResponse: Codable {
    let success: Int
    let message: String
}
