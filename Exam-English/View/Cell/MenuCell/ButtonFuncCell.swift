//
//  ButtonFuncCell.swift
//  Exam-English
//
//  Created by Trần Văn Chương on 15/06/2024.
//

import UIKit

class ButtonFuncCell: UITableViewCell {
// MARK: - Outlet
    @IBOutlet weak var subView: UIView!
    @IBOutlet weak var nameFuncLabel: UILabel!
    
// MARK: - Variable
    private var custom = CustomView()
}

// MARK: - Awake
extension ButtonFuncCell {
    override func awakeFromNib() {
        super.awakeFromNib()
        customItem()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

// MARK: - Func
extension ButtonFuncCell {
    func customItem() {
        custom.viewButton(nameBackgroud: subView)
    }
}
