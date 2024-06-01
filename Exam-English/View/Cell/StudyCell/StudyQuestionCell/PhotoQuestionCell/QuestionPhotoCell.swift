    //
    //  QuestionPhotoCell.swift
    //  Exam-English
    //
    //  Created by Trần Văn Chương on 13/05/2024.
    //

    import UIKit
    protocol QuestionPhotoCellDelegate: AnyObject {
        func handleScrollNext(sender: UIButton)
        func handleScrollPrevious(sender: UIButton)
    }

    class QuestionPhotoCell: UICollectionViewCell {
    // MARK: - Outlet
        @IBOutlet weak var imageQuestionView: UIImageView!
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
        private var answerLabels: [UILabel] = []
        private var isPaused: Bool = true
        private var correctAnswer: Int = -1
        private var selectedAnswerIndex: Int? = nil
        private var custom = CustomView()
        weak var delegate: QuestionPhotoCellDelegate?

    }

    // MARK: - Awake
    extension QuestionPhotoCell {
        override func awakeFromNib() {
            super.awakeFromNib()
            setupCell()
        }
    }
    // MARK: - Action
    extension QuestionPhotoCell {
        @IBAction func answerButtonTapped(_ sender: UIButton) {
            updateAnswerButtonStates(selectedButton: sender)
            selectedAnswerIndex = answerButtons.firstIndex(of: sender)
    //        if let indexPath = collectionView.indexPath(for: self) {
    //            let question = currentQuestion[indexPath.item]
    //            question.selectedAnswerIndex = selectedAnswerIndex
    //        }
        }
        
        @IBAction func pauseResumeButtonTapped(_ sender: UIButton) {
            togglePauseResume()
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
    extension QuestionPhotoCell {
        func configure(with question: StudyQuestion) {
            resetUI()
            guard let subAnswers = question.answers else { return }
            answerALabel.text = subAnswers[safe: 0]?.answerContent
            answerBLabel.text = subAnswers[safe: 1]?.answerContent
            answerCLabel.text = subAnswers[safe: 2]?.answerContent
            answerDLabel.text = subAnswers[safe: 3]?.answerContent
            let isAnswerDHidden = subAnswers.count < 4
            answerDLabel.isHidden = isAnswerDHidden
            answerDButton.isHidden = isAnswerDHidden
            answerDImage.isHidden = isAnswerDHidden

            if let subAnswers = question.answers {
                for (index, answer) in subAnswers.enumerated() {
                    if answer.correctAnswer {
                        correctAnswer = index
                    }
                }
            }
            if let selectedIndex = question.selectedAnswerIndex {
                updateAnswerButtonStates(selectedButton: answerButtons[selectedIndex])
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
            customView()
        }
        
        func customView() {
            custom.customCheckButton(checkButton)
        }
    }
