//
//  QuestionModel.swift
//  Exam-English
//
//  Created by Trần Văn Chương on 18/06/2024.
//

import Foundation
import UIKit

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
        let answers: [Answer]?
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
            
            if let value = dictionary["Answers"] as? [[String: Any]] {
                var answers: [Answer] = []
                for answerDict in value {
                    let studyAnswer = Answer(dictionary: answerDict)
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
