////
////  Extensions.swift
////  Exam-English
////
////  Created by Trần Văn Chương on 29/05/2024.
////
//
//import Foundation
//import UIKit
//class Extensions {
//    static func htmlToAttributedString(_ string: String) -> NSAttributedString? {
//        guard let data = string.data(using: .utf8) else { return nil }
//        do {
//            let attributedString = try NSMutableAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
//            
//            let fontMetrics = UIFontMetrics.default
//            let scaledFont = fontMetrics.scaledFont(for: UIFont.systemFont(ofSize: 16))
//            attributedString.addAttributes([.font: scaledFont], range: NSRange(location: 0, length: attributedString.length))
//            
//            return attributedString
//        } catch {
//            print("error:", error)
//            return nil
//        }
//    }
//    
//    static func htmlToString(_ string: String) -> String {
//        return htmlToAttributedString(string)?.string ?? ""
//    }
//}
//
//extension Collection {
//    subscript(safe index: Index) -> Element? {
//        return indices.contains(index) ? self[index] : nil
//    }
//}
