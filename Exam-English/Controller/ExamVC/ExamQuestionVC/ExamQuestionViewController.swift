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
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var playerView: UIView!
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
    private var currentPage = 0
    var totalQuestion = 0
    var mainSectionId = 0
    var time = 0
    var currentTimeInSeconds = 0
    var examinationId = 0
    var userName: String = ""
    private var totalPage = 1
    private var questions = [QuestionModel]()
    private var audioPlayer: AVAudioPlayer?
    private var isPaused: Bool = true
    private var timeObserver: Timer?
    private var baseAudioUrl = Constants.API.Endpoints.baseAudioURL
    private var baseImageUrl = Constants.API.Endpoints.baseImageURL
    private var imageCache = NSCache<NSString, NSData>()
    private var audioCache = NSCache<NSString, NSData>()
    private var countdownTimer: Timer?

    // MARK: - Actions
    @IBAction func submitButtonTapped(_ sender: UIButton) {
        submitALert()
    }
    
    @IBAction func checkButtonTapped(_ sender: UIButton) {}
    
    @IBAction func leftButtonTapped(_ sender: UIButton) {
        goToPreviousQuestion()
    }
    
    @IBAction func rightButtonTapped(_ sender: UIButton) {
        goToNextQuestion()
    }
    
    @IBAction func pauseResumeButtonTapped(_ sender: UIButton) {
        toggleAudioPlayback()
    }
    
    @IBAction func closeButtonTapped(_ sender: UIButton) {
        confirmALert()
    }
    
    @IBAction func listAnswerButtonTapped(_ sender: UIButton) {
        presentListQuestionViewController()
    }
}

// MARK: - Life Cycle
extension ExamQuestionViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        handleFetchQuestionExam()
        startCountdownTimer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideNavigationBar()
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
        stopAndReleaseAudioPlayer()
        showTabbar()
    }
}

// MARK: - Setup View
extension ExamQuestionViewController {
    func setupView() {
        hideNavigationBar()
        setupQuestionView()
        customView()
        modalPresentationStyle = .custom
        transitioningDelegate = self
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
        
        questionView.onAnswerSelected = { [weak self] selectedIndex in
            self?.handleAnswerSelected(at: selectedIndex)
        }
    }
    
    private func updateMainViewHeight() {
        let width = mainView.frame.width
        let totalHeight = questionView.calculateTotalHeight(constrainedToWidth: width)
        heightMainView.constant = totalHeight
        mainView.layoutIfNeeded()
    }
    
    func hideNavigationBar() {
        navigationController?.setNavigationBarHidden(true, animated: false)
//        navigationController?.interactivePopGestureRecognizer?.delegate = self
//        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    func hideTabbar() {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    func showTabbar() {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    private func handleAnswerSelected(at index: Int) {
         questions[currentPage].selectedAnswerIndex = index
     }
    
    func presentListQuestionViewController() {
        let listQuestionVC = ListQuestionViewController(nibName: "ListQuestionViewController", bundle: nil)

        listQuestionVC.modalPresentationStyle = .custom
        listQuestionVC.transitioningDelegate = self
        listQuestionVC.questions = self.questions
        present(listQuestionVC, animated: true, completion: {
        })
    }
}

// MARK: - Create UI
extension ExamQuestionViewController {
    func customView() {
        custom.customCheckButton(submitButton)
        custom.customCheckButton(checkButton)
    }
    
