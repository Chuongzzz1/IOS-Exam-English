//
//  StudyViewSection.swift
//  Exam-English
//
//  Created by Trần Văn Chương on 06/05/2024.
//

import UIKit

class StudyViewSection: UICollectionViewCell {
    // MARK: - OutLet
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Variable
    private var studyCates = [Study]()
    private var fruits = [FruitModel]()


}

// MARK: - Awake Nib
extension StudyViewSection {
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCollectionView()
        fruits = LoadData.share.loadData() ?? [FruitModel]()
    }
}

// MARK: - DataSource
extension StudyViewSection: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fruits.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StudyViewCell", for: indexPath) as? StudyViewCell {
            let studyCates = fruits[indexPath.item]
            cell.updatesView(study: studyCates)
            return cell
        } else {
            return StudyViewCell()
        }
    }
}

// MARK: - Delegate
extension StudyViewSection: UICollectionViewDelegate {
    
}

// MARK: - FlowLayout Delegate
extension StudyViewSection: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // lấy chiều rộng màn hình
        let screenWidth = collectionView.bounds.size.width
        let numberOfColumns: CGFloat = 3
        let numberOfRows: CGFloat = 1
        // Tính toán kích thước của mỗi item
        let totalHorizontalSpacing: CGFloat = 0
        let totalVerticalSpacing: CGFloat = 12
        let itemWidth = (screenWidth - totalHorizontalSpacing) / numberOfColumns
        let itemHeight = (collectionView.bounds.height - totalVerticalSpacing) / numberOfRows
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
    }
    
    func setupFlowLayout() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        collectionView.collectionViewLayout = layout
    }
    
    func hideScrollBar() {
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
    }
}
