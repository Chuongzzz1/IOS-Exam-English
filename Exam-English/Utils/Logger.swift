//
//  Logger.swift
//  Exam-English
//
//  Created by Trần Văn Chương on 04/06/2024.
//

import Foundation
import os.log

class Logger {
    static let shared = Logger()
    private init() {
        logInfo(Loggers.Messages.logInit)
    }
    private let log = OSLog(subsystem: Bundle.main.bundleIdentifier ?? Loggers.nameApp , category: Loggers.Categories.general)
    
    private func log(_ message: String, type: OSLogType) {
        os_log("%@", log: log, type: type, message)
    }
    
    private func writeToFile(message: String, type: OSLogType) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Loggers.dateFormat
        let dateString = dateFormatter.string(from: Date())
        
        let logString = "\(dateString) -  \(message)\n"

        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print(Loggers.errorAccess)
            return
        }
        
        let logFileURL = documentsDirectory.appendingPathComponent(Loggers.nameFile)
//        print(logFileURL)
        
        if !FileManager.default.fileExists(atPath: logFileURL.path) {
            do {
                try "".write(to: logFileURL, atomically: true, encoding: .utf8)
            } catch {
                print(Loggers.errorCreateFile + "\(error)")
                return
            }
        }

        do {
            let fileHandle = try FileHandle(forWritingTo: logFileURL)
            fileHandle.seekToEndOfFile()
            fileHandle.write(logString.data(using: .utf8)!)
            fileHandle.closeFile()
        } catch {
            print(Loggers.errorLogFile + "\(error)")
        }
    }
    
    func logInfo(_ message: String) {
        log(Loggers.Messages.info + message, type: .info)
        writeToFile(message: Loggers.Messages.info + message, type: .info)
    }
    
    func logDebug(_ message: String) {
        log(Loggers.Messages.debug + message, type: .debug)
        writeToFile(message: Loggers.Messages.debug + message, type: .debug)
    }
    
    func logError(_ message: String) {
        log(Loggers.Messages.error + message, type: .error)
        writeToFile(message: Loggers.Messages.error + message, type: .error)
    }
}
