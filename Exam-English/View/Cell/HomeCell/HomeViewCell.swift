//
//  HomeViewCell.swift
//  Exam-English
//
//  Created by Trần Văn Chương on 03/06/2024.
//

import UIKit

class HomeViewCell: UITableViewCell {
// MARK: - Outlet
    @IBOutlet weak var subView: UIView!
    @IBOutlet weak var rankNumberLabel: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var nameUserLabel: UILabel!
    @IBOutlet weak var scoreNumberLabel: UILabel!
// MARK: - Variable
    private var custom = CustomView()
}

// MARK: - Awake
extension HomeViewCell {
    override func awakeFromNib() {
        super.awakeFromNib()
        customIem()
    }
}

// MARK: - Func
extension HomeViewCell {
    func updatesView(score: Score, rank: Int) {
        nameUserLabel.text = score.email
        scoreNumberLabel.text = String(score.score)
        rankNumberLabel.text = String(rank)
    }
    
    func customIem() {
        custom.customItemCategory(subView)
        self.selectionStyle = .none
    }

}
