//
//  StudyService.swift
//  Exam-English
//
//  Created by Trần Văn Chương on 10/05/2024.
//

import Foundation
import UIKit

class StudyService {
    static let shared = StudyService()
    private init() {}
    var token = "eyJhbGciOiJIUzUxMiJ9.eyJpc3MiOiJkZXZ0ZXJpYS5jb20iLCJzdWIiOiJhZG1pbiIsImV4cCI6MTcxOTgyNzYyOCwiaWF0IjoxNzE3MjM1NjI4LCJqdGkiOiJlYThhMzU2MS02MGU5LTRhZjgtYTRjMy01NDg2YTllNWY1OTAiLCJzY29wZSI6IiJ9.Yxi3g5y2OoTLBe2T7Btx_CslpQXVKaF3hLaDh5yJiQpPQFYZyQ9c-6jhxk6LsjshM_xISFkWgqIJb3wqT8B1DA"
    
    func fetchSubject(completion: @escaping (Result<StudySubjectResponse, Error>) -> Void) {
        guard let url = URL(string: Constants.API.Endpoints.subject) else {
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.dataTask(with: request) { data, reponse, error in
            if let error = error {
                print(Constants.Messages.errorOccurred +  "\(error.localizedDescription)")
                return
            }
            guard let data = data else {
                print(Constants.Messages.noData)
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any] {
                    let studySubjectResponse = StudySubjectResponse(dictionary: json)
//                    print(json)
                    completion(.success(studySubjectResponse))
                }
            } catch {
                print(Constants.Messages.errorResponse)
            }
        }
        task.resume()
    }
    
    func fetchCategory(for subjectID: Int,completion: @escaping (Result<StudyCategoryResponse, Error>) -> Void) {
        guard let url = URL(string: Constants.API.Endpoints.categories(for: subjectID)) else {
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.dataTask(with: request) { data, reponse, error in
            if let error = error {
                print(Constants.Messages.errorOccurred + "\(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                print(Constants.Messages.noData)
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any] {
                    let studyCategoryResponse = StudyCategoryResponse(dictionary: json)
//                    print(json)
                    completion(.success(studyCategoryResponse))
                }
            } catch {
                print(Constants.Messages.errorResponse)
            }
        }
        task.resume()
    }
    
    func fetchMainSection(for categoryID: Int,completion: @escaping (Result<StudyMainSectionResponse, Error>) -> Void) {
        guard let url = URL(string: Constants.API.Endpoints.mainSection(for: categoryID)) else {
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.dataTask(with: request) { data, reponse, error in
            if let error = error {
                print(Constants.Messages.errorOccurred +
                      "\(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                print(Constants.Messages.noData)
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any] {
                    let studyMainSectionResponse = StudyMainSectionResponse(dictionary: json)
                    completion(.success(studyMainSectionResponse))
                }
            } catch {
                print(Constants.Messages.errorResponse)
            }
        }
        task.resume()
    }
    
    func fetchSubSection(for mainSectionID: Int,completion: @escaping (Result<StudySubSectionResponse, Error>) -> Void) {
        guard let url = URL(string: Constants.API.Endpoints.subSection(for: mainSectionID)) else {
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.dataTask(with: request) { data, reponse, error in
            if let error = error {
                print(Constants.Messages.errorOccurred + "\(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                print(Constants.Messages.noData)
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any] {
                    let studySubSectionResponse = StudySubSectionResponse(dictionary: json)
//                    print(json)
                    completion(.success(studySubSectionResponse))
                }
            } catch {
                print(Constants.Messages.errorResponse)
            }
        }
        task.resume()
    }
    
    func fetchQuestion(for subSection: Int,page: Int,completion: @escaping (Result<StudyQuestionResponse, Error>) -> Void) {
        guard let url = URL(string: Constants.API.Endpoints.question(for: subSection, page: page)) else {
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.dataTask(with: request) { data, reponse, error in
            if let error = error {
                print(Constants.Messages.errorOccurred + "\(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                print(Constants.Messages.noData)
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any] {
                    let studyQuestionResponse = StudyQuestionResponse(dictionary: json)
//                    print(json)
                    completion(.success(studyQuestionResponse))
                }
            } catch {
                print(Constants.Messages.errorResponse)
            }
        }
        task.resume()
    }
}
