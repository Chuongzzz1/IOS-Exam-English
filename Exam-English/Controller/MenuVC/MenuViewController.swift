//
//  MenuViewController.swift
//  Exam-English
//
//  Created by Trần Văn Chương on 09/06/2024.
//

import UIKit

// MARK: - Enum
enum Section: Int, CaseIterable {
    case user
    case action
    case buttonFunc
    
    var numberOfRows: Int {
        switch self {
        case .user, .buttonFunc:
            return 1
        case .action:
            return 6
        }
    }
    
    var cellIdentifier: String {
        switch self {
        case .user:
            return "UserCell"
        case .action:
            return "ActionCell"
        case .buttonFunc:
            return "ButtonFuncCell"
        }
    }
    
    var cellHeight: CGFloat {
        switch self {
        case .user:
            return 96
        case .action:
            return 48
        case .buttonFunc:
            return 48
        }
    }
}

class MenuViewController: UIViewController {
    // MARK: - Outlet
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Variable
    
}

// MARK: - Life Cycle
extension MenuViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
}

// MARK: - Delegate
extension MenuViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let section = Section(rawValue: indexPath.section) else {
            return 0
        }
        return section.cellHeight
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 16
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .clear
        return headerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let section = Section(rawValue: indexPath.section) else {
            return
        }
        
        switch section {
        case .user:
            navigateToUserVC()
        case .action:
            // Handle action cell selection if needed
            break
        case .buttonFunc:
            logout()
        }
    }
}

// MARK: - DataSouce
extension MenuViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return Section.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = Section(rawValue: section) else {
            return 0
        }
        
        return section.numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = Section(rawValue: indexPath.section) else {
            return UITableViewCell()
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: section.cellIdentifier, for: indexPath)
        cell.selectionStyle = .none
        return cell
    }
}

// MARK: - Setup View
extension MenuViewController {
    func setupView() {
        registerCell()
        registerDelegateDatasource()
        resetCell()
    }
    
    func registerCell() {
        let userCellNib = UINib(nibName: "UserCell", bundle: nil)
        tableView.register(userCellNib, forCellReuseIdentifier: "UserCell")
        let buttonFuncCellNib = UINib(nibName: "ButtonFuncCell", bundle: nil)
        tableView.register(buttonFuncCellNib, forCellReuseIdentifier: "ButtonFuncCell")
        let actionCellNib = UINib(nibName: "ActionCell", bundle: nil)
        tableView.register(actionCellNib, forCellReuseIdentifier: "ActionCell")
    }
    
    func registerDelegateDatasource() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func resetCell() {
        tableView.separatorStyle = .none
    }
}

// MARK: - Func
extension MenuViewController {
    func navigateToUserVC() {
        let userVC = UserViewController(nibName: "UserViewController", bundle: nil)
        self.navigationController?.pushViewController(userVC, animated: true)
    }
    
    func logout() {
        guard let accessToken = UserDefaults.standard.string(forKey: "accessToken") else {
            return
        }
//        print("debug -- \(String(describing: accessToken))")
        Authentication.shared.postLogout(navigationController: self.navigationController, accessToken: accessToken)
    }
}

// MARK: - Handle API
extension MenuViewController {
    
}
