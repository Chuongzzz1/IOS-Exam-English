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
    private var fruits = [FruitModel]()
    private let sturyService = StudyService.shared
}

// MARK: - Life Cycle
extension StudyViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        fruits = LoadData.share.loadData() ?? [FruitModel]()
        StudyService.shared.fetchSubject { result in
            switch result {
            case .success(let subjectResponse):
                // Xử lý dữ liệu môn học ở đây
                print("Danh sách môn học:", subjectResponse.result ?? "Không có dữ liệu")
                
                // Lặp qua từng môn học để lấy danh mục tương ứng
                if let subjects = subjectResponse.result {
                    for subject in subjects {
                        StudyService.shared.fetchCategory(for: subject.subjectID) { categoryResult in
                            switch categoryResult {
                            case .success(let categoryResponse):
                                // Xử lý dữ liệu danh mục ở đây
                                print("Danh sách danh mục cho môn \(subject.subjectName):", categoryResponse.result ?? "Không có dữ liệu")
                            case .failure(let error):
                                print("Lỗi khi lấy danh mục cho môn \(subject.subjectName):", error)
                            }
                        }
                    }
                }
            case .failure(let error):
                print("Lỗi khi lấy dữ liệu môn học:", error)
            }
        }    }
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
        cell.delegate = self
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
        let studyViewController = StudyViewController()
        let navigationController = UINavigationController(rootViewController: studyViewController)
//        present(navigationController, animated: true, completion: nil)
        let studyViewSection = StudyViewSection()
        studyViewSection.delegate = self
    }
}
