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
    var token = "eyJhbGciOiJIUzUxMiJ9.eyJpc3MiOiJkZXZ0ZXJpYS5jb20iLCJzdWIiOiJhZG1pbiIsImV4cCI6MTcxNjA5MzgxMCwiaWF0IjoxNzE1OTEzODEwLCJqdGkiOiJmYmQ3YzliMy03Y2JmLTRiODYtOTU1ZS1lYWZlNTgxODVhYjIiLCJzY29wZSI6IiJ9.ovG3L5LaM2X2McKv5cutg-7sPwn7Z8c_D9caUE3Wgo9jROPitdx-0f8h0Ms9NFdfQLaTpnK-54Vvs_Ivpxg0Iw"
    func fetchSubject(completion: @escaping (Result<StudySubjectResponse, Error>) -> Void) {
        guard let url = URL(string: "http://172.16.75.43:8082/api/subject") else {
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.dataTask(with: request) { data, reponse, error in
            if error != nil {
                print("debug error: subject")
                return
            }
            
            guard let data = data else {
                print("debug no data: subject")
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any] {
                    let studySubjectResponse = StudySubjectResponse(dictionary: json)
//                    print(json)
                    completion(.success(studySubjectResponse))
                }
            } catch {
                print("errorMsg")
            }
        }
        task.resume()
    }
    
    func fetchCategory(for subjectID: Int ,completion: @escaping (Result<StudyCategoryResponse, Error>) -> Void) {
        guard let url = URL(string: "http://172.16.75.43:8082/api/subject/categories?subjectId=\(subjectID)") else {
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.dataTask(with: request) { data, reponse, error in
            if let error = error {
                print("There was an error: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                print("debug no data: category")
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any] {
                    let studyCategoryResponse = StudyCategoryResponse(dictionary: json)
//                    print(json)
                    completion(.success(studyCategoryResponse))
                }
            } catch {
                print("errorMsg: category")
            }
        }
        task.resume()
    }
    
    func fetchMainSection(for categoryID: Int ,completion: @escaping (Result<StudyMainSectionResponse, Error>) -> Void) {
        guard let url = URL(string: "http://172.16.75.43:8082/api/subject/categories/mainSection?categoryId=\(categoryID)") else {
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.dataTask(with: request) { data, reponse, error in
            if let error = error {
                print(
                    "There was an error: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                print("debug no data: category")
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any] {
                    let studyMainSectionResponse = StudyMainSectionResponse(dictionary: json)
                    print(json)
                    completion(.success(studyMainSectionResponse))
                }
            } catch {
                print("errorMsg: category")
            }
        }
        task.resume()
    }
}
