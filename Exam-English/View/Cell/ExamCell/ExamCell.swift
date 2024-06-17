//
//  ExamCell.swift
//  Exam-English
//
//  Created by Trần Văn Chương on 17/06/2024.
//

import UIKit

class ExamCell: UITableViewCell {
// MARK: - Outlet
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var expirationTimeLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    // MARK: - Variable
    private var custom = CustomView()
}

// MARK: - Awake
extension ExamCell {
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

// MARK: Setup View
extension ExamCell {}

// MARK: - Func
extension ExamCell {}
