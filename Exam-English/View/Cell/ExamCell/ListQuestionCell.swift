//
//  ListQuestionCell.swift
//  Exam-English
//
//  Created by Trần Văn Chương on 25/06/2024.
//

import UIKit

class ListQuestionCell: UITableViewCell {
// MARK: - Outlet
    @IBOutlet weak var subView: UIView!
    @IBOutlet weak var numberQuestionLabel: UILabel!
    @IBOutlet weak var nameQuestionView: UIView!
    @IBOutlet weak var answerAView: UIView!
    @IBOutlet weak var answerAButton: UIButton!
    @IBOutlet weak var answerBView: UIView!
    @IBOutlet weak var answerCView: UIView!
    @IBOutlet weak var answerBButton: UIButton!
    @IBOutlet weak var answerCButton: UIButton!
    @IBOutlet weak var answerDView: UIView!
    @IBOutlet weak var answerDButton: UIButton!
    
    // MARK: - Variable
    private var custom = CustomView()
    var onAnswerSelected: ((Int) -> Void)?
    
    @IBAction func touchAnswer(_ sender: UIButton) {
        buttonTapped(sender)
    }
}

// MARK: - Awake
extension ListQuestionCell {
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

// MARK: - Setup View
extension ListQuestionCell {
    func setupView() {
        customView()
    }
    
    func customView() {
        custom.childRankBackgound(nameBackground: subView)
        custom.circle(nameView: answerAView)
        custom.circle(nameView: answerBView)
        custom.circle(nameView: answerCView)
        custom.circle(nameView: answerDView)
    }
    
    func updatesView(question: QuestionModel) {
        numberQuestionLabel.text = "\(question.rowNumber ?? 0)"
        
        if let selectedAnswerIndex = question.selectedAnswerIndex {
            switch selectedAnswerIndex {
            case 0:
                resetViewColorsSelected()
                answerAView.backgroundColor = UIColor(named: Constants.Color.backgroundColor)
            case 1:
                resetViewColorsSelected()
                answerBView.backgroundColor = UIColor(named: Constants.Color.backgroundColor)
            case 2:
                resetViewColorsSelected()
                answerCView.backgroundColor = UIColor(named: Constants.Color.backgroundColor)
            case 3:
                resetViewColorsSelected()
                answerDView.backgroundColor = UIColor(named: Constants.Color.backgroundColor)
            default:
                break
            }
        } else {
            resetViewColors()
        }
    }
    
    @objc func buttonTapped(_ sender: UIButton) {
        resetViewColorsSelected()
        var selectedAnswerIndex: Int?
        sender.superview?.backgroundColor = UIColor(named: Constants.Color.backgroundColor)
        
        switch sender {
        case answerAButton:
            selectedAnswerIndex = 0
        case answerBButton:
            selectedAnswerIndex = 1
        case answerCButton:
            selectedAnswerIndex = 2
        case answerDButton:
            selectedAnswerIndex = 3
        default:
            break
        }      
        
        if let selectedIndex = selectedAnswerIndex {
            onAnswerSelected?(selectedIndex)
        }
    }
    
    func resetViewColors() {
        answerAView.backgroundColor = .white
        answerBView.backgroundColor = .white
        answerCView.backgroundColor = .white
        answerDView.backgroundColor = .white
    }
    
    func resetViewColorsSelected() {
        answerAView.backgroundColor = .clear
        answerBView.backgroundColor = .clear
        answerCView.backgroundColor = .clear
        answerDView.backgroundColor = .clear
    }
}

// MARK: - Func
extension ListQuestionCell {}
