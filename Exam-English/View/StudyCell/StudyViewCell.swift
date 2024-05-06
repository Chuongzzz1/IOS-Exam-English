//
//  StudyViewCell.swift
//  Exam-English
//
//  Created by Trần Văn Chương on 02/05/2024.
//

import UIKit

class StudyViewCell: UICollectionViewCell {
    // MARK: - Outlet
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
}

// MARK: - Awake
//extension StudyViewCell {
//    override func awakeFromNib() {
//        super.awakeFromNib()
//    }
//}

// MARK: - Func
extension StudyViewCell {
    func updatesView(study: FruitModel) {
        imageView.image = UIImage(named: study.imageFruit)
        titleLabel.text = study.nameFruit
    }
}
