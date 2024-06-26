//
//  ListQuestionViewController.swift
//  Exam-English
//
//  Created by Trần Văn Chương on 25/06/2024.
//

import UIKit

class ListQuestionViewController: UIViewController {
// MARK: - Outlet
    @IBOutlet weak var tableView: UITableView!
    
// MARK: - Variable
    private var cellHeight: CGFloat = 80
    var questions = [QuestionModel]()
}

// MARK: - Life Cycle
extension ListQuestionViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
}

// MARK: - Delegate
extension ListQuestionViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
}

// MARK: - Data Source
extension ListQuestionViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ListQuestionCell", for: indexPath) as? ListQuestionCell {
            cell.selectionStyle = .none
            let questions = questions[indexPath.row]
            cell.updatesView(question: questions)
            cell.onAnswerSelected = { [weak self] selectedIndex in
                guard let self = self else { return }
                self.questions[indexPath.row].selectedAnswerIndex = selectedIndex
                tableView.reloadData()
            }
            return cell
        } else {
            return ListQuestionCell()
        }

    }
}

// MARK: - Setup View
extension ListQuestionViewController {
    func setupView() {
        registerCell()
        registerDelegateDataSource()
        resetCell()
    }
    
    func registerCell() {
        let listQuestionNib = UINib(nibName: "ListQuestionCell", bundle: nil)
        tableView.register(listQuestionNib, forCellReuseIdentifier: "ListQuestionCell")
    }
    
    func registerDelegateDataSource() {
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func resetCell() {
        tableView.separatorStyle = .none
    }
}

// MARK: - Func
extension ListQuestionViewController {}
