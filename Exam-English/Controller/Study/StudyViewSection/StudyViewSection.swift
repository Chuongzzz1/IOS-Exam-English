//
//  StudyViewSection.swift
//  Exam-English
//
//  Created by Trần Văn Chương on 06/05/2024.
//

import UIKit

protocol StudyViewSectionDelegate: AnyObject {
    func didSelectItem(mainSections: [StudyMainSection])
    func handleMainSection(categoryID: Int)
}

class StudyViewSection: UICollectionViewCell {
    // MARK: - OutLet
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Variable
    var categories = [StudyCategory]() {
        didSet {
            collectionView.reloadData()
        }
    }
//    var mainSectionDict = [Int: [StudyMainSection]]()
//    var mainSections = [StudyMainSection]()
    weak var delegate: StudyViewSectionDelegate?
}

// MARK: - Awake Nib
extension StudyViewSection {
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCollectionView()
    }
}

// MARK: - DataSource
extension StudyViewSection: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StudyViewCell", for: indexPath) as? StudyViewCell {
            let studyCategories = categories[indexPath.item]
            cell.updatesView(study: studyCategories)
            return cell
        } else {
            return StudyViewCell()
        }
    }
}

// MARK: - Delegate
extension StudyViewSection: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let categoryID = categories[indexPath.row].categoryID
//        delegate?.didSelectItem(mainSections: mainSectionDict[categoryID] ?? [])
        delegate?.handleMainSection(categoryID: categoryID)
    }
}

// MARK: - FlowLayout Delegate
extension StudyViewSection: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = collectionView.bounds.size.width
        let numberOfColumns: CGFloat = 3
//        let numberOfRows: CGFloat = 1
        let totalHorizontalSpacing: CGFloat = 12
//        let totalVerticalSpacing: CGFloat = 12
        let itemWidth = (screenWidth - totalHorizontalSpacing) / numberOfColumns
        let itemHeight = itemWidth
            return CGSize(width: floor(itemWidth), height: itemHeight)
    }
}

// MARK: - Func
extension StudyViewSection {
    func registerCell() {
        let studyCellNib = UINib(nibName: "StudyViewCell", bundle: .main)
        collectionView.register(studyCellNib, forCellWithReuseIdentifier: "StudyViewCell")
    }
    
    func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        registerCell()
        hideScrollBar()
        setupFlowLayout()
    }
    
    func setupFlowLayout() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 12
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
        collectionView.collectionViewLayout = layout
    }
    
    func hideScrollBar() {
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
    }
    

}
