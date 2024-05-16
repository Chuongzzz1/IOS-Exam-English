//
//  StudyViewCell.swift
//  Exam-English
//
//  Created by Trần Văn Chương on 02/05/2024.
//

import UIKit

class StudyViewCell: UICollectionViewCell {
    // MARK: - Outlet
    @IBOutlet weak var backgroudView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    // MARK: - Variable
    private var custom = CustomView()
}

// MARK: - Awake
extension StudyViewCell {
    override func awakeFromNib() {
        super.awakeFromNib()
        customIem()
    }
}

// MARK: - Func
extension StudyViewCell {
    func updatesView(study: FruitModel) {
        titleLabel.text = study.nameFruit
    }
    
    func customIem() {
        custom.customItemSubject(backgroudView)
    }
}