    func confirmALert() {
        let alert = UIAlertController(title: Constants.MessageAlert.titleConfirm, message: Constants.MessageAlert.messageConfirm, preferredStyle: .alert)
        
        if let backgroundView = alert.view.subviews.first, let groupView = backgroundView.subviews.first {
            groupView.backgroundColor = UIColor(named: Constants.Color.wrapItemColor)
        }
        
        let yesAction = UIAlertAction(title: Constants.MessageAlert.actionYesConfirm, style: .default) { action in        self.stopAndReleaseAudioPlayer()
            self.navigationController?.popViewController(animated: true)
        }
        yesAction.setValue(UIColor(named: Constants.Color.mainColor), forKey: "titleTextColor")
        
        let noAction = UIAlertAction(title: Constants.MessageAlert.actionNOConfirm, style: .cancel, handler: nil)
        noAction.setValue(UIColor.red, forKey: "titleTextColor")
        
        alert.addAction(yesAction)
        alert.addAction(noAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func submitALert() {
        let alert = UIAlertController(title: Constants.MessageAlert.titleConfirm, message: Constants.MessageAlert.messageSubmit, preferredStyle: .alert)
        
        if let backgroundView = alert.view.subviews.first, let groupView = backgroundView.subviews.first {
            groupView.backgroundColor = UIColor(named: Constants.Color.wrapItemColor)
        }
        
        let yesAction = UIAlertAction(title: Constants.MessageAlert.actionYesConfirm, style: .default) { action in        self.stopAndReleaseAudioPlayer()
            self.submitQuestion()
            self.navigationController?.popViewController(animated: true)
        }
        yesAction.setValue(UIColor(named: Constants.Color.mainColor), forKey: "titleTextColor")
        
        let noAction = UIAlertAction(title: Constants.MessageAlert.actionNOConfirm, style: .cancel, handler: nil)
        noAction.setValue(UIColor.red, forKey: "titleTextColor")
        
        alert.addAction(yesAction)
        alert.addAction(noAction)
        
        self.present(alert, animated: true, completion: nil)
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
    
    
    private func hideAudioControls() {
        playerView.isHidden = true
        audioSlider.value = 0
        timeRunLabel.text = "00:00"
        timeRemainLabel.text = "00:00"
        pauseResumeImage.image = UIImage(named: "resume")
    }
    
    private func displayFirstQuestion() {
        currentPage = 0
        displayQuestion(at: currentPage)
    }
    
    private func goToNextQuestion() {
        guard currentPage < totalQuestion else {
            return
        }
        currentPage += 1
        displayQuestion(at: currentPage)
        print(currentPage)
        
    }
    
    private func goToPreviousQuestion() {
        guard currentPage > 0 else {
            return
        }
        currentPage -= 1
        displayQuestion(at: currentPage)
        print(currentPage)
    }
    
    private func saveSelectedAnswer(for questionIndex: Int, answerIndex: Int?) {
        guard questionIndex >= 0 && questionIndex < questions.count else {
            return
        }
        
        questions[questionIndex].selectedAnswerIndex = answerIndex
    }
}

// MARK: - LoadData & Updates View
extension ExamQuestionViewController {
    private func displayQuestion(at index: Int) {
        guard index >= 0 && index < questions.count else {
            return
        }
        
        stopAndReleaseAudioPlayer()
        
        let question = questions[index]
        
        partLabel.text = "Part \(question.part ?? 0)"
        numberPartLabel.text = "\(currentPage + 1)/200"
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            guard let audioSlider = self.audioSlider else { return }
            
            questionView.questionModel = questions[index]
            self.questionView.configure(with: question, audio: audioSlider)
            
            if let selectedAnswerIndex = question.selectedAnswerIndex {
                switch selectedAnswerIndex {
                case 0:
                    self.questionView.answerButtonTapped(self.questionView.AButton ?? UIButton())
                case 1:
                    self.questionView.answerButtonTapped(self.questionView.BButton ?? UIButton())
                case 2:
                    self.questionView.answerButtonTapped(self.questionView.CButton ?? UIButton())
                case 3:
                    self.questionView.answerButtonTapped(self.questionView.DButton ?? UIButton())
                default:
                    break
                }
                } else {
                    self.questionView.resetAnswerStates()
                }
            
            self.updateMainViewHeight()
            
            if let imageUrlString = question.subQuestionUrl {
                let cacheKey = imageUrlString as NSString
                if let imageData = self.imageCache.object(forKey: cacheKey) {
                    let image = UIImage(data: imageData as Data)
                    self.questionView.imageView.image = image
                    self.questionView.imageParentView.isHidden = false
                } else {
                    if let imageUrl = URL(string: self.baseImageUrl() + imageUrlString) {
                        self.loadData(from: imageUrl) { data in
                            if let data = data {
                                DispatchQueue.main.async {
                                    self.imageCache.setObject(data as NSData, forKey: cacheKey)
                                    let image = UIImage(data: data)
                                    self.questionView.imageView.image = image
                                    self.questionView.imageParentView.isHidden = false
                                }
                            }
                        }
                    }
                }
            }
            
            if let audioUrlString = question.mainQuestionUrl {
                let cacheKey = audioUrlString as NSString
                if let audioData = self.audioCache.object(forKey: cacheKey) {
                    self.setupAudioPlayer(with: audioData as Data)
                } else {
                    if let audioUrl = URL(string: self.baseAudioUrl() + audioUrlString) {
                        self.playerView.isHidden = false
                        self.loadData(from: audioUrl) { data in
                            if let data = data {
                                DispatchQueue.main.async {
                                    self.audioCache.setObject(data as NSData, forKey: cacheKey)
                                    self.setupAudioPlayer(with: data)
                                }
                            }
                        }
                    }
                }
            } else {
                self.hideAudioControls()
                self.playerView.isHidden = true
            }
            
            self.preloadResources(for: index + 1)
        }
    }
        
    private func preloadResources(for index: Int) {
        guard index < questions.count else { return }
        
        let question = questions[index]
        
        if let imageUrlString = question.subQuestionUrl, let imageUrl = URL(string: baseImageUrl() + imageUrlString) {
            let cacheKey = imageUrlString as NSString
            if imageCache.object(forKey: cacheKey) == nil {
                loadData(from: imageUrl) { [weak self] data in
                    if let data = data {
                        self?.imageCache.setObject(data as NSData, forKey: cacheKey)
                    }
                }
            }
        }
        
        if let audioUrlString = question.mainQuestionUrl, let audioUrl = URL(string: baseAudioUrl() + audioUrlString) {
            let cacheKey = audioUrlString as NSString
            if audioCache.object(forKey: cacheKey) == nil {
                loadData(from: audioUrl) { [weak self] data in
                    if let data = data {
                        self?.audioCache.setObject(data as NSData, forKey: cacheKey)
                    }
                }
            }
        }
    }
    
    private func loadData(from url: URL, completion: @escaping (Data?) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                completion(data)
            } else {
                print("Error loading data: \(error?.localizedDescription ?? "Unknown error")")
                completion(nil)
            }
        }
        task.resume()
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
            
            DispatchQueue.main.async { [weak self] in
                self?.audioSlider.maximumValue = Float(self?.audioPlayer?.duration ?? 0)
                self?.timeRemainLabel.text = self?.formatTime(seconds: self?.audioPlayer?.duration ?? 0)
                
                self?.audioSlider.addTarget(self, action: #selector(self?.sliderValueChanged(_:)), for: .valueChanged)
                
                self?.audioPlayer?.play()
                self?.isPaused = false
                self?.pauseResumeImage.image = UIImage(named: "pause")
                
                self?.addPeriodicTimeObserver()
            }
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
    
    private func stopAndReleaseAudioPlayer() {
        audioPlayer?.stop()
        audioPlayer = nil
    }
}

// MARK: - Func Coundownt Time
extension ExamQuestionViewController {
    func startCountdownTimer() {
        let totalTimeInSeconds = convertMinutesToSeconds(minutes: time)
        currentTimeInSeconds = totalTimeInSeconds
        updateCountdownLabel()
        
        if totalTimeInSeconds > 0 {
            countdownTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        } else {
            endCountdown()
        }
    }
    
    @objc func updateTimer() {
        if currentTimeInSeconds > 0 {
            currentTimeInSeconds -= 1
            updateCountdownLabel()
        } else {
            endCountdown()
        }
    }
    
    func endCountdown() {
        countdownTimer?.invalidate()
        timeLabel.text = "Time Out"
    }
    
    func updateCountdownLabel() {
        let mins = currentTimeInSeconds / 60
        let secs = currentTimeInSeconds % 60
        timeLabel.text = String(format: "%02d:%02d", mins, secs)
    }
    
    func convertMinutesToSeconds(minutes: Int) -> Int {
        return minutes * 60
    }
}

// MARK: - Handle API
extension ExamQuestionViewController {
    func handleFetchQuestionExam() {
        ExamService.shared.fetchQuestionExam(mainSectionId: mainSectionId, pageSize: totalQuestion, page: totalPage) { [weak self] result in
            switch result {
            case . success(let questionExamResponse):
                if let questions = questionExamResponse.result, let paginations = questionExamResponse.pagination {
                    DispatchQueue.main.async {
                        self?.questions = questions
                        self?.displayFirstQuestion()
                    }
                }
            case . failure(let error):
                Logger.shared.logError(Loggers.StudyMessages.errorFetchQuestion + "\(error)")

            }
        }
    }
    
    func collectSelectedAnswers() -> [AnswerSubmit] {
        var answers: [AnswerSubmit] = []
        
        for question in questions {
            let mainQuestionId = question.mainQuestionID ?? 0
            
            let normalQuestionId: Int?
            if let normalId = question.normalQuestionID, normalId != 0 {
                normalQuestionId = normalId
            } else {
                normalQuestionId = nil
            }
            
            let subQuestionId = question.subQuestionID ?? 0
            
            let answerContent: String?
            if let selectedIndex = question.selectedAnswerIndex {
                answerContent = "\(selectedIndex + 1)"
            } else {
                answerContent = nil
            }
            
            let answer = AnswerSubmit(mainQuestionId: mainQuestionId,
                                      normalQuestionId: normalQuestionId,
                                      subQuestionId: subQuestionId,
                                      answerContent: answerContent)
            
            answers.append(answer)
        }
        return answers
    }
    
    func submitQuestion() {
        let info = Info(examinationId: examinationId, mainSectionId: mainSectionId, userName: userName)
        let answers = collectSelectedAnswers()
        ExamService.shared.submitExam(info: info, answers: answers) { result in
            switch result {
            case .success(let response):
                print("Submit exam successful with response: \(response)")
                
            case .failure(let error):
                print("Error submitting exam: \(error.localizedDescription)")
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

class SlideUpTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    let isPresenting: Bool

    init(isPresenting: Bool) {
        self.isPresenting = isPresenting
        super.init()
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toViewController = transitionContext.viewController(forKey: .to),
              let fromViewController = transitionContext.viewController(forKey: .from) else {
            return
        }

        let containerView = transitionContext.containerView

        if isPresenting {
            containerView.addSubview(toViewController.view)
            toViewController.view.frame = CGRect(x: 0, y: containerView.bounds.height, width: containerView.bounds.width, height: containerView.bounds.height * 0.5)

            UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
                toViewController.view.frame = CGRect(x: 0, y: containerView.bounds.height * 0.5, width: containerView.bounds.width, height: containerView.bounds.height * 0.5)
            }, completion: { finished in
                transitionContext.completeTransition(finished)
            })
        } else {
            UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
                fromViewController.view.frame = CGRect(x: 0, y: containerView.bounds.height, width: containerView.bounds.width, height: containerView.bounds.height * 0.5)
            }, completion: { finished in
                fromViewController.view.removeFromSuperview()
                transitionContext.completeTransition(finished)
            })
        }
    }


}

class SlideUpPresentationController: UIPresentationController {
    private var dimmingView: UIView!

    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        setupDimmingView()
    }

