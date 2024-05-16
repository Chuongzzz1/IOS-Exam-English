//
//  StudyViewController.swift
//  Exam-English
//
//  Created by Trần Văn Chương on 02/05/2024.
//

import UIKit

class StudyViewController: UIViewController, StudyViewSectionDelegate {
    func didSelectItem() {
             let studyVC = StudyDetailViewController(nibName: "StudyDetailViewController", bundle: nil)
             self.navigationController?.pushViewController(studyVC, animated: true)
        }
    
    // MARK: - Outlet
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Variable
    private var subjects = [StudySubject]()
    private var subjectCategoriesDict = [Int: [StudyCategory]]()
    private var categories = [StudyCategory]()
    private let studyService = StudyService.shared
}

// MARK: - Life Cycle
extension StudyViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        handleAPI()
    }
}

// MARK: - DataSource
extension StudyViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return subjects.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let subject = subjects[section]
        if let categories = subjectCategoriesDict[subject.subjectID] {
            return categories.count // Add 1 for the subject cell
        } else {
            return 1 // Only the subject cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StudyViewSection", for: indexPath) as! StudyViewSection
        let subject = subjects[indexPath.section] // Lấy môn học ứng với section
        if let categories = subjectCategoriesDict[subject.subjectID] {
            // Truyền danh mục tương ứng với môn học vào cell
            cell.categories = categories
        } else {
            // Nếu không có danh mục nào cho môn học này, gán một mảng rỗng cho thuộc tính categories của cell
            cell.categories = []
        }
                cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }
        let headerSectionView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HeaderStudySection", for: indexPath) as! HeaderStudySection
        let subject = subjects[indexPath.section]
        headerSectionView.updatesView(study: subject)
        return headerSectionView
    }
}

// MARK: - Delegate
//extension StudyViewController: UICollectionViewDelegate {
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//                if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "StudyDetailViewController") as? StudyDetailViewController {
//                    navigationController?.pushViewController(vc, animated: true)
//                }
//    }
//}

// MARK: - Flowlayout Delegate
extension StudyViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.bounds.size.width
        let height: CGFloat = 150
        return CGSize(width: width, height: height)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let sectionInsets = UIEdgeInsets(top: 0, left: 0, bottom: 24, right: 0)
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
        setupNavigation()
    }
    
    func hideScrollBar() {
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
    }
    
    func setupNavigation() {
//        let studyViewController = StudyViewController()
//        let navigationController = UINavigationController(rootViewController: studyViewController)
//        present(navigationController, animated: true, completion: nil)
        let studyViewSection = StudyViewSection()
        studyViewSection.delegate = self
    }
    
    func handleAPI() {
        StudyService.shared.fetchSubject { [weak self] result in
            switch result {
            case .success(let subjectResponse):
                if let subjects = subjectResponse.result {
                    DispatchQueue.main.async {
                        self?.subjects = subjects
                        self?.collectionView.reloadData()
                    }
                    for subject in subjects {
                        StudyService.shared.fetchCategory(for: subject.subjectID) { categoryResult in
                            switch categoryResult {
                            case .success(let categoryResponse):
                                if let categories = categoryResponse.result {
                                    DispatchQueue.main.async {
//                                        self?.categories.append(contentsOf: categories)
                                        self?.subjectCategoriesDict[subject.subjectID] = categories
                                        self?.collectionView.reloadData()
                                    }
                                }
                            case .failure(let error):
                                print("Error get data category", error)
                            }
                        }
                    }
                }
            case .failure(let error):
                print("Error when retrieving subject data", error)
            }
        }
    }
    //    func updateCollectionView(with categoryDict: [Int: [StudyCategory]]) {
//        // Đảm bảo rằng subjects và categories đã được cập nhật trong fetchSubject
//        // Dựa trên categoryDict, cập nhật categories cho mỗi môn học
//        for subject in subjects {
//            if let categories = categoryDict[subject.subjectID] {
//                // Lọc các danh mục tương ứng với mỗi môn học
//                let filteredCategories = categories.filter { $0.subjectID == subject.subjectID }
//                // Cập nhật danh mục cho môn học
//                
//            }
//        }
//        // Cập nhật collectionView sau khi đã cập nhật danh mục cho mỗi môn học
//        collectionView.reloadData()
//    }
}
