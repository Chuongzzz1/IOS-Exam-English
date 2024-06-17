//
//  UserCell.swift
//  Exam-English
//
//  Created by Trần Văn Chương on 15/06/2024.
//

import UIKit

class UserCell: UITableViewCell {
    // MARK: - Outlet
    @IBOutlet weak var subView: UIView!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userGmailLabel: UILabel!
    
    // MARK: - Variable
    private var custom = CustomView()
}

// MARK: - Awake
extension UserCell {
    override func awakeFromNib() {
        super.awakeFromNib()
        customItem()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

// MARK: - Func
extension UserCell {
    func customItem() {
        custom.userBackgound(nameBackground: subView)
    }
}
