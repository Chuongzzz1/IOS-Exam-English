//
//  ExamService.swift
//  Exam-English
//
//  Created by Trần Văn Chương on 20/06/2024.
//

import Foundation
class ExamService {
    static let shared = ExamService()
    private init() {}
    
    private var accessToken: String? {
        return UserDefaults.standard.string(forKey: "accessToken")
    }
    
    func fetchQuestionExam(mainSectionId: Int, pageSize: Int,page: Int,completion: @escaping (Result<QuestionModelResponse, Error>) -> Void) {
        guard let url = URL(string: Constants.API.Endpoints.questionExamURL(mainSectionId: mainSectionId, pageSize: pageSize, page: page)), let token = accessToken else {
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
                    let questionResponse = QuestionModelResponse(dictionary: json)
//                                        print(json)
                    completion(.success(questionResponse))
                }
            } catch {
                print(Constants.Messages.errorResponse)
            }
        }
        task.resume()
    }
    
    func fetchHomeExam(completion: @escaping (Result<ExamResponse, Error>) -> Void) {
        guard let url = URL(string: Constants.API.Endpoints.examHomeURL()), let token = accessToken else {
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
                    let questionResponse = ExamResponse(dictionary: json)
//                                        print(json)
                    completion(.success(questionResponse))
                }
            } catch {
                print(Constants.Messages.errorResponse)
            }
        }
        task.resume()
    }
    
    func submitExam(info: Info, answers: [AnswerSubmit], completion: @escaping (Result<String, Error>) -> Void) {
        guard let url = URL(string: Constants.API.Endpoints.submitExamURL()), let token = accessToken else {
            return
        }

        let requestData = SubmitData(info: info, answer: answers)

        do {
            print("Request Data: \(requestData)")

            let jsonData = try JSONEncoder().encode(requestData)
            print("Encoded JSON Data: \(String(data: jsonData, encoding: .utf8) ?? "Empty")")

            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type") // Set Content-Type header
            request.httpBody = jsonData

            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                    completion(.failure(error))
                    return
                }

                if let httpResponse = response as? HTTPURLResponse {
                    print("HTTP Response Code: \(httpResponse.statusCode)")
                }

                if let data = data, let responseString = String(data: data, encoding: .utf8) {
                    print("Response Data: \(responseString)")
                    completion(.success(responseString))
                } else {
                    completion(.failure(NSError(domain: "Response parsing error", code: 0, userInfo: nil)))
                }
            }

            task.resume()
        } catch {
            print("Error encoding JSON: \(error.localizedDescription)")
            completion(.failure(error))
        }
    }
    
    func fetchUser(completion: @escaping (Result<UserResponse, Error>) -> Void) {
        guard let url = URL(string: Constants.API.Endpoints.userURL()), let token = accessToken else {
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
                    let questionResponse = UserResponse(dictionary: json)
//                                        print(json)
                    completion(.success(questionResponse))
                }
            } catch {
                print(Constants.Messages.errorResponse)
            }
        }
        task.resume()

    }
}