    private func setupDimmingView() {
        dimmingView = UIView()
        dimmingView.backgroundColor = UIColor(white: 0.0, alpha: 0.5)
        dimmingView.alpha = 0.0

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dimmingViewTapped))
        dimmingView.addGestureRecognizer(tapGesture)
    }

    @objc private func dimmingViewTapped() {
        presentedViewController.dismiss(animated: true, completion: nil)
    }

    override func presentationTransitionWillBegin() {
        guard let containerView = containerView else {
            return
        }

        dimmingView.frame = containerView.bounds
        containerView.addSubview(dimmingView)

        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { [weak self] _ in
            self?.dimmingView.alpha = 1.0
        }, completion: nil)
    }

    override func dismissalTransitionWillBegin() {
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { [weak self] _ in
            self?.dimmingView.alpha = 0.0
        }, completion: { [weak self] _ in
            self?.dimmingView.removeFromSuperview()
        })
    }

    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        presentedView?.frame = frameOfPresentedViewInContainerView
    }

    override var frameOfPresentedViewInContainerView: CGRect {
        guard let containerView = containerView else {
            return CGRect.zero
        }

        let heightPercentage: CGFloat = 0.7
        let height: CGFloat = containerView.bounds.height * heightPercentage
        let y = containerView.bounds.height - height
        return CGRect(x: 0, y: y, width: containerView.bounds.width, height: height)
    }
}

extension ExamQuestionViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return SlideUpPresentationController(presentedViewController: presented, presenting: presenting)
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return SlideUpTransitionAnimator(isPresenting: true)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return SlideUpTransitionAnimator(isPresenting: false)
    }
}


