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
    private var subSectionID = 0
    private var cellHeight: CGFloat = 50
    var audioData: Data?
}

// MARK: - Life Cycle
extension StudyQuestionSetViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupStudyDetailView()
        callFunc()
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
//        handleQuestion(subSectionID: subSection.subSectionID,page: currentPage)
        subSectionID = subSection.subSectionID
        navigateToStudyQuestionViewController()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
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
    func callFunc() {
        setupNavigationBar()
    }
    
    private func navigateToStudyQuestionViewController() {
        let studyQuestionSetVC = StudyQuestionViewController(nibName: "StudyQuestionViewController", bundle: nil)
        studyQuestionSetVC.subSectionID = subSectionID
        self.navigationController?.pushViewController(studyQuestionSetVC, animated: true)
    }
    
    func updateTitle(with subSectionName: String) {
        self.title = subSectionName
    }
    
    private func setupNavigationBar() {
        let customTitleView = UIView()
        self.navigationItem.titleView = customTitleView
    }
}

// MARK: - Handle API
extension StudyQuestionSetViewController {
}



