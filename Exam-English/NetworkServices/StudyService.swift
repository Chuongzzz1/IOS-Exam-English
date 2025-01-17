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
    
    private var accessToken: String? {
        return UserDefaults.standard.string(forKey: "accessToken")
    }
    
    func fetchSubject(completion: @escaping (Result<StudySubjectResponse, Error>) -> Void) {
        guard let url = URL(string: Constants.API.Endpoints.subjectURL), let token = accessToken else {
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
        guard let url = URL(string: Constants.API.Endpoints.categoryURL(for: subjectID)), let token = accessToken else {
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
        guard let url = URL(string: Constants.API.Endpoints.mainSectionURL(for: categoryID)), let token = accessToken else {
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
        guard let url = URL(string: Constants.API.Endpoints.subSectionURL(for: mainSectionID)), let token = accessToken else {
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
        guard let url = URL(string: Constants.API.Endpoints.questionURL(for: subSection, page: page)), let token = accessToken else {
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
    
    func fetchAudio(mainQuestionURL: String, completion: @escaping (Result<Data, Error>) -> Void) {
        guard let url = URL(string: Constants.API.Endpoints.audioURL(mainQuestionURL: mainQuestionURL)), let token = accessToken else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print(Constants.Messages.errorOccurred +  "\(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                print(Constants.Messages.noData)
                return
            }
            completion(.success(data))
        }
        task.resume()
    }
}
