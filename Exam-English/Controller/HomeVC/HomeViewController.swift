//
//  HomeViewController.swift
//  Exam-English
//
//  Created by Trần Văn Chương on 02/06/2024.
//

import UIKit

class HomeViewController: UIViewController {
// MARK: - Outlet
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var userView: UIView!
    @IBOutlet weak var userRankView: UIView!
    @IBOutlet weak var rankView: UIView!
    @IBOutlet weak var scoreView: UIView!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var introLabel: UILabel!
    @IBOutlet weak var rankImage: UIImageView!
    @IBOutlet weak var rankingLabel: UILabel!
    @IBOutlet weak var rankNumberLabel: UILabel!
    @IBOutlet weak var scoreImage: UIImageView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var scoreNumberLabel: UILabel!
    
// MARK: - Variable
    private var custom = CustomView()
}

// MARK: - Life Cycle
extension HomeViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
}

// MARK: - Delegate
extension HomeViewController: UITableViewDelegate {
    
}

// MARK: - DataSource
extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeViewCell", for: indexPath) as! HomeViewCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 96
    }
    
    
}
// MARK: - Setup View
extension HomeViewController {
    func setupView() {
        registerDatasourceAndDelegate()
        registerCell()
        resetCell()
        customView()
    }
    
    func registerDatasourceAndDelegate() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func registerCell() {
        let homeCellNib = UINib(nibName: "HomeViewCell", bundle: .main)
        tableView.register(homeCellNib, forCellReuseIdentifier: "HomeViewCell")
    }
    
    func resetCell() {
        tableView.separatorStyle = .none
    }
    
    func customView() {
        custom.userBackgound(nameBackground: userView)
        custom.rankBackgound(nameBackground: userRankView)
        custom.childRankBackgound(nameBackground: rankView)
        custom.childRankBackgound(nameBackground: scoreView)
    }
}

// MARK: - Func
extension HomeViewController {}
