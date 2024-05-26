//
//  StudyDetailViewController.swift
//  Exam-English
//
//  Created by Trần Văn Chương on 06/05/2024.
//

import UIKit

class StudyDetailViewController: UIViewController {
// MARK: - Outlet
    @IBOutlet weak var tableView: UITableView!
    
// MARK: - Variable
    var mainSections = [StudyMainSection]()
    var subSections = [StudySubSection]()
}
 // MARK: Life Cycle
extension StudyDetailViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupStudyDetailView()
    }
}

// MARK: - DataSource
extension StudyDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mainSections.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "StudyDetailCell", for: indexPath) as? StudyDetailCell {
            let mainSection = mainSections[indexPath.row]
            cell.updatesView(mainSection: mainSection)
            return cell
        } else {
            return StudyDetailCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

// MARK: - Delegate
extension StudyDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let mainSection = mainSections[indexPath.row]
        handleSubSection(mainSectionID: mainSection.mainSectionID)
    }
}

// MARK: - Func
extension StudyDetailViewController {
    
    func registerCell(){
        let studyDetailNib = UINib(nibName: "StudyDetailCell", bundle: nil)
        tableView.register(studyDetailNib, forCellReuseIdentifier: "StudyDetailCell")
    }
    
    func setupStudyDetailView(){
        registerCell()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func navigateToStudyQuestionSetViewController() {
        let studyDetailVC = StudyQuestionSetViewController(nibName: "StudyQuestionSetViewController", bundle: nil)
        studyDetailVC.subSections = self.subSections
        self.navigationController?.pushViewController(studyDetailVC, animated: true)
    }
}

// MARK: - Handle API
extension StudyDetailViewController {
    func handleSubSection(mainSectionID: Int) {
        StudyService.shared.fetchSubSection(for: mainSectionID) { [weak self] result in
            switch result {
            case .success(let studySubSectionResponse):
                if let subSections = studySubSectionResponse.result {
                    DispatchQueue.main.async {
//                        self?.subSections.append(contentsOf: subSections)
                        self?.subSections = subSections
                        self?.navigateToStudyQuestionSetViewController()
                    }
                }
            case .failure(let error):
                print("Failed to fetch sub sections: \(error.localizedDescription)")
            }
        }
    }
}
