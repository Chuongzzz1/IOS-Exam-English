//
//  StudyQuestionViewController.swift
//  Exam-English
//
//  Created by Trần Văn Chương on 13/05/2024.
//

import UIKit

class StudyQuestionViewController: UIViewController, QuestionPhotoCellDelegate, ListQuestionWithTextCellDelegate, TextQuestionCellDelegate, ListQuestionWithPhotoCellDelegate {
    func handleScrollNext(sender: UIButton) {
        scrollNextToCell()
    }
    
    func handleScrollPrevious(sender: UIButton) {
        scrollToPreviousCell()
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
}

// MARK: - Life Cycle
extension StudyQuestionViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
    }
}

// MARK: -  DataSource
extension StudyQuestionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return questions.count
        return currentQuestion.count

    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let question = questions[indexPath.item]
        let question = currentQuestion[0]

        // Kiểm tra nếu có nội dung chính và liên kết hình ảnh, sử dụng PhotoQuestionCell
        if let mainUrl = question.mainQuestionUrl, let subUrl = question.subQuestionUrl {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "QuestionPhotoCell", for: indexPath) as? QuestionPhotoCell {
                cell.delegate = self
                cell.configure(with: question)
                return cell
            }
        } else if let normalContent = question.normalQuestionContent {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ListQuestionWithTextCell", for: indexPath) as? ListQuestionWithTextCell {
                cell.delegate = self
                cell.configure(with: question)
                return cell
            }
        } else if let mainContent = question.mainQuestionContent, question.subQuestionUrl == nil {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TextQuestionCell", for: indexPath) as? TextQuestionCell {
                cell.delegate = self
                cell.configure(with: question)
                return cell
            }
        } else {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ListQuestionWithPhotoCell", for: indexPath) as? ListQuestionWithPhotoCell {
                cell.delegate = self
                cell.configure(with: question)
                return cell
            }
        }
        // Nếu không thỏa mãn các điều kiện trên, trả về UICollectionViewCell mặc định
        return UICollectionViewCell()   
    }
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
    
    func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        setupFlowlayout()
        registerCell()
        handleScroll()
    }
}

// MARK: - Func
extension StudyQuestionViewController {
    @objc func scrollNextToCell() {
        currentIndex += 1
        if currentIndex >= questions.count {
            currentIndex = questions.count - 1
        }
        let newQuestion = questions[currentIndex]
        self.currentQuestion.removeAll()
        self.currentQuestion.append(newQuestion)
        self.collectionView.reloadData()
        print("Updating current cell with new question at index \(currentIndex)")
        //        updateCurrentCell(with: newQuestion)
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
        print("Updating current cell with new question at index \(currentIndex)")
//        updateCurrentCell(with: newQuestion)
    }
    
    func updateCurrentCell(with question: StudyQuestion) {
        //        collectionView.scrollTo  Item(at: IndexPath(item: currentIndex, section: 0), at: .centeredHorizontally, animated: true)
        //        collectionView.reloadData()
        let indexPath = IndexPath(item: 0, section: 0)
        
        if let currentCell = collectionView.cellForItem(at: indexPath) as? ListQuestionWithTextCell {
            currentCell.configure(with: question)
            collectionView.reloadItems(at: [indexPath])
        }
        
        if let currentCell = collectionView.cellForItem(at: indexPath) as? TextQuestionCell {
            currentCell.configure(with: question)
            collectionView.reloadItems(at: [indexPath])
        }
        
        if let currentCell = collectionView.cellForItem(at: indexPath) as? ListQuestionWithPhotoCell {
            currentCell.configure(with: question)
            collectionView.reloadItems(at: [indexPath])
        }
        
        if let currentCell = collectionView.cellForItem(at: indexPath) as? QuestionPhotoCell {
            currentCell.configure(with: question)
            collectionView.reloadItems(at: [indexPath])
        }
    }
}


