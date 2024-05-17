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
        let studyVC = StudyQuestionSetViewController(nibName: "StudyQuestionSetViewController", bundle: nil)
        self.navigationController?.pushViewController(studyVC, animated: true)
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
}
