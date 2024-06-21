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
    
    func fetchQuestionExam(pageSize: Int,page: Int,completion: @escaping (Result<QuestionModelResponse, Error>) -> Void) {
        guard let url = URL(string: Constants.API.Endpoints.questionExamURL(pageSize: pageSize, page: page)), let token = accessToken else {
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
}
