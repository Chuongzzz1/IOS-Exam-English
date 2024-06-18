//
//  ExamQuestionViewController.swift
//  Exam-English
//
//  Created by Trần Văn Chương on 18/06/2024.
//

import UIKit

class ExamQuestionViewController: UIViewController {
// MARK: - Outlet
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var partLabel: UILabel!
    @IBOutlet weak var numberPartLabel: UILabel!
    @IBOutlet weak var listAnswerImage: UIImageView!
    @IBOutlet weak var listAnswerButton: UIButton!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var timeRunLabel: UILabel!
    @IBOutlet weak var audioSlider: UISlider!
    @IBOutlet weak var timeRemainLabel: UILabel!
    @IBOutlet weak var pauseResumeImage: UIImageView!
    @IBOutlet weak var pauseResumeButton: UIButton!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    
// MARK: - Variable
    private var questionView: QuestionView!

}

// MARK: - Life Cycle
extension ExamQuestionViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupQuestionView()
    }
}


// MARK: - Setup View
extension ExamQuestionViewController {
    // MARK: - Setup View
    private func setupQuestionView() {
        questionView = QuestionView()
        questionView.translatesAutoresizingMaskIntoConstraints = false
        mainView.addSubview(questionView)
        
        NSLayoutConstraint.activate([
            questionView.leadingAnchor.constraint(equalTo: mainView.leadingAnchor),
            questionView.trailingAnchor.constraint(equalTo: mainView.trailingAnchor),
            questionView.topAnchor.constraint(equalTo: mainView.topAnchor),
            questionView.bottomAnchor.constraint(equalTo: mainView.bottomAnchor)
        ])
        
        // Optional: Set callback if you need to handle prev/next button actions
        questionView.callback = { [weak self] isNext in
            // Handle prev/next button action here
        }
    }
}

// MARK: - Func
extension ExamQuestionViewController {}

// MARK: - Handle API
extension ExamQuestionViewController {}


