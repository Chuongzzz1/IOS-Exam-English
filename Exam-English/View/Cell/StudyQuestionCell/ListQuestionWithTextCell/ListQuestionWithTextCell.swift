//
//  ListQuestionWithTextCell.swift
//  Exam-English
//
//  Created by Trần Văn Chương on 24/05/2024.
//

import UIKit
protocol ListQuestionWithTextCellDelegate: AnyObject {
    func handleScrollNext(sender: UIButton)
    func handleScrollPrevious(sender: UIButton)
}
class ListQuestionWithTextCell: UICollectionViewCell {
    // MARK: - Outlet
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var answerAButton: UIButton!
    @IBOutlet weak var answerALabel: UILabel!
    @IBOutlet weak var answerAImage: UIImageView!
    @IBOutlet weak var answerBButton: UIButton!
    @IBOutlet weak var answerBLabel: UILabel!
    @IBOutlet weak var answerBImage: UIImageView!
    @IBOutlet weak var answerCButton: UIButton!
    @IBOutlet weak var answerCLabel: UILabel!
    @IBOutlet weak var answerCImage: UIImageView!
    @IBOutlet weak var answerDButton: UIButton!
    @IBOutlet weak var answerDLabel: UILabel!
    @IBOutlet weak var answerDImage: UIImageView!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    // MARK: - Variable
    private var answerButtons: [UIButton] = []
    private var answerImages: [UIImageView] = []
    private var correctAnswer: Int = -1
    weak var delegate: ListQuestionWithTextCellDelegate?
}

// MARK: - Awake
extension ListQuestionWithTextCell {
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCell()
    }
}

// MARK: - Action
extension ListQuestionWithTextCell {
    @IBAction func answerButtonTapped(_ sender: UIButton) { 
        updateAnswerButtonStates(selectedButton: sender)
        let selectedAnswerIndex = answerButtons.firstIndex(of: sender) ?? -1
        if selectedAnswerIndex == correctAnswer {
            print("Đáp án đúng đã được chọn")
        } else {
            print("Đáp án sai đã được chọn")
        }
    }
    
    @objc func scrollPrevious(_ sender: UIButton) {
        delegate?.handleScrollPrevious(sender: sender)
    }
    
    @objc func scrollNext(_ sender: UIButton) {
        delegate?.handleScrollNext(sender: sender)
    }

}

// MARK: - Func
extension ListQuestionWithTextCell {
    func configure(with question: StudyQuestion) {
        questionLabel.attributedText = question.normalQuestionContent.htmlToAttributedString
        answerALabel.text = question.subAnswers?[0].answerContent
        answerBLabel.text = question.subAnswers?[1].answerContent
        answerCLabel.text = question.subAnswers?[2].answerContent
        answerDLabel.text = question.subAnswers?[3].answerContent
        if let subAnswers = question.subAnswers {
            for (index, answer) in subAnswers.enumerated() {
                if answer.correctAnswer {
                    correctAnswer = index
                }
            }
        }
    }

    func updateAnswerButtonStates(selectedButton: UIButton) {
        for (index, button) in answerButtons.enumerated() {
            if button == selectedButton {
                answerImages[index].image = UIImage(named: "on")
            } else {
                answerImages[index].image = UIImage(named: "off")
            }
        }
    }
    
    func handleFunc() {
        answerButtons = [answerAButton, answerBButton, answerCButton, answerDButton]
        answerImages = [answerAImage, answerBImage, answerCImage, answerDImage]
        
        for button in answerButtons {
            button.addTarget(self, action: #selector(answerButtonTapped(_:)), for: .touchUpInside)
        }
    }
    
    func handleScroll() {
        leftButton.addTarget(self, action: #selector(scrollPrevious(_:)), for: .touchUpInside)
        rightButton.addTarget(self, action: #selector(scrollNext(_:)), for: .touchUpInside)
    }
    
    func setupCell() {
        handleFunc()
        handleScroll()
    }
}

extension String {
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return nil }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            print("error:", error)
            return nil
        }
    }
    
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
}

