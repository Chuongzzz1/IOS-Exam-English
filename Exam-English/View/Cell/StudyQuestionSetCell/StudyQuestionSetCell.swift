//
//  StudyQuestionSetCell.swift
//  Exam-English
//
//  Created by Trần Văn Chương on 06/05/2024.
//

import UIKit

class StudyQuestionSetCell: UITableViewCell {
    // MARK: - Outlet
    @IBOutlet weak var titleLabel: UILabel!
    
}
// MARK: - Awake Nib
extension StudyQuestionSetCell {
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

// MARK: - Func
extension StudyQuestionSetCell {
    func updatesView(category: FruitModel) {
        titleLabel.text = category.nameFruit
    }
}
