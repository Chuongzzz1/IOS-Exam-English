//
//  APIService.swift
//  Exam-English
//
//  Created by Trần Văn Chương on 24/04/2024.
//

import Foundation
import UIKit

// MARK: - Enum
enum APIError: Error {
    case invalidURL
    case noData
    case decodingError
}

enum TokenValidity {
    case valid
    case expired
    case unknown
}

class Authentication {
    static let shared = Authentication()
    private init() {}

    func postLogin(username: String, password: String, completion: @escaping (Result<Data, Error>) -> Void) {
        guard let url = URL(string: Constants.API.Endpoints.loginURL) else {
            completion(.failure(NSError(domain: Constants.Messages.invalidURL, code: 0, userInfo: nil)))
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
            
            guard let data = data else {
                completion(.failure(NSError(domain: Constants.Messages.noData, code: 0, userInfo: nil)))
                return
            }
            
            do {
                let responseObject = try JSONDecoder().decode(AccessTokenResponse.self, from: data)
                if responseObject.code == 1000 {
                    completion(.success(data))
                } else {
                    let errorMessage = "Login failed with error code: \(responseObject.code)"
                    completion(.failure(NSError(domain: "Login Error", code: responseObject.code, userInfo: [NSLocalizedDescriptionKey: errorMessage])))
                }
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    func postLogout(navigationController: UINavigationController?, accessToken: String) {
        guard let url = URL(string: Constants.API.Endpoints.logoutURL) else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        let tokenDict: [String: Any] = ["token": accessToken]
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: tokenDict, options: [])
            request.httpBody = jsonData
        } catch {
            print("Error creating JSON data: \(error)")
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("There was an error: \(error.localizedDescription)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                print("Debug - Error in Sever code: \(String(describing: (response as? HTTPURLResponse)?.statusCode))")
                return
            }
    
            UserDefaults.standard.removeObject(forKey: "accessToken")

            DispatchQueue.main.async {
                let loginVC = LoginViewController(nibName: "LoginViewController", bundle: nil) // nibNameString
                UIApplication.shared.windows.first?.rootViewController = loginVC
                UIApplication.shared.windows.first?.makeKeyAndVisible()
            }
        }
        task.resume()
    }
    
    func checkAccessTokenValidity(accessToken: String, completion: @escaping (TokenValidity) -> Void) {
        guard let url = URL(string: Constants.API.Endpoints.introspectURL) else {
            completion(.unknown)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        let params = ["token": accessToken]
        request.httpBody = try? JSONSerialization.data(withJSONObject: params)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data, error == nil else {
                print("Error checking access token validity: \(error?.localizedDescription ?? "Unknown error")")
                completion(.unknown)
                return
            }
            
            do {
                let validityResponse = try JSONDecoder().decode(TokenValidityResponse.self, from: data)
                let isValid = validityResponse.result.valid
                if isValid {
                    completion(.valid)
                } else {
                    completion(.expired)
                }
            } catch {
                print("Error decoding token validity response: \(error)")
                completion(.unknown)
            }
        }
        task.resume()
    }
    
    func refreshAccessToken(accessToken: String) {
        guard let url = URL(string: Constants.API.Endpoints.refreshURL) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let tokenDict: [String: Any] = ["token": accessToken]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: tokenDict, options: [])
            request.httpBody = jsonData
        } catch {
            print("Error creating JSON data: \(error)")
            return
        }

        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data, error == nil else {
                print("Error refreshing access token: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let result = json["result"] as? [String: Any],
                   let newAccessToken = result["token"] as? String {
                    UserDefaults.standard.set(newAccessToken, forKey: "accessToken")
                    print("New access token obtained: \(newAccessToken)")

                } else {
                    print("Error: Missing or invalid token result")
                }
            } catch {
                print("Error decoding token response: \(error)")
            }
        }
        task.resume()
    }
    
    func scheduleRefreshAccessToken(accessToken: String, interval: TimeInterval = Constants.Network.timeoutInterval) {
        DispatchQueue.main.asyncAfter(deadline: .now() + interval) {
            self.refreshAccessToken(accessToken: accessToken)
            print("new: \(accessToken)")
            self.scheduleRefreshAccessToken(accessToken: accessToken, interval: interval)
        }
    }
}

// test
