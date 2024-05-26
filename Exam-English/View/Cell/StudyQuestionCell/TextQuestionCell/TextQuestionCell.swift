//
//  TextQuestionCell.swift
//  Exam-English
//
//  Created by Trần Văn Chương on 26/05/2024.
//

import UIKit
protocol TextQuestionCellDelegate: AnyObject {
    func handleScrollNext(sender: UIButton)
    func handleScrollPrevious(sender: UIButton)
}
class TextQuestionCell: UICollectionViewCell {
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
    @IBOutlet weak var timeRunLabel: UILabel!
    @IBOutlet weak var audioSlider: UISlider!
    @IBOutlet weak var timeRemainLabel: UILabel!
    @IBOutlet weak var pauseResumeImage: UIImageView!
    @IBOutlet weak var pauseResumeButton: UIButton!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    

    // MARK: - Variable
    private var answerButtons: [UIButton] = []
    private var answerImages: [UIImageView] = []
    private var isPaused: Bool = true
    private var correctAnswer: Int = -1
    weak var delegate: TextQuestionCellDelegate?
}

// MARK: - Awake
extension TextQuestionCell {
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCell()
    }
}

// MARK: - Action
extension TextQuestionCell {

    @IBAction func answerButtonTapped(_ sender: UIButton) {
        updateAnswerButtonStates(selectedButton: sender)
        let selectedAnswerIndex = answerButtons.firstIndex(of: sender) ?? -1
        if selectedAnswerIndex == correctAnswer {
            print("Đáp án đúng đã được chọn")
        } else {
            print("Đáp án sai đã được chọn")
        }
    }
    
    @IBAction func pauseResumeButtonTapped(_ sender: UIButton) {
        togglePauseResume()
    }
    
    @objc func scrollPrevious(_ sender: UIButton) {
        delegate?.handleScrollPrevious(sender: sender)
    }
    
    @objc func scrollNext(_ sender: UIButton) {
        delegate?.handleScrollNext(sender: sender)
    }
}


// MARK: - Func
extension TextQuestionCell {
    func configure(with question: StudyQuestion) {
        questionLabel.text = question.subQuestionContent
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
    
    func togglePauseResume() {
        isPaused.toggle()
        let imageName = isPaused ? "pause" : "resume"
        pauseResumeImage.image = UIImage(named: imageName)
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

