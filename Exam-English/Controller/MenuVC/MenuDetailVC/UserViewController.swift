//
//  UserViewController.swift
//  Exam-English
//
//  Created by Trần Văn Chương on 16/06/2024.
//

import UIKit

class UserViewController: UIViewController {
// MARK: - Outlet
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var changeImageButton: UIButton!
    @IBOutlet weak var changeImageButton2: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var accountLabel: UILabel!
    @IBOutlet weak var accountTextField: UITextField!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var confirmButton: UIButton!
    
    
    // MARK: - Variable
    private var custom = CustomView()
}

// MARK: - Life Cycle
extension UserViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
}

// MARK: - Setup View
extension UserViewController {
    func setupView() {
//        customTextField()
        customButton()
    }
    
    func customTextField() {
        custom.customTextField(nameTextField)
        custom.customTextField(accountTextField)
        custom.customTextField(passwordTextField)
        custom.customTextField(emailTextField)
    }
    
    func customButton() {
        custom.customButton(confirmButton)
    }
    
}

// MARK: - Func
extension UserViewController {}
