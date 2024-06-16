//
//  HeaderStudySection.swift
//  Exam-English
//
//  Created by Trần Văn Chương on 06/05/2024.
//

import UIKit

class HeaderStudySection: UICollectionViewCell {
// MARK: - Outlet
    @IBOutlet weak var nameSectionLabel: UILabel!
}

// MARK: - Awake Nib
extension HeaderStudySection {
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

//MARK: - Func
extension HeaderStudySection {
    func updatesView(study: StudySubject) {
        nameSectionLabel.text = study.subjectName
    }
}
