//
//  LoginViewController.swift
//  FitPals
//
//  Created by Will Carhart on 5/5/18.
//  Copyright © 2018 Will Carhart. All rights reserved.
//

import UIKit
import ChameleonFramework

class LoginViewController: UIViewController {
    
    var showLogin: Bool = true
    
    // login Bools
    var validLoginEmail: Bool = false
    var validLoginPassword: Bool = false
    var validLoginButton: Bool {
        return validLoginEmail && validLoginPassword
    }
    
    // register Bools
    var validRegisterFirstName: Bool = false
    var validRegisterLastName: Bool = false
    var validRegisterEmail: Bool = false
    var validRegisterPassword: Bool = false
    var validRegisterConfirmPassword: Bool = false
    var validRegisterButton: Bool {
        return validRegisterFirstName && validRegisterLastName && validRegisterEmail && validRegisterPassword && validRegisterConfirmPassword
    }
    
    // view outlets (for colors)
    @IBOutlet var parentView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var loginBubbleView: UIView!
    
    // tab outlets
    @IBOutlet weak var loginTabView: UIView!
    @IBOutlet weak var loginTabButton: UIButton!
    @IBOutlet weak var registerTabView: UIView!
    @IBOutlet weak var registerTabButton: UIButton!
    
    // login outlets
    @IBOutlet weak var loginEmailTextField: UITextField!
    @IBOutlet weak var loginPasswordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var loginMessageLabel: UILabel!
    
    // register outlets
    @IBOutlet weak var registerFirstNameTextField: UITextField!
    @IBOutlet weak var registerLastNameTextField: UITextField!
    @IBOutlet weak var registerEmailTextField: UITextField!
    @IBOutlet weak var registerPasswordTextField: UITextField!
    @IBOutlet weak var registerConfirmPasswordTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        
        parentView.backgroundColor = GradientColor(.topToBottom, frame: parentView.frame, colors: [FlatOrange(), FlatMagentaDark()])
        contentView.backgroundColor = GradientColor(.topToBottom, frame: parentView.frame, colors: [FlatOrange(), FlatMagentaDark()])
        loginBubbleView.backgroundColor = FlatWhite()
    }
    
    func updateUI() {
        if showLogin {
            // update colors
            loginTabView.backgroundColor = FlatWhite()
            registerTabView.backgroundColor = FlatWhiteDark()
            
            // show login controls
            loginMessageLabel.isHidden = false
            loginEmailTextField.isHidden = false
            loginPasswordTextField.isHidden = false
            loginButton.isHidden = false
            
            // hide register controls
            registerFirstNameTextField.isHidden = true
            registerLastNameTextField.isHidden = true
            registerEmailTextField.isHidden = true
            registerPasswordTextField.isHidden = true
            registerConfirmPasswordTextField.isHidden = true
        } else {
            // update colors
            loginTabView.backgroundColor = FlatWhiteDark()
            registerTabView.backgroundColor = FlatWhite()
            
            // hide login controls
            loginMessageLabel.isHidden = true
            loginEmailTextField.isHidden = true
            loginPasswordTextField.isHidden = true
            loginButton.isHidden = true
            
            // show register controls
            registerFirstNameTextField.isHidden = false
            registerLastNameTextField.isHidden = false
            registerEmailTextField.isHidden = false
            registerPasswordTextField.isHidden = false
            registerConfirmPasswordTextField.isHidden = false
        }
    }
    
    // tab actions
    @IBAction func loginTabButtonPressed(_ sender: UIButton) {
        showLogin = true
        updateUI()
    }
    
    @IBAction func registerTabButtonPressed(_ sender: UIButton) {
        showLogin = false
        updateUI()
    }
    
    // login actions
    @IBAction func loginEmailTextFieldChanged(_ sender: UITextField) {
        guard let text = loginEmailTextField.text else { return }
        validLoginEmail = isValidEmail(text) ? true: false
    }
    
    func isValidEmail(_ string: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: string)
    }
    
    @IBAction func loginPasswordTextFieldChanged(_ sender: UITextField) {
        guard let text = loginPasswordTextField.text else { return }
        validLoginPassword = text.count >= 8 ? true : false
    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        print("login button pressed")
        if !validLoginButton {
            if !validLoginEmail {
                UIView.animate(withDuration: 0.1, animations: {
                    self.loginEmailTextField.transform = CGAffineTransform(rotationAngle: .pi / 10)
                }) { (_) in
                    UIView.animate(withDuration: 0.1, animations: {
                        self.loginEmailTextField.transform = CGAffineTransform(rotationAngle: .pi / -10)
                    }) { (_) in
                        UIView.animate(withDuration: 0.1, animations: {
                            self.loginEmailTextField.transform = CGAffineTransform(rotationAngle: .pi / 10)
                        }) { (_) in
                            UIView.animate(withDuration: 0.1) {
                                self.loginEmailTextField.transform = CGAffineTransform.identity
                            }
                        }
                    }
                }
            } else {
                UIView.animate(withDuration: 0.1, animations: {
                    self.loginPasswordTextField.transform = CGAffineTransform(rotationAngle: .pi / 10)
                }) { (_) in
                    UIView.animate(withDuration: 0.1, animations: {
                        self.loginPasswordTextField.transform = CGAffineTransform(rotationAngle: .pi / -10)
                    }) { (_) in
                        UIView.animate(withDuration: 0.1, animations: {
                            self.loginPasswordTextField.transform = CGAffineTransform(rotationAngle: .pi / 10)
                        }) { (_) in
                            UIView.animate(withDuration: 0.1) {
                                self.loginPasswordTextField.transform = CGAffineTransform.identity
                            }
                        }
                    }
                }
            }
        } else {
            // TODO: log in with Firebase
        }
    }
    
    // register actions
    @IBAction func registerFirstNameTextFieldChanged(_ sender: UITextField) {
    }
    
    @IBAction func registerLastNameTextFieldChanged(_ sender: UITextField) {
    }
    
    @IBAction func registerEmailTextFieldChanged(_ sender: UITextField) {
    }
    
    @IBAction func registerPasswordTextFieldChanged(_ sender: UITextField) {
    }
    
    @IBAction func registerConfirmPasswordTextFieldChanged(_ sender: UITextField) {
    }
    
    @IBAction func createAccountButtonPressed(_ sender: UIButton) {
    }
    
}
