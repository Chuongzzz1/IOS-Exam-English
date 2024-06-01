//
//  ListQuestionWithPhotoCell.swift
//  Exam-English
//
//  Created by Trần Văn Chương on 30/05/2024.
//

import UIKit
protocol ListQuestionWithPhotoCellDelegate: AnyObject {
    func handleScrollNext(sender: UIButton)
    func handleScrollPrevious(sender: UIButton)
}
class ListQuestionWithPhotoCell: UICollectionViewCell {
    // MARK: - Outlet
    @IBOutlet weak var imageQuestionView: UIImageView!
    @IBOutlet weak var questionBackgoundView: UIView!
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
    private var answerLabels: [UILabel] = []
    private var correctAnswer: Int = -1
    private var selectedAnswerIndex: Int? = nil
    private var custom = CustomView()
    weak var delegate: ListQuestionWithPhotoCellDelegate?
}

// MARK: - Awake
extension ListQuestionWithPhotoCell {
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCell()
    }
}

// MARK: - Action
extension ListQuestionWithPhotoCell {
    @IBAction func answerButtonTapped(_ sender: UIButton) {
        updateAnswerButtonStates(selectedButton: sender)
        selectedAnswerIndex = answerButtons.firstIndex(of: sender)
    }

        
    @IBAction func checkAnswer(_ sender: UIButton) {
        if let selectedIndex = selectedAnswerIndex {
            if selectedIndex == correctAnswer {
                custom.trueAnswer(answerImages[selectedIndex], answerLabels[selectedIndex])
            } else {
                custom.falseAnswer(answerImages[selectedIndex], answerLabels[selectedIndex])
            }
        } else {
            custom.trueAnswer(answerImages[correctAnswer], answerLabels[correctAnswer])
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
extension ListQuestionWithPhotoCell {
    func configure(with question: StudyQuestion) {
        resetUI()
        questionLabel.text = question.subQuestionContent
        guard let subAnswers = question.answers else { return }
        
        answerALabel.text = subAnswers[safe: 0]?.answerContent
        answerBLabel.text = subAnswers[safe: 1]?.answerContent
        answerCLabel.text = subAnswers[safe: 2]?.answerContent
        answerDLabel.text = subAnswers[safe: 3]?.answerContent
        
        let isAnswerDHidden = subAnswers.count < 4
        answerDLabel.isHidden = isAnswerDHidden
        answerDButton.isHidden = isAnswerDHidden
        answerDImage.isHidden = isAnswerDHidden
        
        for (index, answer) in subAnswers.enumerated() {
            if answer.correctAnswer {
                correctAnswer = index
            }
        }
    }

    func resetUI() {
        for imageView in answerImages {
            imageView.image = UIImage(named: "off")
        }
        for label in answerLabels {
            label.textColor = UIColor.label
        }
        selectedAnswerIndex = nil
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
        answerLabels = [answerALabel, answerBLabel, answerCLabel, answerDLabel]
        
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
        customView()
        questionLabel.adjustsFontSizeToFitWidth = true
        questionLabel.minimumScaleFactor = 0.5
    }
    
    func customView() {
        custom.customCheckButton(checkButton)
        custom.labelQuestion(nameBackground: questionBackgoundView)
    }
}
