//
//  ExamCell.swift
//  Exam-English
//
//  Created by Trần Văn Chương on 17/06/2024.
//

import UIKit

class ExamCell: UITableViewCell {
// MARK: - Outlet
    @IBOutlet weak var subView: UIView!
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
        setupView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

// MARK: Setup View
extension ExamCell {
    func setupView() {
        customItem()
    }
    
    func updatesView(listExam: ExamHome) {
        nameLabel.text = listExam.examinationName
        timeLabel.text = formattedDate(from: listExam.endTime)
    }
    
    func customItem() {
        custom.childRankBackgound(nameBackground: subView)
    }
    
    func formattedDate(from dateString: String) -> String {
        let inputDateFormatter = DateFormatter()
        inputDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        if let date = inputDateFormatter.date(from: dateString) {
            let outputDateFormatter = DateFormatter()
            outputDateFormatter.dateFormat = "yyyy-MM-dd - HH:mm:ss"
            
            return outputDateFormatter.string(from: date)
        } else {
            return dateString
        }
    }
}

// MARK: - Func
extension ExamCell {}
