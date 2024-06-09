//
//  HomeModel.swift
//  Exam-English
//
//  Created by Trần Văn Chương on 08/06/2024.
//

import Foundation
struct ScoreResponse {
    let code: Int
    let message: String
    var result: [Score]?
    init(dictionary: [String: Any]) {
        code = dictionary["code"] as? Int ?? 0
        message = dictionary["message"] as? String ?? ""
        if let value = dictionary["result"] as? [[String: Any]] {
            var scores: [Score] = []
            for scoreDict in value {
                let score = Score(dictionary: scoreDict)
                scores.append(score)
            }
            self.result = scores
        } else {
            self.result = nil
        }
    }
}

struct Score {
    let email: String
    let score: Int
    init(dictionary: [String: Any]) {
        self.email = dictionary["email"] as? String ?? ""
        self.score = dictionary["score"] as? Int ?? 0
    }
}
