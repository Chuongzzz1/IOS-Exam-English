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
        nameTextField.layer.borderWidth = Constants.Layer.borderWidth
//      nameTextField.layer.borderColor = UIColor(named: Constants.Color.normalColor)?.cgColor
        nameTextField.layer.borderColor = UIColor.systemGray.cgColor
        nameTextField.layer.cornerRadius = Constants.Layer.mainRadius
        nameTextField.layer.masksToBounds = true
    }
    
    func handleTapTextField(_ nameTextField: UITextField) {
        nameTextField.layer.borderColor = UIColor(named: Constants.Color.mainColor)?.cgColor
    }
    
    func errorTextField(_ nameTextField: UITextField) {
        nameTextField.layer.borderWidth = Constants.Layer.borderWidth
        nameTextField.layer.borderColor = UIColor(named: Constants.Color.wrongColor)?.cgColor
        nameTextField.layer.cornerRadius = Constants.Layer.mainRadius
        nameTextField.layer.masksToBounds = true
    }
    
    // MARK: - Button
    func customButton(_ nameButton: UIButton) {
        if let customColor = UIColor(named: Constants.Color.mainColor) {
            nameButton.backgroundColor = customColor
        } else {
            print(Constants.MessageColors.mainColor)
        }
        nameButton.layer.cornerRadius = Constants.Layer.buttonRadius
        nameButton.layer.masksToBounds = true
    }
    
    func setHollowButton(_ nameButton: UIButton) {
        nameButton.setTitle("", for: .normal)
    }
    
    func customCheckButton(_ nameButton: UIButton) {
        if let customColor = UIColor(named: Constants.Color.mainColor) {
            nameButton.backgroundColor = customColor
        } else {
            print(Constants.MessageColors.mainColor)
        }
        nameButton.layer.cornerRadius = Constants.Layer.mainRadius
        nameButton.layer.masksToBounds = true
    }
    
    // MARK: - Item
    func customItemSubject(_ nameItem: UIView) {
        nameItem.layer.cornerRadius = 8.0
        if let customColor = UIColor(named: Constants.Color.itemColor) {
            nameItem.backgroundColor = customColor
        } else {
            print(Constants.MessageColors.itemColor)
        }
        nameItem.layer.masksToBounds = true
    }
    
    func customItemCategory(_ nameItem: UIView) {
        nameItem.layer.cornerRadius = Constants.Layer.mainRadius
        if let customColor = UIColor(named: Constants.Color.itemColor) {
            nameItem.backgroundColor = customColor
        } else {
            print(Constants.MessageColors.itemColor)
        }
    }
    
    // MARK: - Answer
    func trueAnswer(_ imageAnswer: UIImageView,_ textAnswer: UILabel) {
        imageAnswer.image = UIImage(named: "true")
        textAnswer.textColor = UIColor(named: Constants.Color.mainColor)
    }
    
    func falseAnswer(_ imageAnswer: UIImageView,_ textAnswer: UILabel) {
        imageAnswer.image = UIImage(named: "false")
        textAnswer.textColor = UIColor(named: Constants.Color.wrongColor)
    }
    
    // MARK: - Label
    func labelQuestion(nameBackground: UIView) {
        if let customColor = UIColor(named: Constants.Color.wrapItemColor) {
            nameBackground.backgroundColor = customColor
        } else {
            print(Constants.MessageColors.wrapItemColor)
        }
        
        nameBackground.layer.masksToBounds = true
        nameBackground.layer.cornerRadius = Constants.Layer.mainRadius
    }
    
    // MARK: - Backgound
    func userBackgound(nameBackground: UIView) {
        if let customColor = UIColor(named: Constants.Color.backgroundColor) {
            nameBackground.backgroundColor = customColor
        } else {
            print(Constants.MessageColors.backgroundColor)
        }
        
        nameBackground.layer.masksToBounds = true
        nameBackground.layer.cornerRadius = Constants.Layer.mainRadius
    }
    
    func rankBackgound(nameBackground: UIView) {
        if let customColor = UIColor(named: Constants.Color.wrapItemColor) {
            nameBackground.backgroundColor = customColor
        } else {
            print(Constants.MessageColors.wrapItemColor)
        }
        
        nameBackground.layer.masksToBounds = true
        nameBackground.layer.cornerRadius = Constants.Layer.mainRadius
    }
    
    func childRankBackgound(nameBackground: UIView) {
        if let customColor = UIColor(named: Constants.Color.itemColor) {
            nameBackground.backgroundColor = customColor
        } else {
            print(Constants.MessageColors.itemColor)
        }
        
        nameBackground.layer.masksToBounds = true
        nameBackground.layer.cornerRadius = Constants.Layer.mainRadius
    }
    
    func viewButton(nameBackgroud: UIView) {
            if let customColor = UIColor(named: Constants.Color.mainColor) {
                nameBackgroud.backgroundColor = customColor
            } else {
                print(Constants.MessageColors.mainColor)
            }
        nameBackgroud.layer.cornerRadius = Constants.Layer.buttonRadius
        nameBackgroud.layer.masksToBounds = true
        }
    
    // MARK: - NAV
    func customizeNavigationBar(for navigationController: UINavigationController?) {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(named: Constants.Color.backgroundColor)
        
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


