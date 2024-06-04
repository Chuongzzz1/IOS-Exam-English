//
//  Extensions.swift
//  Exam-English
//
//  Created by Trần Văn Chương on 29/05/2024.
//

import Foundation
import UIKit
extension String {
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return nil }
        do {
            let attributedString = try NSMutableAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
            
            let fontMetrics = UIFontMetrics.default
            
            let scaledFont = fontMetrics.scaledFont(for: UIFont.systemFont(ofSize: 16, weight: .medium))
            
            attributedString.addAttributes([.font: scaledFont], range: NSRange(location: 0, length: attributedString.length))
            
            return attributedString
        } catch {
            print("error:", error)
            return nil
        }
    }
    
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
}

extension Collection {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

extension String {
    func truncated(to length: Int, addEllipsis: Bool = true) -> String {
        if self.count <= length {
            return self
        } else {
            let endIndex = self.index(self.startIndex, offsetBy: length)
            let truncatedString = self[..<endIndex]
            return addEllipsis ? truncatedString + "..." : String(truncatedString)
        }
    }
}

