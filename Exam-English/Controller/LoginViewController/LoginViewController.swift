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
    @IBOutlet weak var warningAccountLabel: UILabel!
    @IBOutlet weak var warningPasswordLabel: UILabel!

// MARK: - Variable
    private var tempHideShow = true
    private var defaultPasswordWarning: String = ""
    private var customView = CustomView()
    private let apiService = APIService.shared
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
    
    @IBAction func logginButton(_ sender: UIButton) {
        guard let username = accountTextField.text, !username.isEmpty else {
            customView.errorTextField(accountTextField)
            warningAccountLabel.isHidden = false
            return
        }
        
        guard let password = passwordTextField.text, !password.isEmpty else {
            customView.errorTextField(passwordTextField)
            warningPasswordLabel.isHidden = false
            return
        }
        apiService.postLogin(username: username, password: password) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    self?.handleLoginSuccess(data: data)
                    
                case .failure(let error):
                    self?.handleLoginFailure(error: error)
                }
            }
        }
    }
}

// MARK: Func
extension LoginViewController {
    func setupView() {
        setupTextField()
        setupButton()
        delegateTextField()
        getDefaulTextField()
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
    
    func getDefaulTextField() {
        defaultPasswordWarning = warningPasswordLabel.text ?? ""
    }
}

// MARK: - Delegate TextField
extension LoginViewController {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == accountTextField {
            customView.handleTapTextField(accountTextField)
            customView.customTextField(passwordTextField)
            warningAccountLabel.isHidden = true
        } else if textField == passwordTextField {
            customView.handleTapTextField(passwordTextField)
            customView.customTextField(accountTextField)
            warningPasswordLabel.isHidden = true
            warningPasswordLabel.text = defaultPasswordWarning
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// MARK: - Helper Methods
extension LoginViewController {
    private func handleLoginSuccess(data: Data) {
        do {
            // Decode JSON data to retrieve the access token
            let tokenResponse = try JSONDecoder().decode(AccessTokenResponse.self, from: data)
            
            // Extract the access token
            let accessToken = tokenResponse.result?.token
            
            // Save the access token to UserDefaults
            UserDefaults.standard.set(accessToken, forKey: "accessToken")
//            print("\(String(describing: accessToken))")
            
            // Schedule refresh token
            apiService.scheduleRefreshAccessToken(accessToken: accessToken!)
            
            // Navigate to the next screen or perform any other necessary actions
            let loginSuccessVC = LoginSuccessViewController(nibName: "LoginSuccessViewController", bundle: nil)
//            self.navigationController?.pushViewController(loginSuccessVC, animated: true)
            UIApplication.shared.windows.first?.rootViewController = loginSuccessVC
            UIApplication.shared.windows.first?.makeKeyAndVisible()
        } catch {
            print("Error decoding token response: \(error)")
        }
    }

    private func handleLoginFailure(error: Error) {
            warningPasswordLabel.text = "User account or password incorrect"
            warningPasswordLabel.isHidden = false
        print("Login fail with error: \(error.localizedDescription)")
    }
}


