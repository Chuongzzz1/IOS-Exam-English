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
    var result: Score?
    init(dictionary: [String: Any]) {
        code = dictionary["code"] as? Int ?? 0
        message = dictionary["message"] as? String ?? ""
        if let value = dictionary["result"] as? [String: Any] {
            self.result = Score(dictionary: value)
        } else {
            self.result = nil
        }
    }
}

struct Score {
    let userScore: UserScore?
    let topScores: [TopScore]?
    init(dictionary: [String: Any]) {
        if let userScoreDict = dictionary["userScore"] as? [String: Any] {
            self.userScore = UserScore(dictionary: userScoreDict)
        } else {
            self.userScore = nil
        }
        
        if let topScoresArray = dictionary["topScores"] as? [[String: Any]] {
            var topScores: [TopScore] = []
            for topScoreDict in topScoresArray {
                let topScore = TopScore(dictionary: topScoreDict)
                topScores.append(topScore)
            }
            self.topScores = topScores
        } else {
            self.topScores = nil
        }
    }
}

struct UserScore {
    let user: String
    let score: Int
    let rank: Int
    init(dictionary: [String: Any]) {
        user = dictionary["user"] as? String ?? ""
        score = dictionary["score"] as? Int ?? 0
        rank = dictionary["rank"] as? Int ?? 0
    }
}

struct TopScore {
    let user: String
    let score: Int
    let rank: Int
    init(dictionary: [String: Any]) {
        user = dictionary["user"] as? String ?? ""
        score = dictionary["score"] as? Int ?? 0
        rank = dictionary["rank"] as? Int ?? 0
    }
}
