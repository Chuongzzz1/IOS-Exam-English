//
//  ExamModel.swift
//  Exam-English
//
//  Created by Trần Văn Chương on 24/06/2024.
//

import Foundation
import UIKit

// MARK: - Home
struct ExamResponse {
    let code: Int
    let message: String
    var result: [ExamHome]?
    init(dictionary: [String: Any]) {
        code = dictionary["code"] as? Int ?? 0
        message = dictionary["message"] as? String ?? ""
        if let value = dictionary["result"] as? [[String: Any]] {
            var exams: [ExamHome] = []
            for examDict in value {
                let exam = ExamHome(dictionary: examDict)
                exams.append(exam)
            }
            self.result = exams
        } else {
            self.result = nil
        }
    }
}

struct ExamHome {
    let examinationId: Int
    let examinationName: String
    let mainSectionId: Int
    let mainSectionName: String
    let totalQuestions: Int
    let time: Int
    let beginTime: String
    let endTime: String
    let createdDate: String
    let score: Int
    init(dictionary: [String: Any]) {
        self.examinationId = dictionary["examinationId"] as? Int ?? 0
        self.examinationName = dictionary["examinationName"] as? String ?? ""
        self.mainSectionId = dictionary["mainSectionId"] as? Int ?? 0
        self.mainSectionName = dictionary["mainSectionName"] as? String ?? ""
        self.totalQuestions = dictionary["totalQuestions"] as? Int ?? 0
        self.time = dictionary["time"] as? Int ?? 0
        self.beginTime = dictionary["beginTime"] as? String ?? ""
        self.endTime = dictionary["endTime"] as? String ?? ""
        self.createdDate = dictionary["createdDate"] as? String ?? ""
        self.score = dictionary["score"] as? Int ?? 0
    }
}

// MARK: - Submit
struct Info: Codable {
    var examinationId: Int
    var mainSectionId: Int
    var userName: String
}

struct AnswerSubmit: Codable {
    var mainQuestionId: Int
    var normalQuestionId: Int?
    var subQuestionId: Int
    var answerContent: String?
}

struct SubmitData: Codable {
    var info: Info
    var answer: [AnswerSubmit]
}

// MARK: - Total
struct TotalResponse {
    let code: Int
    let message: String
    var result: [Total]?
    init(dictionary: [String: Any]) {
        code = dictionary["code"] as? Int ?? 0
        message = dictionary["message"] as? String ?? ""
        if let value = dictionary["result"] as? [[String: Any]] {
            var totals: [Total] = []
            for totalDict in value {
                let total = Total(dictionary: totalDict)
                totals.append(total)
            }
            self.result = totals
        } else {
            self.result = nil
        }
    }
}

struct Total {
    let resultsFromMethod2: [Total1]?
    let resultsFromMethod1: [Total2]?
    
    init(dictionary: [String: Any]) {
        if let resultsFromMethod2Array = dictionary["resultsFromMethod2"] as? [[String: Any]] {
            var results: [Total1] = []
            for resultDict in resultsFromMethod2Array {
                let total1 = Total1(dictionary: resultDict)
                results.append(total1)
            }
            self.resultsFromMethod2 = results
        } else {
            self.resultsFromMethod2 = nil
        }
        
        if let resultsFromMethod1Array = dictionary["resultsFromMethod1"] as? [[String: Any]] {
            var results: [Total2] = []
            for resultDict in resultsFromMethod1Array {
                let total2 = Total2(dictionary: resultDict)
                results.append(total2)
            }
            self.resultsFromMethod1 = results
        } else {
            self.resultsFromMethod1 = nil
        }
    }
}

struct Total1 {
    let username: String
    let examinationId: Int
    let mainSectionId: Int
    let totalQuestions: Int
    let totalCorrectAnswers: Int
    
    init(dictionary: [String: Any]) {
        username = dictionary["username"] as? String ?? ""
        examinationId = dictionary["examinationId"] as? Int ?? 0
        mainSectionId = dictionary["mainSectionId"] as? Int ?? 0
        totalQuestions = dictionary["totalQuestions"] as? Int ?? 0
        totalCorrectAnswers = dictionary["totalCorrectAnswers"] as? Int ?? 0
    }
}

struct Total2 {
    let part: Int
    let totalQuestions: Int
    let totalCorrectAnswers: Int
    init(dictionary: [String: Any]) {
         part = dictionary["part"] as? Int ?? 0
         totalQuestions = dictionary["totalQuestions"] as? Int ?? 0
         totalCorrectAnswers = dictionary["totalCorrectAnswers"] as? Int ?? 0
     }
}

