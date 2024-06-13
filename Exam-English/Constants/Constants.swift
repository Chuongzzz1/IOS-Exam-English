//
//  Constants.swift
//  Exam-English
//
//  Created by Trần Văn Chương on 19/05/2024.
//

import Foundation
struct Constants {
    struct Network {
        static let timeoutInterval: TimeInterval = 3600.0
    }
        
    struct API {
        static let baseURL = "http://172.16.75.43:8080"
        
        struct Endpoints {
            static let subjectURL = "\(Constants.API.baseURL)/api/subject"
            
            static func categoryURL(for subjectID: Int) -> String {
                return "\(Constants.API.baseURL)/api/subject/categories?subjectId=\(subjectID)"
            }
            
            static func mainSectionURL(for categoryID: Int) -> String {
                return "\(Constants.API.baseURL)/api/subject/categories/mainSection?categoryId=\(categoryID)"
            }
            
            static func subSectionURL(for mainSectionID: Int) -> String {
                return "\(Constants.API.baseURL)/api/subject/categories/mainSection/subSection?mainSectionId=\(mainSectionID)"
            }
            
            static func questionURL(for subSection: Int, page: Int) -> String {
                return "\(Constants.API.baseURL)/api/questionstudies/questions?subSectionId=\(subSection)&pageNumber=\(page)&pageSize=10"
            }
            
            static let loginURL = "\(Constants.API.baseURL)/auth/token"
            static let logoutURL = "\(Constants.API.baseURL)/auth/logout"
            static let introspectURL = "\(Constants.API.baseURL)/auth/introspect"
            static let refreshURL = "\(Constants.API.baseURL)/auth/refresh"
            
            static let scoreURL = "\(Constants.API.baseURL)/api/scores?numberOfPeople=10"
            
            static func audioURL(mainQuestionURL: String) -> String {
                return "\(Constants.API.baseURL)/stream/streamingMainQuestion?mainQuestionId=\(mainQuestionURL)"
            }
            
            static func baseImageURL() -> String {
                return "\(Constants.API.baseURL)/api/images/"
            }
        }
    }
    
    struct Layer {
        static let borderWidth = 1.0
        static let mainRadius = 10.0
        static let buttonRadius = 25.0
    }
    
    struct DefaultString {
        static let empty = ""
        static let audioTail = ".mp3"
    }
    
    struct Messages {
        static let success = "Success"
        static let failure = "An error occurred"
        static let noData = "No data received"
        static let invalidURL = "Invalid URL"
        static let loginFailed = "Login failed with error code:"
        static let errorOccurred = "There was an error: "
        static let errorResponse = "Response error"
    }
    
    struct Color {
        static let mainColor = "008000"
        static let backgroundColor = "66B366"
        static let itemColor = "E5F2E5"
        static let wrapItemColor = "9FDBB4"
        static let normalColor = "D9DDDE"
        static let wrongColor = "EF4F2B"
    }
    
    struct MessageColors {
        static let mainColor = "No Main Color"
        static let itemColor = "No Item Color"
        static let wrapItemColor = "No Wrap Item Color"
        static let backgroundColor = "No Background Color"
        static let wrongColor = "No Wrong Color"
        static let normalColor = "No Normal Color"
    }
    
    struct MessageLogin {
        static let loginFailed = "User account or password incorrect"
    }
}


