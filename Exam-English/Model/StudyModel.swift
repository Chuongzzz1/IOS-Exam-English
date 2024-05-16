//
//  StudyModel.swift
//  Exam-English
//
//  Created by Trần Văn Chương on 02/05/2024.
//

import Foundation
struct StudySubjectResponse {
    let code: Int
    let message: String
    var result: [StudySubject]?
    init(dictionary: [String: Any]) {
        code = dictionary["code"] as? Int ?? 0
        message = dictionary["message"] as? String ?? ""
        if let value = dictionary["result"] as? [[String: Any]] {
            for subjectDict in value {
                let studySubject = StudySubject(dictionary: subjectDict)
                self.result?.append(studySubject)
            }
        }
    }
}

struct StudySubject {
    let subjectID: Int
    let subjectName: String
//    let categoryID: Int
//    let categoryName: String
//    let mainSectionID: Int
//    let mainSectionName: String
//    let subSectionID: Int
//    let subSectionName: String
    init(dictionary: [String: Any]) {
        self.subjectID = dictionary["SubjectID"] as? Int ?? 0
        self.subjectName = dictionary["SubjectName"] as? String ?? ""
//        self.categoryID = dictionary["CategoryID"] as? Int ?? 0
//        self.categoryName = dictionary["CategoryName"] as? String ?? ""
//        self.mainSectionID = dictionary["MainSectionID"] as? Int ?? 0
//        self.mainSectionName = dictionary["MainSectionName"] as? String ?? ""
//        self.subSectionID = dictionary["SubSectionID"] as? Int ?? 0
//        self.subSectionName = dictionary["SubSectionName"] as? String ?? ""
    }
}

struct StudyCategoryResponse {
    let code: Int
    let message: String
    var result: [StudyCategory]?
    init(dictionary: [String: Any]) {
        code = dictionary["code"] as? Int ?? 0
        message = dictionary["message"] as? String ?? ""
        if let value = dictionary["result"] as? [[String: Any]] {
            for categoryDict in value {
                let studyCategory = StudyCategory(dictionary: categoryDict)
                self.result?.append(studyCategory)
            }
        }
    }
}

struct StudyCategory {
    let categoryID: Int
    let categoryName: String
    let subjectID: Int
    init(dictionary: [String: Any]) {
        self.categoryID = dictionary["CategoryID"] as? Int ?? 0
        self.categoryName = dictionary["CategoryName"] as? String ?? ""
        self.subjectID = dictionary["SubjectID"] as? Int ?? 0
    }
}
