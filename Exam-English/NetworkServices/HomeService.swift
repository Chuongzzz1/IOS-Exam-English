//
//  HomeService.swift
//  Exam-English
//
//  Created by Trần Văn Chương on 08/06/2024.
//

import Foundation
class HomeService {
    static let shared = HomeService()
    private init() {}
    
    private var accessToken: String? {
        return UserDefaults.standard.string(forKey: "accessToken")
    }
    
    func fetchSubject(completion: @escaping (Result<ScoreResponse, Error>) -> Void) {
        guard let url = URL(string: "http://172.16.75.43:8080/api/scores?numberOfPeople=10"), let token = accessToken else {
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
                    let scoreResponse = ScoreResponse(dictionary: json)
//                                        print(json)
                    completion(.success(scoreResponse))
                }
            } catch {
                print(Constants.Messages.errorResponse)
            }
        }
        task.resume()
    }
}
