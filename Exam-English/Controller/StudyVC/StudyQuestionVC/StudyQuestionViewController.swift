//
//  StudyQuestionViewController.swift
//  Exam-English
//
//  Created by Trần Văn Chương on 13/05/2024.
//

import UIKit
enum QuestionType {
    case questionPhoto(mainUrl: String?, subUrl: String?)
    case listQuestionWithText(normalContent: String?)
    case textQuestion(mainContent: String?)
    case listQuestionWithPhoto(subQuestionContent: String?)
    case unknown
    
    init(question: StudyQuestion) {
        if question.mainQuestionUrl == nil && question.subQuestionUrl == nil && question.subQuestionContent != nil {
            self = .listQuestionWithText(normalContent: question.subQuestionContent)
        } else if let mainUrl = question.mainQuestionUrl, let subUrl = question.subQuestionUrl {
            self = .questionPhoto(mainUrl: mainUrl, subUrl: subUrl)
        } else if let normalContent = question.normalQuestionContent {
            self = .listQuestionWithText(normalContent: normalContent)
        } else if let mainContent = question.mainQuestionContent, question.subQuestionUrl == nil {
            self = .textQuestion(mainContent: mainContent)
        } else if let subQuestionContent = question.subQuestionContent, question.subQuestionUrl != nil {
            self = .listQuestionWithPhoto(subQuestionContent: subQuestionContent)
        } else {
            self = .unknown
        }
    }
}

class StudyQuestionViewController: UIViewController, QuestionPhotoCellDelegate, ListQuestionWithTextCellDelegate, TextQuestionCellDelegate, ListQuestionWithPhotoCellDelegate {
    func handleScrollNext(sender: UIButton) {
        scrollNextToCell()
    }
    
    func handleScrollPrevious(sender: UIButton) {
        scrollToPreviousCell()
    }
    
    func handleRefreshData() {
        // Jeff
        self.collectionView.reloadData()
        // At this step, debug to check if currentQuestion.image != nil
    }
    
    // MARK: - Outlet
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Variable
   var questions = [StudyQuestion]() {
        didSet {
            currentQuestion.removeAll()
            if !questions.isEmpty {
                currentQuestion.append(questions.first!)
            }
            if self.isViewLoaded,
               self.collectionView != nil {
               self.collectionView.reloadData()
            }
        }
    }
    private var currentQuestion = [StudyQuestion]()
    private var currentIndex = 0
    private var currentPage = 1
    private var totalpage = 0
    var subSectionID = 0
    var audioData: Data?
}

// MARK: - Life Cycle
extension StudyQuestionViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        callFunc()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideTabbar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        showTabbar()
    }

}

// MARK: -  DataSource
extension StudyQuestionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return questions.count
        return currentQuestion.count

    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let question = currentQuestion[0]
        let questionType = QuestionType(question: question)

        switch questionType {
        case .questionPhoto(let mainUrl, let subUrl):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "QuestionPhotoCell", for: indexPath) as! QuestionPhotoCell
            cell.delegate = self
            cell.configure(with: question)
            return cell

        case .listQuestionWithText(let normalContent):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ListQuestionWithTextCell", for: indexPath) as! ListQuestionWithTextCell
            cell.delegate = self
            cell.configure(with: question)
            return cell

        case .textQuestion(let mainContent):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TextQuestionCell", for: indexPath) as! TextQuestionCell
            cell.delegate = self
            cell.configure(with: question)
            return cell

        case .listQuestionWithPhoto(let subQuestionContent):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ListQuestionWithPhotoCell", for: indexPath) as! ListQuestionWithPhotoCell
            cell.delegate = self
            cell.configure(with: question)
            return cell

        case .unknown:
            return UICollectionViewCell()
        }    }
}

// MARK: - Delegate
extension StudyQuestionViewController: UICollectionViewDelegate {}

// MARK: - Flowlayout
extension StudyQuestionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
}

