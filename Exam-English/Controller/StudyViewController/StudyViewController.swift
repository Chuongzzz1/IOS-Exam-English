//
//  StudyViewController.swift
//  Exam-English
//
//  Created by Trần Văn Chương on 02/05/2024.
//

import UIKit

class StudyViewController: UIViewController {
    // MARK: - Outlet
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Variable
    private var studyCates = [Study]()
    private var fruits = [FruitModel]()
}

// MARK: - Life Cycle
extension StudyViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        fruits = LoadData.share.loadData() ?? [FruitModel]()
    }
}

// MARK: - DataSource
extension StudyViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StudyViewSection", for: indexPath) as! StudyViewSection
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }
        let headerSectionView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HeaderStudySection", for: indexPath) as! HeaderStudySection
        return headerSectionView
    }
}

// MARK: - Delegate
extension StudyViewController: UICollectionViewDelegate {
    
}

// MARK: - Flowlayout Delegate
extension StudyViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.bounds.size.width
        let height: CGFloat = 200
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let sectionInsets = UIEdgeInsets(top: 24, left: 0, bottom: 24, right: 0)
        return sectionInsets
    }
}

// MARK: - Func
extension StudyViewController {
    
    func registerSection() {
        let studySectionNib = UINib(nibName: "StudyViewSection", bundle: .main)
        collectionView.register(studySectionNib, forCellWithReuseIdentifier: "StudyViewSection")
    }
    
    func registerHeaderSection() {
        let headerSectionNib = UINib(nibName: "HeaderStudySection", bundle: .main)
        collectionView.register(headerSectionNib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HeaderStudySection")
    }
    
    func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        registerSection()
        registerHeaderSection()
        hideScrollBar()
    }
    
    func hideScrollBar() {
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
    }
}
