//
//  PaddingLabel.swift
//  Exam-English
//
//  Created by Trần Văn Chương on 29/05/2024.
//

import Foundation
import UIKit
class PaddingLabel: UILabel {

    var topInset: CGFloat
    var bottomInset: CGFloat
    var leftInset: CGFloat
    var rightInset: CGFloat

    required init(withInsets top: CGFloat, _ bottom: CGFloat,_ left: CGFloat,_ right: CGFloat) {
        self.topInset = top
        self.bottomInset = bottom
        self.leftInset = left
        self.rightInset = right
        super.init(frame: CGRect.zero)
    }

    required init?(coder aDecoder: NSCoder) {
        self.topInset = 0
        self.bottomInset = 0
        self.leftInset = 0
        self.rightInset = 0
        super.init(coder: aDecoder)
    }

    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: rect.inset(by: insets))
    }

    override var intrinsicContentSize: CGSize {
        let contentSize = super.intrinsicContentSize
        return CGSize(width: contentSize.width + leftInset + rightInset,
                      height: contentSize.height + topInset + bottomInset)
    }
}
