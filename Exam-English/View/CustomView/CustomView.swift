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
    
    // MARK: - Item
    func customItemSubject(_ nameItem: UIView) {
        nameItem.layer.cornerRadius = 8.0
        nameItem.layer.backgroundColor = UIColor.systemGreen.cgColor
//        nameItem.layer.masksToBounds = true
    }
    
    func customItemCategory(_ nameItem: UIView) {
        nameItem.layer.cornerRadius = 10.0
        nameItem.layer.backgroundColor = UIColor.systemGreen.cgColor
    }
}
