//
//  LoginViewController.swift
//  Exam-English
//
//  Created by Trần Văn Chương on 14/04/2024.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
// MARK: - Outlet
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var accountTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var hideShowButton: UIButton!
    

    // MARK: - Variable
    private var tempHideShow = true
    private var customView = CustomView()
    
}
// MARK: Life Cycle
extension LoginViewController {
    override func viewDidLoad() {
        setupView()

    }
}

// MARK: Action
extension LoginViewController {
    @IBAction func hideShowPass(_ sender: UIButton) {
        if tempHideShow == true {
            sender.setImage(UIImage(named: "open-eye"), for: UIControl.State.normal)
            passwordTextField.isSecureTextEntry = false
            tempHideShow = false
        } else {
            sender.setImage(UIImage(named: "close-eye"), for: UIControl.State.normal)
            passwordTextField.isSecureTextEntry = true
            tempHideShow = true
        }
    }
}
// MARK: Func
extension LoginViewController {
    func setupView() {
        setupTextField()
        setupButton()
        delegateTextField()
    }
    
    func setupTextField() {
        customView.customTextField(accountTextField)
        customView.customTextField(passwordTextField)
    }
    
    func setupButton() {
        customView.customButton(loginButton)
        customView.setHollowButton(hideShowButton)
    }
    
    func delegateTextField() {
        accountTextField.delegate = self
        passwordTextField.delegate = self
    }
}
// MARK: - Delegate TextField
extension LoginViewController {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == accountTextField {
            customView.handleTapTextField(accountTextField)
            customView.customTextField(passwordTextField)
        } else if textField == passwordTextField {
            customView.handleTapTextField(passwordTextField)
            customView.customTextField(accountTextField)
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

