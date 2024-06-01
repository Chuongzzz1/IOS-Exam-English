//
//  StudyModel.swift
//  Exam-English
//
//  Created by Trần Văn Chương on 02/05/2024.
//

import Foundation
// MARK: - Subject
struct StudySubjectResponse {
    let code: Int
    let message: String
    var result: [StudySubject]?
    init(dictionary: [String: Any]) {
        code = dictionary["code"] as? Int ?? 0
        message = dictionary["message"] as? String ?? ""
        if let value = dictionary["result"] as? [[String: Any]] {
            var subjects: [StudySubject] = []
            for subjectDict in value {
                let studySubject = StudySubject(dictionary: subjectDict)
                subjects.append(studySubject)
            }
            self.result = subjects
        } else {
            self.result = nil
        }
    }
}

struct StudySubject {
    let subjectID: Int
    let subjectName: String
    init(dictionary: [String: Any]) {
        self.subjectID = dictionary["SubjectId"] as? Int ?? 0
        self.subjectName = dictionary["SubjectName"] as? String ?? ""
    }
}

// MARK: - Category
struct StudyCategoryResponse {
    let code: Int
    let message: String
    var result: [StudyCategory]?
    init(dictionary: [String: Any]) {
        code = dictionary["code"] as? Int ?? 0
        message = dictionary["message"] as? String ?? ""
        if let value = dictionary["result"] as? [[String: Any]] {
            var categories: [StudyCategory] = []
            for categoryDict in value {
                let studyCategory = StudyCategory(dictionary: categoryDict)
                categories.append(studyCategory)
            }
            self.result = categories
        } else {
            self.result = nil
        }
    }
}

struct StudyCategory {
    let categoryID: Int
    let categoryName: String
    let subjectID: Int
    init(dictionary: [String: Any]) {
        self.categoryID = dictionary["CategoryId"] as? Int ?? 0
        self.categoryName = dictionary["CategoryName"] as? String ?? ""
        self.subjectID = dictionary["SubjectId"] as? Int ?? 0
    }
}

// MARK: - MainSection
struct StudyMainSectionResponse {
    let code: Int
    let message: String
    var result: [StudyMainSection]?
    init(dictionary: [String: Any]) {
        code = dictionary["code"] as? Int ?? 0
        message = dictionary["message"] as? String ?? ""
        if let value = dictionary["result"] as? [[String: Any]] {
            var mainSections: [StudyMainSection] = []
            for mainSectionsDict in value {
                let studyMainSection = StudyMainSection(dictionary: mainSectionsDict)
                mainSections.append(studyMainSection)
            }
            self.result = mainSections
        } else {
            self.result = nil
        }
    }
}

struct StudyMainSection {
    let mainSectionID: Int
    let mainSectionName: String
    let categoryID: Int
    init(dictionary: [String: Any]) {
        self.mainSectionID = dictionary["MainSectionId"] as? Int ?? 0
        self.mainSectionName = dictionary["MainSectionName"] as? String ?? ""
        self.categoryID = dictionary["CategoryId"] as? Int ?? 0
    }
}

// MARK: - SubSection
struct StudySubSectionResponse {
    let code: Int
    let message: String
    var result: [StudySubSection]?
    init(dictionary: [String: Any]) {
        code = dictionary["code"] as? Int ?? 0
        message = dictionary["message"] as? String ?? ""
        if let value = dictionary["result"] as? [[String: Any]] {
            var subSections: [StudySubSection] = []
            for subSectionDict in value {
                let studySubSection = StudySubSection(dictionary: subSectionDict)
                subSections.append(studySubSection)
            }
            self.result = subSections
        } else {
            self.result = []
        }
    }
}

struct StudySubSection {
    let subSectionID: Int
    let subSectionName: String
    let mainSectionID: Int
    init(dictionary: [String: Any]) {
        self.subSectionID = dictionary["SubSectionId"] as? Int ?? 0
        self.subSectionName = dictionary["SubSectionName"] as? String ?? ""
        self.mainSectionID = dictionary["MainSectionId"] as? Int ?? 0
        
    }
}

// MARK: - Question
struct StudyQuestionResponse {
    let code: Int
    let message: String
    var result: [StudyQuestion]?
    init(dictionary: [String: Any]) {
        code = dictionary["code"] as? Int ?? 0
        message = dictionary["message"] as? String ?? ""
        if let value = dictionary["result"] as? [[String: Any]] {
            var questions: [StudyQuestion] = []
            for questionDict in value {
                let studyQuestion = StudyQuestion(dictionary: questionDict)
                questions.append(studyQuestion)
            }
            self.result = questions
        } else {
            self.result = []
        }
    }
}

struct StudyQuestion {
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
    let answers: [Answer]? // answer
    var selectedAnswerIndex: Int?
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
    }
}
// answer
struct Answer {
//    let subAnswerID: Int
    let answerContent: String
//    let subQuestionID: Int
    let correctAnswer: Bool
    let explanation: String
    let fileUrl: String
    init(dictionary: [String: Any]) {
//        self.subAnswerID = dictionary["SubAnswers"] as? Int ?? 0
        self.answerContent = dictionary["AnswerContent"] as? String ?? ""
//        self.subQuestionID = dictionary["SubQuestionId"] as? Int ?? 0
        self.correctAnswer = dictionary["CorrectAnswer"] as? Bool ?? false
        self.explanation = dictionary["Explanation"] as? String ?? ""
        self.fileUrl = dictionary["FileUrl"] as? String ?? ""
    }
}

