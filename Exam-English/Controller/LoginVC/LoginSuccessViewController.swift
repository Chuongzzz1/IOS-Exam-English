//
//  LoginSuccessViewController.swift
//  Exam-English
//
//  Created by Trần Văn Chương on 22/04/2024.
//

import UIKit

class LoginSuccessViewController: UIViewController {
    private let apiService = Authentication.shared
    @IBOutlet weak var logoutButton: UIButton!
    
    @IBAction func tapToLogout(_ sender: UIButton) {
        guard let accessToken = UserDefaults.standard.string(forKey: "accessToken") else {
            return
        }
        print("debug -- \(String(describing: accessToken))")
        apiService.postLogout(navigationController: self.navigationController, accessToken: accessToken) // running in backgound
    }

    override func viewDidLoad() {
        super.viewDidLoad()
//        guard let accessToken = UserDefaults.standard.string(forKey: "accessToken") else {
//            return
//        }
//        print("debug -- \(String(describing: accessToken))")
    }
}
