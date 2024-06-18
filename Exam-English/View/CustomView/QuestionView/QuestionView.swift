//
//  QuestionView.swift
//  Exam-English
//
//  Created by Trần Văn Chương on 17/06/2024.
//

import UIKit

class QuestionView: UIView {
// MARK: - Outlet
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textQuestionView: UIView!
    @IBOutlet weak var textQuestionLabel: UILabel!
    @IBOutlet weak var numberQuestionLabel: UILabel!
    @IBOutlet weak var inforQuestionLabel: UILabel!
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
    @IBOutlet weak var DButton: UIButton!
    @IBOutlet weak var DContentLabel: UILabel!
    
// MARK: - Variable
    var questionModel: QuestionModel?
    var callback: ((Bool) -> Void)?
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
//    
//    func configure(with question: QuestionModel) {
//        self.questionModel = question
//        self.textQuestionLabel.text = question.textQuestion
//        self.numberQuestionLabel.text = "Question \(question.number)"
//        self.inforQuestionLabel.text = question.info
//        
//        self.AContentLabel.text = question.answerA
//        self.BContentLabel.text = question.answerB
//        self.CContentLabel.text = question.answerC
//        self.DContentLabel.text = question.answerD
//        
//        // Load image asynchronously if it's from URL
//        if let imageURL = question.imageURL {
//            // Implement async image loading here
//        } else if let imageName = question.imageName {
//            self.imageView.image = UIImage(named: imageName)
//        }
//    }
    
    @IBAction func answerButtonTapped(_ sender: UIButton) {
        resetAnswerStates()
        
        switch sender {
        case AButton:
            buttonAImage.image = UIImage(named: "on")
        case BButton:
            buttonBImage.image = UIImage(named: "on")
        case CButton:
            buttonCImage.image = UIImage(named: "on")
        case DButton:
            buttonDImage.image = UIImage(named: "on")
        default:
            break
        }
    }
    
    private func resetAnswerStates() {
        buttonAImage.image = UIImage(named: "off")
        buttonBImage.image = UIImage(named: "off")
        buttonCImage.image = UIImage(named: "off")
        buttonDImage.image = UIImage(named: "off")
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

