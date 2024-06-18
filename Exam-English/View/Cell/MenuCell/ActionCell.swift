//
//  ActionCell.swift
//  Exam-English
//
//  Created by Trần Văn Chương on 15/06/2024.
//

import UIKit

class ActionCell: UITableViewCell {
// MARK: - Outlet
    @IBOutlet weak var subView: UIView!
    @IBOutlet weak var nameActionLabel: UILabel!

// MARK: - Variable
    private var custom = CustomView()
}

// MARK: - Awake
extension ActionCell {
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

// MARK: - Func
extension ActionCell {
    func setupView() {
        custom.childRankBackgound(nameBackground: subView)
    }
}
