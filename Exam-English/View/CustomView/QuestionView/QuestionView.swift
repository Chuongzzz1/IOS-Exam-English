//
//  QuestionView.swift
//  Exam-English
//
//  Created by Trần Văn Chương on 17/06/2024.
//

import UIKit
import AVFoundation

class QuestionView: UIView {
// MARK: - Outlet
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var imageParentView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textQuestionParentView: UIView!
    @IBOutlet weak var textQuestionView: UIView!
    @IBOutlet weak var textQuestionLabel: UILabel!
    @IBOutlet weak var questionParentView: UIView!
    @IBOutlet weak var questionView: UIView!
    @IBOutlet weak var numberQuestionLabel: UILabel!
    
    @IBOutlet weak var buttonAImage: UIImageView!
    @IBOutlet weak var AButton: UIButton!
    @IBOutlet weak var AContentLabel: UILabel!
    
    @IBOutlet weak var buttonBImage: UIImageView!
    @IBOutlet weak var BButton: UIButton!
    @IBOutlet weak var BContentLabel: UILabel!
    
    @IBOutlet weak var buttonCImage: UIImageView!
    @IBOutlet weak var CButton: UIButton!
    @IBOutlet weak var CContentLabel: UILabel!
    
    @IBOutlet weak var buttonDImage: UIImageView!
    @IBOutlet weak var DLabel: UILabel!
    @IBOutlet weak var DButton: UIButton!
    @IBOutlet weak var DContentLabel: UILabel!
    
// MARK: - Variable
    private var custom = CustomView()
    private var baseImageUrl = Constants.API.Endpoints.baseImageURL
    private var baseAudioUrl = Constants.API.Endpoints.baseAudioURL
    private var audioPlayer: AVAudioPlayer?
    var questionModel: QuestionModel?
    var questions: [QuestionModel] = []
    var onAnswerSelected: ((Int) -> Void)?

    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.xibSetup()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.xibSetup()
    }
    
    private func xibSetup() {
        self.containerView = loadNibFile()
        self.containerView.frame = bounds
        self.addSubview(self.containerView)
        customView()
        self.containerView.translatesAutoresizingMaskIntoConstraints = false
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[childView]|",
                                                      options: [],
                                                      metrics: nil,
                                                      views: ["childView": self.containerView!]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[childView]|",
                                                      options: [],
                                                      metrics: nil,
                                                      views: ["childView": self.containerView!]))
    }
    
    func configure(with question: QuestionModel, audio: UISlider) {
//        self.questionModel = question
        guard let subAnswers = question.answers else { return }
//        self.textQuestionLabel.text = question.subQuestionContent

        if let subQuestionUrl = question.subQuestionUrl, !subQuestionUrl.isEmpty {
            imageParentView.isHidden = false
        } else {
            imageParentView.isHidden = true
        }
        
        if let numberQuestion = question.subQuestionContent {
            questionParentView.isHidden = false
            self.numberQuestionLabel.attributedText = numberQuestion.htmlToAttributedString
        }
        self.AContentLabel.text = subAnswers[safe: 0]?.answerContent
        self.BContentLabel.text = subAnswers[safe: 1]?.answerContent
        self.CContentLabel.text = subAnswers[safe: 2]?.answerContent
        self.DContentLabel.text = subAnswers[safe: 3]?.answerContent
        
        if subAnswers.count < 4 {
            DContentLabel.isHidden = true
            DButton.isHidden = true
            buttonDImage.isHidden = true
            DLabel.isHidden = true
        }  else {
            DContentLabel.isHidden = false
            DButton.isHidden = false
            buttonDImage.isHidden = false
            DLabel.isHidden = false
        }
        
        switch question.selectedAnswerIndex {
        case 0:
            buttonAImage.image = UIImage(named: "on")
        case 1:
            buttonBImage.image = UIImage(named: "on")
        case 2:
            buttonCImage.image = UIImage(named: "on")
        case 3:
            buttonDImage.image = UIImage(named: "on")
        default:
            break
        }
    }
    
    @IBAction func answerButtonTapped(_ sender: UIButton) {
        resetAnswerStates()
        var selectedAnswerIndex: Int?
        
        switch sender {
        case AButton:
            buttonAImage.image = UIImage(named: "on")
            selectedAnswerIndex = 0
        case BButton:
            buttonBImage.image = UIImage(named: "on")
            selectedAnswerIndex = 1
        case CButton:
            buttonCImage.image = UIImage(named: "on")
            selectedAnswerIndex = 2
        case DButton:
            buttonDImage.image = UIImage(named: "on")
            selectedAnswerIndex = 3
        default:
            break
        }
        
        if let selectedIndex = selectedAnswerIndex {
            onAnswerSelected?(selectedIndex)
        }
    }
    
    func resetAnswerStates() {
        buttonAImage.image = UIImage(named: "off")
        buttonBImage.image = UIImage(named: "off")
        buttonCImage.image = UIImage(named: "off")
        buttonDImage.image = UIImage(named: "off")
    }
    
    func calculateTotalHeight(constrainedToWidth width: CGFloat) -> CGFloat {
        var totalHeight: CGFloat = 0
        let spacingBetweenStackView: CGFloat = 16
        let spacingBetweenLabels: CGFloat = 4
        let parentPadding: CGFloat = 16
        let labelPadding: CGFloat = 4
        
        let labels = [numberQuestionLabel, AContentLabel, BContentLabel, CContentLabel, DContentLabel]

        for label in labels {
            if let label = label, let text = label.text, let font = label.font {
                let labelWidth = label.bounds.width
                let textHeight = ExamQuestionViewController.getTextBoundSize(text, font: font, constrainedToWidth: labelWidth).height
                totalHeight += textHeight
                totalHeight += labelPadding * 2
                totalHeight += spacingBetweenLabels
            }
        }
        
        if let image = imageView.image {
            let aspectRatio = image.size.height / image.size.width
            let imageHeight = width * aspectRatio
            totalHeight += imageHeight
        }
        
        totalHeight += spacingBetweenStackView
        totalHeight += parentPadding
        return totalHeight
    }
}

extension QuestionView {
    func loadNibFile() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nibName = String(describing: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as! UIView
    }
}

// MARK: - Setup View
extension QuestionView {
    func customView() {
        custom.labelQuestion(nameBackground: questionView)
        custom.labelQuestion(nameBackground: textQuestionView)
    }
}

// MARK: - Func
extension QuestionView {
}

