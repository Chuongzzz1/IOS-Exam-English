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
    @IBOutlet weak var imageImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    // MARK: - Variable
    
}

// MARK: - Awake Nib
extension StudyDetailCell {
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

// MARK: - Func
extension StudyDetailCell {
    func updatesView(category: FruitModel) {
        imageImageView.image = UIImage(named: category.imageFruit)
        titleLabel.text = category.nameFruit
        descriptionLabel.text = category.description
    }
}
