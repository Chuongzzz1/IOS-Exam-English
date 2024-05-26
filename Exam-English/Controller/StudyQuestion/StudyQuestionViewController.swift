//
//  StudyQuestionViewController.swift
//  Exam-English
//
//  Created by Trần Văn Chương on 13/05/2024.
//

import UIKit

class StudyQuestionViewController: UIViewController, QuestionPhotoCellDelegate, ListQuestionWithTextCellDelegate, TextQuestionCellDelegate {
    func handleScrollNext(sender: UIButton) {
        scrollNextToCell()
    }
    
    func handleScrollPrevious(sender: UIButton) {
        scrollToPreviousCell()
    }
    
    // MARK: - Outlet
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Variable
    var questions = [StudyQuestion]()
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
        return questions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TextQuestionCell", for: indexPath) as? TextQuestionCell {
            cell.delegate = self
            let question = questions[indexPath.item]
            cell.configure(with: question)
            return cell
            
        } else {
            return QuestionPhotoCell()
        }
    }
}

// MARK: - Delegate
extension StudyQuestionViewController: UICollectionViewDelegate {
    
}

// MARK: - Flowlayout
extension StudyQuestionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
}

// MARK: - Func
extension StudyQuestionViewController {
    func registerCell() {
        let questionPhotoNib = UINib(nibName: "QuestionPhotoCell", bundle: nil)
        collectionView.register(questionPhotoNib, forCellWithReuseIdentifier: "QuestionPhotoCell")
        let questionListTextNib = UINib(nibName: "ListQuestionWithTextCell", bundle: nil)
        collectionView.register(questionListTextNib, forCellWithReuseIdentifier: "ListQuestionWithTextCell")
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
        collectionView.isPagingEnabled = true
        collectionView.isScrollEnabled = true
    }
    
    func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        setupFlowlayout()
        registerCell()
        handleScroll()
    }
    
    @objc func scrollNextToCell() {
        currentIndex += 1
        if currentIndex >= questions.count {
            currentIndex = questions.count - 1
        }
        let newQuestion = questions[currentIndex]
        print("Updating current cell with new question at index \(currentIndex)")
        updateCurrentCell(with: newQuestion)
    }
    
    @objc func scrollToPreviousCell() {
        currentIndex -= 1
        if currentIndex < 0 {
            currentIndex = 0
        }
        let newQuestion = questions[currentIndex]
        print("Updating current cell with new question at index \(currentIndex)")
        updateCurrentCell(with: newQuestion)
    }
    
    func updateCurrentCell(with question: StudyQuestion) {
        if let cell = self.collectionView.cellForItem(at: IndexPath(item: currentIndex, section: 0)) as? QuestionPhotoCell {
            cell.configure(with: question)
        }
        collectionView.reloadData()
    }
}