// MARK: - SetupView
extension StudyQuestionViewController {
    func registerCell() {
        let questionPhotoNib = UINib(nibName: "QuestionPhotoCell", bundle: nil)
        collectionView.register(questionPhotoNib, forCellWithReuseIdentifier: "QuestionPhotoCell")
        let questionListTextNib = UINib(nibName: "ListQuestionWithTextCell", bundle: nil)
        collectionView.register(questionListTextNib, forCellWithReuseIdentifier: "ListQuestionWithTextCell")
        let questionListPhotoNib = UINib(nibName: "ListQuestionWithPhotoCell", bundle: nil)
        collectionView.register(questionListPhotoNib, forCellWithReuseIdentifier: "ListQuestionWithPhotoCell")
        let questionTextNib = UINib(nibName: "TextQuestionCell", bundle: nil)
        collectionView.register(questionTextNib, forCellWithReuseIdentifier: "TextQuestionCell")
    }
    
    func setupFlowlayout() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        collectionView.collectionViewLayout = layout
    }
    
    func handleScroll() {
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = false
        collectionView.isScrollEnabled = false
    }
    
    func hideUITabbar() {
        hidesBottomBarWhenPushed = true
    }
    
    func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        setupFlowlayout()
        hideUITabbar()
        registerCell()
        handleScroll()
    }
}

// MARK: - Func
extension StudyQuestionViewController {
    func callFunc() {
        handleQuestion(subSectionID: subSectionID, page: currentPage)
    }
    
    @objc func scrollNextToCell() {
        currentIndex += 1
        if currentIndex >= questions.count {
            currentIndex = questions.count - 1
        }
        let newQuestion = questions[currentIndex]
        let countQuestion = questions.count - 1
        self.currentQuestion.removeAll()
        self.currentQuestion.append(newQuestion)
        if countQuestion == currentIndex {
            loadMoreQuestion(subSectionID: subSectionID, page: currentPage)
        }
        self.collectionView.reloadData()
        print("DEBUG: Updating current cell with new question at index \(currentIndex)")
    }
    
    @objc func scrollToPreviousCell() {
        currentIndex -= 1
        if currentIndex < 0 {
            currentIndex = 0
        }
        let newQuestion = questions[currentIndex]
        self.currentQuestion.removeAll()
        self.currentQuestion.append(newQuestion)
        self.collectionView.reloadData()
        print("DEBUG: Updating current cell with new question at index \(currentIndex)")
    }
    
    func hideTabbar() {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    func showTabbar() {
        self.tabBarController?.tabBar.isHidden = false
    }
}

// MARK: - API
extension StudyQuestionViewController {
    func loadMoreQuestion(subSectionID: Int,page: Int) {
        guard page <= totalpage else {
            print("DEBUG: No more pages to load")
            return
        }
        StudyService.shared.fetchQuestion(for: subSectionID, page: page) { [weak self] result in
            switch result {
            case .success(let studyQuestionResponse):
                if let questions = studyQuestionResponse.result {
                    DispatchQueue.main.async {
                        self?.questions.append(contentsOf: questions)
                        self?.currentPage += 1
                        self?.collectionView.reloadData()
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    Logger.shared.logError(Loggers.StudyMessages.errorLoadmoreQuestion + "\(error)")
                }
            }
        }
    }
    
    func handleQuestion(subSectionID: Int,page: Int) {
        StudyService.shared.fetchQuestion(for: subSectionID, page: page) { [weak self] result in
            switch result {
            case .success(let studyQuestionResponse):
                if let questions = studyQuestionResponse.result, let paginates = studyQuestionResponse.pagination {
                    DispatchQueue.main.async {
                        self?.questions = questions
                        self?.totalpage = paginates.totalPage
                        self?.subSectionID = subSectionID
                        self?.currentPage += 1
//                        if let firstQuestion = questions.first, let mainQuestionUrl = firstQuestion.mainQuestionUrl {
//                            self?.handleAudio(mainQuestionURL: mainQuestionUrl)
//                        }
                        self?.collectionView.reloadData()
                    }
                }
            case .failure(let error):
                Logger.shared.logError(Loggers.StudyMessages.errorFetchQuestion + "\(error)")
            }
        }
    }
    
    func handleAudio(mainQuestionURL: String) {
        StudyService.shared.fetchAudio(mainQuestionURL: mainQuestionURL) { [weak self] result in
            switch result {
            case .success(let audioData):
                self?.audioData = audioData
            case .failure(let error):
                Logger.shared.logError(Loggers.StudyMessages.errorFetchAudio + "\(error.localizedDescription)")
            }
        }
    }
}
