//
//  StudyQuestionSetViewController.swift
//  Exam-English
//
//  Created by Trần Văn Chương on 06/05/2024.
//

import UIKit

class StudyQuestionSetViewController: UIViewController {
    // MARK: - Outlet
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Variable
    var subSections = [StudySubSection]()
    var questions = [StudyQuestion]()
    private var currentPage = 1
}

// MARK: - Life Cycle
extension StudyQuestionSetViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupStudyDetailView()
    }
}

// MARK: - DataSource
extension StudyQuestionSetViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subSections.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "StudyQuestionSetCell", for: indexPath) as? StudyQuestionSetCell {
            let subSection = subSections[indexPath.row]
            cell.updatesView(subSection: subSection)
            return cell
        } else {
            return StudyQuestionSetCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let subSection = subSections[indexPath.row]
        updateTitle(with: subSection.subSectionName)
        handleQuestion(subSectionID: subSection.subSectionID,page: currentPage)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

// MARK: - Delegate
extension StudyQuestionSetViewController: UITableViewDelegate {

}

// MARK: - SetupView
extension StudyQuestionSetViewController {
    func registerCell(){
        let studyQuestionSetNib = UINib(nibName: "StudyQuestionSetCell", bundle: nil)
        tableView.register(studyQuestionSetNib, forCellReuseIdentifier: "StudyQuestionSetCell")
    }
    
    func setupStudyDetailView(){
        registerCell()
        tableView.delegate = self
        tableView.dataSource = self
    }
}

// MARK: - Func
extension StudyQuestionSetViewController {
    private func navigateToStudyQuestionViewController() {
        let studyQuestionSetVC = StudyQuestionViewController(nibName: "StudyQuestionViewController", bundle: nil)
        studyQuestionSetVC.questions = self.questions
        self.navigationController?.pushViewController(studyQuestionSetVC, animated: true)
    }
    
    func updateTitle(with subSectionName: String) {
        self.title = subSectionName
    }
}

// MARK: - Handle API
extension StudyQuestionSetViewController {
    func handleQuestion(subSectionID: Int,page: Int) {
        StudyService.shared.fetchQuestion(for: subSectionID, page: page) { [weak self] result in
            switch result {
            case .success(let studyQuestionResponse):
                if let questions = studyQuestionResponse.result {
                    DispatchQueue.main.async {
                        self?.questions = questions
                        self?.navigateToStudyQuestionViewController()
                    }
                }
            case .failure(let error):
                print("Failed to fetch sub sections: \(error.localizedDescription)")
            }
        }
    }
}



