//
//  APIService.swift
//  Exam-English
//
//  Created by Trần Văn Chương on 24/04/2024.
//

import Foundation
// MARK: - Enum
enum APIError: Error {
    case invalidURL
    case noData
    case decodingError
}
struct LoginData: Codable {
    let username: String
    let password: String
}
class APIService {
    static let shared = APIService()
    private init() {}
    
    func postLogin(username: String, password: String, completion: @escaping (Result<Data, Error>) -> Void) {
        guard let url = URL(string: "http://172.16.75.32:8080/auth/token") else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }
        let loginData = LoginData(username: username, password: password)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let jsonData = try JSONEncoder().encode(loginData)
            request.httpBody = jsonData
        } catch {
            completion(.failure(error))
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                let statusCode = (response as? HTTPURLResponse)?.statusCode ?? -1
                completion(.failure(NSError(domain: "Server Error", code: statusCode, userInfo: nil)))
                return
            }
            
            if let data = data {
                completion(.success(data))
            } else {
                completion(.failure(NSError(domain: "No data received", code: 0, userInfo: nil)))
            }
        }
        
        task.resume()
    }
}
