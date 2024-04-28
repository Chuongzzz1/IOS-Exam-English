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
        guard let username = accountTextField.text, !username.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            // Xử lý trường hợp username hoặc password trống
            return
        }
        
        // Gọi API đăng nhập
        apiService.postLogin(username: username, password: password) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    // Xử lý đăng nhập thành công
                    // Ví dụ: Lưu token và chuyển hướng đến màn hình tiếp theo
                    self?.handleLoginSuccess(data: data)
                    
                case .failure(let error):
                    // Xử lý đăng nhập thất bại
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

// MARK: - Helper Methods
extension LoginViewController {
    private func handleLoginSuccess(data: Data) {
        // Xử lý đăng nhập thành công (ví dụ: lưu token, chuyển hướng đến màn hình tiếp theo)
        let loginSuccessVC = LoginSuccessViewController(nibName: "LoginSuccessViewController", bundle: nil)
        self.navigationController?.pushViewController(loginSuccessVC, animated: true)
        print("Đăng nhập thành công với dữ liệu phản hồi: \(data)")
        // Ví dụ: Lưu token và chuyển hướng đến màn hình tiếp theo
        // self?.saveTokenAndNavigate(data: data)
    }

    private func handleLoginFailure(error: Error) {
        // Xử lý đăng nhập thất bại (hiển thị cảnh báo, ghi log lỗi, vv.)
        print("Đăng nhập thất bại với lỗi: \(error.localizedDescription)")
        // Ví dụ: Hiển thị cảnh báo hoặc thông báo lỗi cho người dùng
    }
}


