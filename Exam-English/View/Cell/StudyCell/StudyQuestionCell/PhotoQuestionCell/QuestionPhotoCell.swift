//
//  QuestionPhotoCell.swift
//  Exam-English
//
//  Created by Trần Văn Chương on 13/05/2024.
//

import UIKit
import AVFoundation

protocol QuestionPhotoCellDelegate: AnyObject {
    func handleScrollNext(sender: UIButton)
    func handleScrollPrevious(sender: UIButton)
    func handleRefreshData()
}

class QuestionPhotoCell: UICollectionViewCell, AVAudioPlayerDelegate {
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
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!

    // MARK: - Variable
    private var answerButtons: [UIButton] = []
    private var answerImages: [UIImageView] = []
    private var answerLabels: [UILabel] = []
    private var isPaused: Bool = true
    private var correctAnswer: Int = -1
    private var selectedAnswerIndex: Int? = nil
    private var audioPlayer: AVAudioPlayer?
    private var timeObserver: Any?
    private var custom = CustomView()
    weak var delegate: QuestionPhotoCellDelegate?
    var baseUrl = Constants.API.Endpoints.baseImageURL
    
    private(set) var questionModel: StudyQuestion!
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
    func configure(with question: StudyQuestion, audioData: Data) {
        self.questionModel = question
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
        loadingIndicator.startAnimating()

        setupAudioPlayer(with: audioData)
                
        // Jeff
        if let img = question.image {
            self.imageQuestionView.image = img
            loadingIndicator.stopAnimating()
            loadingIndicator.isHidden = true
        }
        else if let imageUrl = URL(string: baseUrl() + question.subQuestionUrl!) {
            let task = URLSession.shared.dataTask(with: imageUrl) { [weak self] (data, response, error) in
                if let imageData = data {
                    self?.questionModel.image = UIImage(data: imageData)
                    DispatchQueue.main.async {
                        self?.delegate?.handleRefreshData()
                        self?.loadingIndicator.stopAnimating()
                        self?.loadingIndicator.isHidden = true
                    }
                } else {
                    print("Error loading image: \(error?.localizedDescription ?? "Unknown error")")
                }
            }
            task.resume()
        }
    }
    
    func configure(with question: StudyQuestion) {
        self.questionModel = question
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

        for (index, answer) in subAnswers.enumerated() {
            if answer.correctAnswer {
                correctAnswer = index
            }
        }
        
        if let selectedIndex = question.selectedAnswerIndex {
            updateAnswerButtonStates(selectedButton: answerButtons[selectedIndex])
        }
        
        loadingIndicator.startAnimating()

        if let img = question.image {
            self.imageQuestionView.image = img        
            loadingIndicator.stopAnimating()
            loadingIndicator.isHidden = true

        }
        else if let imageUrl = URL(string: baseUrl() + question.subQuestionUrl!) {
            let task = URLSession.shared.dataTask(with: imageUrl) { [weak self] (data, response, error) in
                if let imageData = data {
                    self?.questionModel.image = UIImage(data: imageData)
                    DispatchQueue.main.async {
                        self?.delegate?.handleRefreshData()
                        self?.loadingIndicator.stopAnimating()
                    }
                } else {
                    print("Error loading image: \(error?.localizedDescription ?? "Unknown error")")
                    DispatchQueue.main.async {
                        self?.loadingIndicator.stopAnimating()
                    }
                }
            }
            task.resume()
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
        if isPaused {
            audioPlayer?.play()
        } else {
            audioPlayer?.pause()
        }
        isPaused.toggle()
        let imageName = isPaused ? "resume" : "pause"
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

// MARK: Func Audio
extension QuestionPhotoCell {
    @objc func sliderValueChanged(_ sender: UISlider) {
        let seconds = sender.value
        audioPlayer?.currentTime = TimeInterval(seconds)
    }
    
    func formatTime(seconds: Float64) -> String {
        guard !seconds.isNaN, !seconds.isInfinite else {
            return "00:00"
        }

        let mins = Int(seconds / 60)
        let secs = Int(seconds.truncatingRemainder(dividingBy: 60))
        return String(format: "%02d:%02d", mins, secs)
    }
    
    func addPeriodicTimeObserver() {
        let interval = TimeInterval(1.0)
        timeObserver = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { [weak self] timer in
            guard let player = self?.audioPlayer else { return }
            let currentTime = player.currentTime
            let duration = player.duration
            
            self?.audioSlider.value = Float(currentTime)
            self?.timeRunLabel.text = self?.formatTime(seconds: currentTime)
            self?.timeRemainLabel.text = self?.formatTime(seconds: duration - currentTime)
        }
    }

    func setupAudioPlayer(with audioData: Data) {
        do {
            audioPlayer = try AVAudioPlayer(data: audioData)
            audioPlayer?.delegate = self
            audioPlayer?.prepareToPlay()
            
            audioSlider.maximumValue = Float(audioPlayer?.duration ?? 0)
            timeRemainLabel.text = formatTime(seconds: audioPlayer?.duration ?? 0)
            
            audioSlider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
            
            audioPlayer?.play()
            isPaused = false
            pauseResumeImage.image = UIImage(named: "pause")
            
            addPeriodicTimeObserver()
        } catch {
            print("Error initializing audio player: \(error.localizedDescription)")
        }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        isPaused = true
        pauseResumeImage.image = UIImage(named: "resume")
    }
}
