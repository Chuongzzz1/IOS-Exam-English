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
    private var listExam = [ExamHome]()
    private var mainSectionId = 0
    private var totalQuestion = 0
    private var time = 0
    private var examinationId = 0
    private var userName: String = ""
}

// MARK: Life Cycle
extension ExamViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        fetchExamHome()
        fetchUser()
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
        return listExam.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       if let cell = tableView.dequeueReusableCell(withIdentifier: "ExamCell", for: indexPath) as? ExamCell {
           cell.selectionStyle = .none
           let listExam = listExam[indexPath.row]
           cell.updatesView(listExam: listExam)
           return cell
       } else {
           return ExamCell()
       }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let listExam = listExam[indexPath.row]
        mainSectionId = listExam.mainSectionId
        totalQuestion = listExam.totalQuestions
        time = listExam.time
        examinationId = listExam.examinationId
        navToExamQuestionView()
        
    }
}

// MARK: - Func
extension ExamViewController {
    func navToExamQuestionView() {
        let examQuestionVC = ExamQuestionViewController(nibName: "ExamQuestionViewController", bundle: nil)
        examQuestionVC.totalQuestion = totalQuestion
        examQuestionVC.mainSectionId = mainSectionId
        examQuestionVC.time = time
        examQuestionVC.examinationId = examinationId
        examQuestionVC.userName = userName
        self.navigationController?.pushViewController(examQuestionVC, animated: true)
    }
}

// MARK: - Handle API
extension ExamViewController {
    func fetchExamHome() {
        ExamService.shared.fetchHomeExam { [weak self] result in
            switch result {
            case . success(let examHomeResponse):
                if let listExam = examHomeResponse.result {
                    DispatchQueue.main.async {
                        self?.listExam = listExam
                        self?.tableView.reloadData()
                    }
                }
            case . failure(let error):
                Logger.shared.logError(Loggers.StudyMessages.errorFetchQuestion + "\(error)")
            }
        }
    }
    
    func fetchUser() {
        ExamService.shared.fetchUser { [weak self] result in
            switch result {
            case .success(let userResponse):
                if let user = userResponse.result {
                    DispatchQueue.main.async {
                        self?.userName = user.userName
                    }
                }
            case .failure(let error):
                Logger.shared.logError("Error fetching user: \(error.localizedDescription)")
            }
        }
    }
}
