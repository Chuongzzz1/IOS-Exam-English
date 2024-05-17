//
//  StudyDetailCell.swift
//  Exam-English
//
//  Created by Trần Văn Chương on 06/05/2024.
//

import UIKit

class StudyDetailCell: UITableViewCell {
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//    }
    // MARK: - Outlet
    @IBOutlet weak var subView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    // MARK: - Variable
    private var custom = CustomView()
}

// MARK: - Awake Nib
extension StudyDetailCell {
    override func awakeFromNib() {
        super.awakeFromNib()
        customIem()
    }
}

// MARK: - Func
extension StudyDetailCell {
    func updatesView(mainSection: StudyMainSection) {
        titleLabel.text = mainSection.mainSectionName
        descriptionLabel.text = mainSection.mainSectionName
    }
    
    func customIem() {
        custom.customItemCategory(subView)
        self.selectionStyle = .none
    }
}
