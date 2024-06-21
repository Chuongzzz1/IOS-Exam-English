//
//  ExamQuestionViewController.swift
//  Exam-English
//
//  Created by Trần Văn Chương on 18/06/2024.
//

import UIKit
import AVFoundation

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
    @IBOutlet weak var heightMainView: NSLayoutConstraint!
    
    // MARK: - Variable
    private var custom = CustomView()
    private var questionView: QuestionView!
    private var currentPage = 1
    private var totalpage = 0
    private var questions = [QuestionModel]()
    private var audioPlayer: AVAudioPlayer?
    private var isPaused: Bool = true
    private var timeObserver: Timer?
    private var baseAudioUrl = Constants.API.Endpoints.baseAudioURL

    // MARK: - Actions
    @IBAction func submitButtonTapped(_ sender: UIButton) {
        // Implement submit button action if needed
    }
    
    @IBAction func checkButtonTapped(_ sender: UIButton) {
        // Implement check button action if needed
    }
    
    @IBAction func leftButtonTapped(_ sender: UIButton) {
        goToPreviousQuestion()
    }
    
    @IBAction func rightButtonTapped(_ sender: UIButton) {
        goToNextQuestion()
    }
    
    @IBAction func pauseResumeButtonTapped(_ sender: UIButton) {
        toggleAudioPlayback()
    }
}

// MARK: - Life Cycle
extension ExamQuestionViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        handleFetchQuestionExam()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        hideTabbar()
//        updateMainViewHeight()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateMainViewHeight()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        showTabbar()
    }
}

// MARK: - Setup View
extension ExamQuestionViewController {
    func setupView() {
        hideNavigationBar()
        setupQuestionView()
        customView()
    }
    
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
        
//        questionView.callback = { [weak self] audioData, isNext in
//            if let audioData = audioData {
//                self?.setupAudioPlayer(with: audioData)
//            } else if let isNext = isNext {
//                if isNext {
//                    self?.goToNextQuestion()
//                } else {
//                    self?.goToPreviousQuestion()
//                }
//            }
//        }
    }
    
    private func updateMainViewHeight() {
        let width = mainView.frame.width
        let totalHeight = questionView.calculateTotalHeight(constrainedToWidth: width)
        heightMainView.constant = totalHeight
        mainView.layoutIfNeeded()
    }
    
    func customView() {
        custom.customCheckButton(submitButton)
        custom.customCheckButton(checkButton)
    }
    
    func hideNavigationBar() {
        navigationController?.setNavigationBarHidden(true, animated: false)
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    func hideTabbar() {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    func showTabbar() {
        self.tabBarController?.tabBar.isHidden = false
    }
}

// MARK: - Func
extension ExamQuestionViewController {
    static func getTextBoundSize(_ text: String?, font: UIFont, constrainedToWidth width: CGFloat, minimumHeight minHeight: CGFloat = 10, paragraph: NSMutableParagraphStyle? = nil) -> CGSize {
            if text == nil || text!.isEmpty {
                return CGSize(width: width, height: minHeight)
            }
            
            var para = paragraph
            if paragraph == nil {
                para = NSMutableParagraphStyle()
                para!.alignment = .left
            }
            
            let attributedText: NSAttributedString = NSAttributedString(string: text!, attributes: [NSAttributedString.Key.font:font, NSAttributedString.Key.paragraphStyle: para!])
            
            let rect : CGRect = attributedText.boundingRect(with: CGSize(width: width, height: CGFloat.greatestFiniteMagnitude), options: .usesLineFragmentOrigin, context: nil)
            var height = rect.height.rounded(.up)
            height = height < minHeight ? minHeight : height
            
            return CGSize(width: rect.width, height: height)
        }
    
    private func displayQuestion(at index: Int) {
        guard index >= 0 && index < questions.count else {
            return
        }
        
        let question = questions[index]
        questionView.configure(with: question, audio: audioSlider)
        updateMainViewHeight()

        if let audioUrlString = question.mainQuestionUrl, let audioUrl = URL(string: baseAudioUrl() + audioUrlString) {
            print("Fetching audio from URL: \(audioUrl.absoluteString)")
            loadAudio(from: audioUrl) { [weak self] audioData in
                guard let audioData = audioData else { return }
                DispatchQueue.main.async {
                    self?.audioSlider.isHidden = false
                    self?.setupAudioPlayer(with: audioData)
                }
            }
        }
    }
    
    private func displayFirstQuestion() {
        currentPage = 0
        displayQuestion(at: currentPage)
    }
    
    private func goToNextQuestion() {
        guard currentPage < totalpage else {
            return
        }
        currentPage += 1
        let nextQuestion = questions[currentPage + 1] // Arrays are zero-indexed
        questionView.configure(with: nextQuestion, audio: audioSlider)
        print(currentPage)
        updateMainViewHeight()
    }
    
    private func goToPreviousQuestion() {
        guard currentPage > 1 else {
            return
        }
        currentPage -= 1
        let previousQuestion = questions[currentPage - 1] // Arrays are zero-indexed
        questionView.configure(with: previousQuestion, audio: audioSlider)
        print(currentPage)
        updateMainViewHeight()
    }
}

// MARK: - Handle API
extension ExamQuestionViewController {
    func handleFetchQuestionExam() {
        ExamService.shared.fetchQuestionExam(pageSize: 10, page: 16) { [weak self] result in
            switch result {
            case . success(let questionExamResponse):
                if let questions = questionExamResponse.result, let paginations = questionExamResponse.pagination {
                    DispatchQueue.main.async {
                        self?.questions = questions
                        self?.totalpage = paginations.totalPage
                        self?.displayFirstQuestion()
                    }
                }
            case . failure(let error):
                Logger.shared.logError(Loggers.StudyMessages.errorFetchQuestion + "\(error)")

            }
        }
    }
}

// MARK: - UIGestureRecognizerDelegate
extension ExamQuestionViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

// MARK: - Func Audio
extension ExamQuestionViewController: AVAudioPlayerDelegate {
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
    
    func toggleAudioPlayback() {
        guard let player = audioPlayer else { return }
        
        if isPaused {
            player.play()
            isPaused = false
            pauseResumeImage.image = UIImage(named: "pause")
        } else {
            player.pause()
            isPaused = true
            pauseResumeImage.image = UIImage(named: "resume")
        }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        isPaused = true
        pauseResumeImage.image = UIImage(named: "resume")
    }
    
    private func loadAudio(from url: URL, completion: @escaping (Data?) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                completion(data)
            } else {
                print("Error loading audio: \(error?.localizedDescription ?? "Unknown error")")
                completion(nil)
            }
        }
        task.resume()
    }
}

