//
//  QuestionModel.swift
//  Exam-English
//
//  Created by Trần Văn Chương on 18/06/2024.
//

import Foundation
import UIKit

struct QuestionModelResponse {
    let code: Int
    let message: String
    var result: [QuestionModel]?
    let pagination: Pagination?
    init(dictionary: [String: Any]) {
        code = dictionary["code"] as? Int ?? 0
        message = dictionary["message"] as? String ?? ""
        if let value = dictionary["result"] as? [[String: Any]] {
            var questions: [QuestionModel] = []
            for questionDict in value {
                let question = QuestionModel(dictionary: questionDict)
                questions.append(question)
            }
            self.result = questions
        } else {
            self.result = nil
        }
        
        if let value = dictionary["pagination"] as? [String: Any] {
            pagination = Pagination(dictionary: value)
        } else {
            pagination = nil
        }

    }
}

class QuestionModel {
        let questionID: Int?
        let mainQuestionID: Int?
        let mainQuestionContent: String?
        let mainQuestionUrl: String?
        let subQuestionID: Int?
        let subQuestionContent: String?
        let subQuestionUrl: String?
        let normalQuestionID: Int?
        let normalQuestionContent: String?
        let normalQuestionUrl: String?
        let groupRandomNumber: Double?
        let answers: [Answers]?
        var selectedAnswerIndex: Int?
        var image: UIImage?
        var audioData: Data?
        init(dictionary: [String: Any]) {
            self.questionID = dictionary["QuestionId"] as? Int ?? 0
            self.mainQuestionID = dictionary["MainQuestionId"] as? Int ?? 0
            self.mainQuestionContent = dictionary["MainQuestionContent"] as? String
            self.mainQuestionUrl = dictionary["MainQuestionUrl"] as? String
            self.subQuestionID = dictionary["SubQuestionId"] as? Int ?? 0
            self.subQuestionContent = dictionary["SubQuestionContent"] as? String
            self.subQuestionUrl = dictionary["SubQuestionUrl"] as? String
            self.normalQuestionID = dictionary["NormalQuestionId"] as? Int ?? 0
            self.normalQuestionContent = dictionary["NormalQuestionContent"] as? String
            self.normalQuestionUrl = dictionary["NormalQuestionUrl"] as? String
            self.groupRandomNumber = dictionary["GroupRandomNumber"] as? Double ?? 0.0
            
            if let value = dictionary["Answers"] as? [[String: Any]] {
                var answers: [Answers] = []
                for answerDict in value {
                    let studyAnswer = Answers(dictionary: answerDict)
                    answers.append(studyAnswer)
                }
                self.answers = answers
            } else {
                self.answers = []
            }
            self.image = nil
            self.audioData = nil
        }
}

struct Pagination {
    let totalQuestion: Int
    let totalSetsOfQuestions: Int
    let totalPage: Int
    init(dictionary: [String: Any]) {
        self.totalQuestion = dictionary["TotalQuestions"] as? Int ?? 0
        self.totalSetsOfQuestions = dictionary["TotalSetsOfQuestions"] as? Int ?? 0
        self.totalPage = dictionary["TotalPages"] as? Int ?? 0
    }
}

struct Answers {
    let answerContent: String
    let correctAnswer: Bool
    let explanation: String
    let answerId: Int
    init(dictionary: [String: Any]) {
        self.answerContent = dictionary["AnswerContent"] as? String ?? ""
        self.correctAnswer = dictionary["CorrectAnswer"] as? Bool ?? false
        self.explanation = dictionary["Explanation"] as? String ?? ""
        self.answerId = dictionary["AnswerId"] as? Int ?? 0
    }
}
