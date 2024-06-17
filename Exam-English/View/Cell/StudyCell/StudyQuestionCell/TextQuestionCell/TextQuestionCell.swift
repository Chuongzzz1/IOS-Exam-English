//
//  TextQuestionCell.swift
//  Exam-English
//
//  Created by Trần Văn Chương on 26/05/2024.
//

import UIKit
import AVFoundation

protocol TextQuestionCellDelegate: AnyObject {
    func handleScrollNext(sender: UIButton)
    func handleScrollPrevious(sender: UIButton)
}
class TextQuestionCell: UICollectionViewCell {
    // MARK: - Outlet
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var questionBackgroundView: UIView!
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
    private var player: AVPlayer?
    private var timeObserver: Any?
    private var custom = CustomView()
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
    func configure(with question: StudyQuestion, audioData: Data) {
        resetUI()
        guard let subAnswers = question.answers else { return }
//        questionLabel.text = question.subQuestionContent
        questionLabel.attributedText = question.subQuestionContent?.htmlToAttributedString

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
        setupAudioPlayer(with: audioData)
    }
    
    func configure(with question: StudyQuestion) {
        resetUI()
        guard let subAnswers = question.answers else { return }
        questionLabel.attributedText = question.subQuestionContent?.htmlToAttributedString

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
        questionLabel.adjustsFontSizeToFitWidth = true
        questionLabel.minimumScaleFactor = 0.5
    }
    
    func customView() {
        custom.customCheckButton(checkButton)
        custom.labelQuestion(nameBackground: questionBackgroundView)
    }
}

// MARK: Func Audio
extension TextQuestionCell {
    @objc func sliderValueChanged(_ sender: UISlider) {
        let seconds = sender.value
        let targetTime = CMTime(seconds: Double(seconds), preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        player?.seek(to: targetTime)
    }
    
    func addPeriodicTimeObserver() {
        let interval = CMTime(seconds: 1, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        timeObserver = player?.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main) { [weak self] time in
            let seconds = CMTimeGetSeconds(time)
            self?.audioSlider.value = Float(seconds)
            self?.timeRunLabel.text = self?.formatTime(seconds: seconds)
            
            if let duration = self?.player?.currentItem?.duration {
                let durationSeconds = CMTimeGetSeconds(duration)
                self?.timeRemainLabel.text = self?.formatTime(seconds: durationSeconds - seconds)
            }
        }
    }
    
    func formatTime(seconds: Float64) -> String {
        guard !seconds.isNaN, !seconds.isInfinite else {
            return "00:00"
        }

        let mins = Int(seconds / 60)
        let secs = Int(seconds.truncatingRemainder(dividingBy: 60))
        return String(format: "%02d:%02d", mins, secs)
    }
    
    func setupAudioPlayer(with audioData: Data) {
        guard let tempFileURL = saveAudioDataToFile(data: audioData) else {
            Logger.shared.logError(Loggers.AudioMessages.errorSaved)
            return
        }
//        print("Temp file URL: \(tempFileURL)")

        player = AVPlayer(url: tempFileURL)
        addPeriodicTimeObserver()

        audioSlider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)

        if let duration = player?.currentItem?.asset.duration, !duration.isIndefinite {
            let seconds = CMTimeGetSeconds(duration)
            audioSlider.maximumValue = Float(seconds)
            timeRemainLabel.text = formatTime(seconds: seconds)
        }

        player?.play()
        isPaused = false
        pauseResumeImage.image = UIImage(named: "pause")

//        print("AVPlayer created successfully")
    }
    
    func saveAudioDataToFile(data: Data) -> URL? {
        let tempFileURL = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString + Constants.DefaultString.audioTail)
        do {
            try data.write(to: tempFileURL)
//            print("Audio saved to: \(tempFileURL)")
            return tempFileURL
        } catch {
            Logger.shared.logError(Loggers.AudioMessages.errorWrited + "\(error)")
            return nil
        }
    }
}

