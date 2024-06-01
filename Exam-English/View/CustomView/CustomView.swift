//
//  CustomView.swift
//  Exam-English
//
//  Created by Trần Văn Chương on 16/04/2024.
//

import Foundation
import UIKit
class CustomView {
    // MARK: - Text Field
    func customTextField(_ nameTextField: UITextField) {
        nameTextField.layer.borderWidth = 1.0
        nameTextField.layer.borderColor = UIColor.systemGray.cgColor
        nameTextField.layer.cornerRadius = 10.0
        nameTextField.layer.masksToBounds = true
    }
    
    func handleTapTextField(_ nameTextField: UITextField) {
        nameTextField.layer.borderColor = UIColor.systemGreen.cgColor
    }
    
    func errorTextField(_ nameTextField: UITextField) {
        nameTextField.layer.borderWidth = 1.0
        nameTextField.layer.borderColor = UIColor.systemRed.cgColor
        nameTextField.layer.cornerRadius = 10.0
        nameTextField.layer.masksToBounds = true
    }
    
    // MARK: - Button
    func customButton(_ nameButton: UIButton) {
        if let customColor = UIColor(named: "008000") {
            nameButton.backgroundColor = customColor
        } else {
            print("Màu có tên '008000' không tồn tại trong file asset.")
        }
        nameButton.layer.cornerRadius = 25.0
        nameButton.layer.masksToBounds = true
    }
    
    func setHollowButton(_ nameButton: UIButton) {
        nameButton.setTitle("", for: .normal)
    }
    
    func customCheckButton(_ nameButton: UIButton) {
        if let customColor = UIColor(named: "008000") {
            nameButton.backgroundColor = customColor
        } else {
            print("Màu có tên '008000' không tồn tại trong file asset.")
        }
        nameButton.layer.cornerRadius = 10.0
        nameButton.layer.masksToBounds = true
    }
    
    // MARK: - Item
    func customItemSubject(_ nameItem: UIView) {
        nameItem.layer.cornerRadius = 8.0
        if let customColor = UIColor(named: "E5F2E5") {
            nameItem.backgroundColor = customColor
        } else {
            print("Màu có tên 'E5F2E5' không tồn tại trong file asset.")
        }
        nameItem.layer.masksToBounds = true
    }
    
    func customItemCategory(_ nameItem: UIView) {
        nameItem.layer.cornerRadius = 10.0
        if let customColor = UIColor(named: "E5F2E5") {
            nameItem.backgroundColor = customColor
        } else {
            print("Màu có tên 'E5F2E5' không tồn tại trong file asset.")
        }
    }
    
    // MARK: - Answer
    func trueAnswer(_ imageAnswer: UIImageView,_ textAnswer: UILabel) {
        imageAnswer.image = UIImage(named: "true")
        textAnswer.textColor = UIColor(named: "008000")
    }
    
    func falseAnswer(_ imageAnswer: UIImageView,_ textAnswer: UILabel) {
        imageAnswer.image = UIImage(named: "false")
        textAnswer.textColor = .red
    }
    
    // MARK: - Label
    func labelQuestion(nameBackground: UIView) {
        if let customColor = UIColor(named: "9FDBB4") {
            nameBackground.backgroundColor = customColor
        } else {
            print("Màu có tên '9FDBB4' không tồn tại trong file asset.")
        }
        
        nameBackground.layer.masksToBounds = true
        nameBackground.layer.cornerRadius = 10.0
    }
    
    // MARK: - NAV
    func customizeNavigationBar(for navigationController: UINavigationController?) {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(named: "66B366")
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.tintColor = .white
        
        if let topViewController = navigationController?.topViewController {
            let backButton = UIBarButtonItem()
            backButton.setTitleTextAttributes([.font: UIFont.boldSystemFont(ofSize: 16)], for: .normal)
            topViewController.navigationItem.backBarButtonItem = backButton
        }
    }
}
