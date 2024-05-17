//
//  StudyViewController.swift
//  Exam-English
//
//  Created by Trần Văn Chương on 02/05/2024.
//

import UIKit

class StudyViewController: UIViewController, StudyViewSectionDelegate {
    func didSelectItem(mainSections: [StudyMainSection]) {
             let studyVC = StudyDetailViewController(nibName: "StudyDetailViewController", bundle: nil)
             studyVC.mainSections = mainSections
             self.navigationController?.pushViewController(studyVC, animated: true)
        }
    
    // MARK: - Outlet
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Variable
    private var subjects = [StudySubject]()
    private var categories = [StudyCategory]()
    private var categorieDict = [Int: [StudyCategory]]()
    private var mainSections = [StudyMainSection]()
    private var mainSectionDict = [Int : [StudyMainSection]]()
    private let studyService = StudyService.shared
}

// MARK: - Life Cycle
extension StudyViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
    }
}

// MARK: - DataSource
extension StudyViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return subjects.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let subject = subjects[section]
        if let categories = categorieDict[subject.subjectID] {
            return categories.count // Add 1 for the subject cell
        } else {
            return 1 // Only the subject cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StudyViewSection", for: indexPath) as! StudyViewSection
        let subject = subjects[indexPath.section]
        if let categories = categorieDict[subject.subjectID] {
            cell.categories = categories
            var mainSectionDictForCell = [Int: [StudyMainSection]]()
            for category in categories {
                if let mainSections = mainSectionDict[category.categoryID] {
                    mainSectionDictForCell[category.categoryID] = mainSections
                }
            }
            cell.mainSectionDict = mainSectionDictForCell
        } else {
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
        handleSubjectCategory()
//        handleMainSection()
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
    
    func handleSubjectCategory() {
        studyService.fetchSubject { [weak self] result in
            switch result {
            case .success(let subjectResponse):
                if let subjects = subjectResponse.result {
                    DispatchQueue.main.async {
                        self?.subjects = subjects
                        self?.collectionView.reloadData()
                    }
                    let dispatchGroup = DispatchGroup()
                    for subject in subjects {
                        dispatchGroup.enter()
                        StudyService.shared.fetchCategory(for: subject.subjectID) { [weak self] categoryResult in
                            switch categoryResult {
                            case .success(let categoryResponse):
                                if let categories = categoryResponse.result {
                                    DispatchQueue.main.async {
                                        self?.categories.append(contentsOf: categories)
                                        self?.categorieDict[subject.subjectID] = categories
                                        self?.collectionView.reloadData()
                                    }
                                }
                            case .failure(let error):
                                print("Error get data category", error)
                            }
                            dispatchGroup.leave()
                        }
                    }
                    dispatchGroup.notify(queue: .main) {
                        self?.handleMainSection()
                    }
                }
            case .failure(let error):
                print("Error when retrieving subject data", error)
            }
        }
    }
    
    func handleMainSection() {
        guard !categories.isEmpty else {
            print("Categories array is empty.")
            return
        }
        for category in categories {
            StudyService.shared.fetchMainSection(for: category.categoryID) { [weak self] mainSectionResult in
                switch mainSectionResult {
                case .success(let mainSectionResult):
                    if let mainSections = mainSectionResult.result {
                        DispatchQueue.main.async {
                            self?.mainSections.append(contentsOf: mainSections)
                            self?.mainSectionDict[category.categoryID] = mainSections
                            self?.collectionView.reloadData()
                        }
                    }
                case .failure(let error):
                    print("Error get data category", error)
                }
            }
        }
    }
}
