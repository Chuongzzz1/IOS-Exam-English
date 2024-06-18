//
//  LoggerConstants.swift
//  Exam-English
//
//  Created by Trần Văn Chương on 04/06/2024.
//

import Foundation

struct Loggers {
    static let nameApp = "comchuongzzz1.Exam-English"
    static let nameFile = "Exam-English_log.txt"
    static let dateFormat = "yyyy-MM-dd HH:mm:ss"
    static let errorAccess = "Error: Unable to access documents directory"
    static let errorCreateFile = "Error creating log file: "
    static let errorLogFile = "Error writing to log file: "
    
    struct Messages {
        static let info = "INFO: "
        static let debug = "DEBUG: "
        static let error = "ERROR: "
        static let warning = "WARNING: "
        static let logInit = "Logger initialized"
        static let logSuccess = "Log message successfully recorded"
        static let logFailure = "Failed to record log message"
    }
    
    struct Categories {
        static let general = "general"
        static let network = "network"
        static let ui = "ui"
        static let database = "database"
        static let authentication = "authentication"
    }
    
    struct LoginMessages {
        static let account = "Username"
        static let password = "Password"
        static let accountLoginFailed = "Login failed: \(account) is empty"
        static let passwordLoginFailed = "Login failed: \(password) is empty"
        static let errorTokenResponse = "Error decoding token response: "
        static let errorLoginFailed = "Login failed with error: "
    }
    
    struct StudyMessages {
        static let errorFetchCategory = "Error fetching Category: "
        static let errorFetchSubject = "Error fetching Subject: "
        static let errorFetchMainSection = "Error fetching Main Section: "
        static let errorFetchSubSection = "Error fetching Sub Section: "
        static let errorFetchQuestion = "Error fetching Qusetion: "
        static let errorFetchAudio = "Failed to fetch audio: "
        static let errorLoadmoreQuestion = "Error Loadmore Question: "
    }
    
    struct AudioMessages {
        static let errorSaved = "Failed to save audio data to file."
        static let errorWrited = "Failed to write audio data to file: "
    }
}
