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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

// MARK: - Delegate
extension StudyQuestionSetViewController: UITableViewDelegate {
}

// MARK: - Func
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


