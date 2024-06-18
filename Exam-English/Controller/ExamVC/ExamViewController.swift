//
//  ExamViewController.swift
//  Exam-English
//
//  Created by Trần Văn Chương on 17/06/2024.
//

import UIKit

class ExamViewController: UIViewController {
// MARK: - Outlet
    @IBOutlet weak var tableView: UITableView!
    
// MARK: - Variable
    private var cellHeight: CGFloat = 96
}

// MARK: Life Cycle
extension ExamViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
}

// MARK: - Setup View
extension ExamViewController {
    func setupView() {
        registerCell()
        registerDelegateDataSource()
        resetCell()
    }
    
    func registerCell() {
        let examNib = UINib(nibName: "ExamCell", bundle: nil)
        tableView.register(examNib, forCellReuseIdentifier: "ExamCell")
    }
    
    func registerDelegateDataSource() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func resetCell() {
        tableView.separatorStyle = .none
    }
}

// MARK: - Delegate
extension ExamViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
}

// MARK: - DataSouce
extension ExamViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6 // fake cell
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       if let cell = tableView.dequeueReusableCell(withIdentifier: "ExamCell", for: indexPath) as? ExamCell {
           cell.selectionStyle = .none
           return cell
       } else {
           return ExamCell()
       }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navToExamQuestionView()
    }
}

// MARK: - Func
extension ExamViewController {
    func navToExamQuestionView() {
        let examQuestionVC = ExamQuestionViewController(nibName: "ExamQuestionViewController", bundle: nil)
        self.navigationController?.pushViewController(examQuestionVC, animated: true)
    }
}
