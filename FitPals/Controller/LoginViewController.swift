//
//  LoginViewController.swift
//  FitPals
//
//  Created by Will Carhart on 5/5/18.
//  Copyright © 2018 Will Carhart. All rights reserved.
//

import UIKit

// UI
import ChameleonFramework
import PKHUD
import TextFieldEffects

// core
import FirebaseAuth
import Firebase

// TODO: get third party auth working
//import FirebaseAutUI

class LoginViewController: UIViewController {
    
    var showLogin: Bool = true
    var wasAlreadyLoggedIn: Bool = false
    var cameFromLogOut: Bool = false
    
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
    @IBOutlet weak var loginEmailTextField: KaedeTextField!
    @IBOutlet weak var loginPasswordTextField: KaedeTextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var loginMessageLabel: UILabel!
    
    // register outlets
    @IBOutlet weak var registerConfirmPasswordTextField: KaedeTextField!
    @IBOutlet weak var registerPasswordTextField: KaedeTextField!
    @IBOutlet weak var registerEmailTextField: KaedeTextField!
    @IBOutlet weak var registerLastNameTextField: KaedeTextField!
    @IBOutlet weak var registerFirstNameTextField: KaedeTextField!
    @IBOutlet weak var registerButton: UIButton!
    
    // colors
    let gradient = CAGradientLayer()
    var gradientSet = [[CGColor]]()
    var currentGradient: Int = 0
    
    let gradientOne = FlatOrange().cgColor
    let gradientTwo = FlatMagentaDark().cgColor
    let gradientThree = FlatRed().cgColor
    let gradientFour = FlatGreenDark().cgColor
    let gradientFive = FlatGray().cgColor
    let gradientSix = FlatYellowDark().cgColor
    let gradientSeven = FlatPowderBlue().cgColor
    
    var loadingScreen: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.gradientSet.append([self.gradientOne, self.gradientTwo])
        self.gradientSet.append([self.gradientTwo, self.gradientThree])
        self.gradientSet.append([self.gradientThree, self.gradientFour])
        self.gradientSet.append([self.gradientFour, self.gradientFive])
        self.gradientSet.append([self.gradientFive, self.gradientSix])
        self.gradientSet.append([self.gradientSix, self.gradientSeven])
        self.gradientSet.append([self.gradientSeven, self.gradientOne])
        
        self.gradient.frame = self.parentView.bounds
        self.gradient.colors = self.gradientSet[self.currentGradient]
        self.gradient.startPoint = CGPoint(x: 0, y: 0)
        self.gradient.endPoint = CGPoint(x: 1, y: 1)
        self.gradient.drawsAsynchronously = true
        
        self.contentView.layer.addSublayer(self.gradient)
        self.contentView.addSubview(self.loginBubbleView)
        
        if !cameFromLogOut {
            let loadingView = UIView()
            parentView.addSubview(loadingView)
            loadingView.backgroundColor = .white
            loadingView.translatesAutoresizingMaskIntoConstraints = false
            loadingView.centerXAnchor.constraint(equalTo: parentView.centerXAnchor, constant: 0).isActive = true
            loadingView.centerYAnchor.constraint(equalTo: parentView.centerYAnchor, constant: 0).isActive = true
            loadingView.heightAnchor.constraint(equalTo: parentView.heightAnchor, constant: 0).isActive = true
            loadingView.widthAnchor.constraint(equalTo: parentView.widthAnchor, constant: 0).isActive = true
            
            let logoImage = UIImageView()
            logoImage.image = #imageLiteral(resourceName: "logo_demo")
            loadingView.addSubview(logoImage)
            logoImage.translatesAutoresizingMaskIntoConstraints = false
            logoImage.contentMode = UIViewContentMode.scaleAspectFit
            logoImage.centerXAnchor.constraint(equalTo: loadingView.centerXAnchor, constant: 0).isActive = true
            logoImage.centerYAnchor.constraint(equalTo: loadingView.centerYAnchor, constant: 0).isActive = true
            
            loadingScreen = loadingView
        }
        
        self.hideKeyboardWhenTappedAround()
        
    }
    
    func load(view: UIView) {
        let transitionOptions: UIViewAnimationOptions = [.transitionFlipFromLeft]
        
        UIView.transition(with: self.parentView, duration: 1.0, options: transitionOptions, animations: {
            self.loadingScreen?.removeFromSuperview()
            
        }, completion: { (_) in
            
        })
    }
    
    func prepareTextFields() {
        
        // TODO: Replace this programmatically so they look better
        
        // login
        loginEmailTextField.backgroundColor = FlatWhiteDark()
        loginPasswordTextField.backgroundColor = FlatWhiteDark()
        
        // register
        registerFirstNameTextField.backgroundColor = FlatWhiteDark()
        registerLastNameTextField.backgroundColor = FlatWhiteDark()
        registerEmailTextField.backgroundColor = FlatWhiteDark()
        registerPasswordTextField.backgroundColor = FlatWhiteDark()
        registerConfirmPasswordTextField.backgroundColor = FlatWhiteDark()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        Auth.auth().addStateDidChangeListener { auth, user in
            if let user = user {
                // valid user is signed in
                print("LOG: \(user.displayName ?? "<NO NAME>") logged in")
                self.wasAlreadyLoggedIn = true
                self.performSegue(withIdentifier: "authenticationSuccessful", sender: nil)
            } else {
                if !self.cameFromLogOut {
                    print("LOG: could not authenticate session, proceeding to login screen")
                    self.load(view: self.loadingScreen!)
                } else {
                    if let loadingScreen = self.loadingScreen {
                        loadingScreen.removeFromSuperview()
                    }
                    print("LOG: loading login screen after successful logout")
                    self.loginEmailTextField.text = ""
                    self.loginPasswordTextField.text = ""
                    self.validLoginEmail = false
                    self.validLoginPassword = false
                    self.registerFirstNameTextField.text = ""
                    self.registerLastNameTextField.text = ""
                    self.registerEmailTextField.text = ""
                    self.registerPasswordTextField.text = ""
                    self.registerConfirmPasswordTextField.text = ""
                    self.validRegisterFirstName = false
                    self.validRegisterLastName = false
                    self.validRegisterEmail = false
                    self.validRegisterPassword = false
                    self.validRegisterConfirmPassword = false
                }
                
                self.loginBubbleView.backgroundColor = FlatWhite()
                self.prepareTextFields()
                self.updateUI()
                
                self.animateGradient()
                
                // TODO: need to turn off animation when view disappears
            }
        }
    }
    
    func animateGradient() {
        print("LOG: animating gradient")
        if currentGradient < gradientSet.count - 1 {
            currentGradient += 1
        } else {
            currentGradient = 0
        }
        
        let gradientChangeAnimation = CABasicAnimation(keyPath: "colors")
        gradientChangeAnimation.duration = 2.0
        gradientChangeAnimation.toValue = gradientSet[currentGradient]
        gradientChangeAnimation.fillMode = kCAFillModeForwards
        gradientChangeAnimation.isRemovedOnCompletion = false
        gradientChangeAnimation.delegate = self
        gradient.add(gradientChangeAnimation, forKey: "colorChange")
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
            registerButton.isHidden = true
            
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
            registerButton.isHidden = false
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
        validLoginEmail = isValidEmail(text) ? true : false
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
        if !validLoginButton {
            if !validLoginEmail {
                UIView.animate(withDuration: 0.1, animations: {
                    self.loginEmailTextField.transform = CGAffineTransform(rotationAngle: .pi / 50)
                }) { (_) in
                    UIView.animate(withDuration: 0.1, animations: {
                        self.loginEmailTextField.transform = CGAffineTransform(rotationAngle: .pi / -50)
                    }) { (_) in
                        UIView.animate(withDuration: 0.1, animations: {
                            self.loginEmailTextField.transform = CGAffineTransform(rotationAngle: .pi / 50)
                        }) { (_) in
                            UIView.animate(withDuration: 0.1) {
                                self.loginEmailTextField.transform = CGAffineTransform.identity
                            }
                        }
                    }
                }
            } else {
                UIView.animate(withDuration: 0.1, animations: {
                    self.loginPasswordTextField.transform = CGAffineTransform(rotationAngle: .pi / 50)
                }) { (_) in
                    UIView.animate(withDuration: 0.1, animations: {
                        self.loginPasswordTextField.transform = CGAffineTransform(rotationAngle: .pi / -50)
                    }) { (_) in
                        UIView.animate(withDuration: 0.1, animations: {
                            self.loginPasswordTextField.transform = CGAffineTransform(rotationAngle: .pi / 50)
                        }) { (_) in
                            UIView.animate(withDuration: 0.1) {
                                self.loginPasswordTextField.transform = CGAffineTransform.identity
                            }
                        }
                    }
                }
            }
        } else {
            HUD.show(.progress)
            Auth.auth().signIn(withEmail: loginEmailTextField.text!, password: loginPasswordTextField.text!) { (user, error) in
                if let user = user {
                    print("LOG: \(user.displayName!) successfully authenticated")
                    // TODO: why is it skipping this animation?
                    DispatchQueue.main.async {
                        HUD.flash(.success, delay: 1.0) { finished in
                            self.loginEmailTextField.text = ""
                            self.loginPasswordTextField.text = ""
                            self.validLoginEmail = false
                            self.validLoginPassword = false
                            self.registerFirstNameTextField.text = ""
                            self.registerLastNameTextField.text = ""
                            self.registerEmailTextField.text = ""
                            self.registerPasswordTextField.text = ""
                            self.registerConfirmPasswordTextField.text = ""
                            self.validRegisterFirstName = false
                            self.validRegisterLastName = false
                            self.validRegisterEmail = false
                            self.validRegisterPassword = false
                            self.validRegisterConfirmPassword = false
                            self.performSegue(withIdentifier: "authenticationSuccessful", sender: nil)
                        }
                    }
                } else {
                    HUD.flash(.error, delay: 1.0)
                    print(error?.localizedDescription ?? "ERROR: Could not print the error! See LoginViewController, after user could not be authenticated")
                }
            }
            
        }
    }
    
    // register actions
    @IBAction func registerFirstNameTextFieldChanged(_ sender: UITextField) {
        guard let text = registerFirstNameTextField.text else { return }
        validRegisterFirstName = text.count >= 1 ? true : false
    }
    
    @IBAction func registerLastNameTextFieldChanged(_ sender: UITextField) {
        guard let text = registerLastNameTextField.text else { return }
        validRegisterLastName = text.count >= 1 ? true : false
    }
    
    @IBAction func registerEmailTextFieldChanged(_ sender: UITextField) {
        guard let text = registerEmailTextField.text else { return }
        validRegisterEmail = isValidEmail(text) ? true : false
    }
    
    @IBAction func registerPasswordTextFieldChanged(_ sender: UITextField) {
        guard let text = registerPasswordTextField.text else { return }
        validRegisterPassword = text.count >= 8 ? true : false
    }
    
    @IBAction func registerConfirmPasswordTextFieldChanged(_ sender: UITextField) {
        guard let passwordText = registerPasswordTextField.text else { return }
        guard let confirmText = registerConfirmPasswordTextField.text else { return }
        validRegisterConfirmPassword = passwordText == confirmText ? true : false
    }
    
    @IBAction func createAccountButtonPressed(_ sender: UIButton) {
        
        let db = Firestore.firestore()
        let settings = db.settings
        settings.areTimestampsInSnapshotsEnabled = true
        db.settings = settings
        
        if !validRegisterButton {
            if !validRegisterFirstName {
                UIView.animate(withDuration: 0.1, animations: {
                    self.registerFirstNameTextField.transform = CGAffineTransform(rotationAngle: .pi / 50)
                }) { (_) in
                    UIView.animate(withDuration: 0.1, animations: {
                        self.registerFirstNameTextField.transform = CGAffineTransform(rotationAngle: .pi / -50)
                    }) { (_) in
                        UIView.animate(withDuration: 0.1, animations: {
                            self.registerFirstNameTextField.transform = CGAffineTransform(rotationAngle: .pi / 50)
                        }) { (_) in
                            UIView.animate(withDuration: 0.1) {
                                self.registerFirstNameTextField.transform = CGAffineTransform.identity
                            }
                        }
                    }
                }
            } else if !validRegisterLastName {
                UIView.animate(withDuration: 0.1, animations: {
                    self.registerLastNameTextField.transform = CGAffineTransform(rotationAngle: .pi / 50)
                }) { (_) in
                    UIView.animate(withDuration: 0.1, animations: {
                        self.registerLastNameTextField.transform = CGAffineTransform(rotationAngle: .pi / -50)
                    }) { (_) in
                        UIView.animate(withDuration: 0.1, animations: {
                            self.registerLastNameTextField.transform = CGAffineTransform(rotationAngle: .pi / 50)
                        }) { (_) in
                            UIView.animate(withDuration: 0.1) {
                                self.registerLastNameTextField.transform = CGAffineTransform.identity
                            }
                        }
                    }
                }
            } else if !validRegisterEmail {
                UIView.animate(withDuration: 0.1, animations: {
                    self.registerEmailTextField.transform = CGAffineTransform(rotationAngle: .pi / 50)
                }) { (_) in
                    UIView.animate(withDuration: 0.1, animations: {
                        self.registerEmailTextField.transform = CGAffineTransform(rotationAngle: .pi / -50)
                    }) { (_) in
                        UIView.animate(withDuration: 0.1, animations: {
                            self.registerEmailTextField.transform = CGAffineTransform(rotationAngle: .pi / 50)
                        }) { (_) in
                            UIView.animate(withDuration: 0.1) {
                                self.registerEmailTextField.transform = CGAffineTransform.identity
                            }
                        }
                    }
                }
            } else if !validRegisterPassword {
                UIView.animate(withDuration: 0.1, animations: {
                    self.registerPasswordTextField.transform = CGAffineTransform(rotationAngle: .pi / 50)
                }) { (_) in
                    UIView.animate(withDuration: 0.1, animations: {
                        self.registerPasswordTextField.transform = CGAffineTransform(rotationAngle: .pi / -50)
                    }) { (_) in
                        UIView.animate(withDuration: 0.1, animations: {
                            self.registerPasswordTextField.transform = CGAffineTransform(rotationAngle: .pi / 50)
                        }) { (_) in
                            UIView.animate(withDuration: 0.1) {
                                self.registerPasswordTextField.transform = CGAffineTransform.identity
                            }
                        }
                    }
                }
            } else {
                UIView.animate(withDuration: 0.1, animations: {
                    self.registerConfirmPasswordTextField.transform = CGAffineTransform(rotationAngle: .pi / 50)
                }) { (_) in
                    UIView.animate(withDuration: 0.1, animations: {
                        self.registerConfirmPasswordTextField.transform = CGAffineTransform(rotationAngle: .pi / -50)
                    }) { (_) in
                        UIView.animate(withDuration: 0.1, animations: {
                            self.registerConfirmPasswordTextField.transform = CGAffineTransform(rotationAngle: .pi / 50)
                        }) { (_) in
                            UIView.animate(withDuration: 0.1) {
                                self.registerConfirmPasswordTextField.transform = CGAffineTransform.identity
                            }
                        }
                    }
                }
            }
        } else {
            HUD.show(.progress)
            Auth.auth().createUser(withEmail: registerEmailTextField.text!, password: registerPasswordTextField.text!) { (user, error) in
                if let user = user {
                    let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                    changeRequest?.displayName = "\(self.registerFirstNameTextField.text!) \(self.registerLastNameTextField.text!)"
                    changeRequest?.commitChanges(completion: { (error) in
                        if let error = error {
                            print(error.localizedDescription)
                        }
                    })
                    
                    let fullName = "\(self.registerFirstNameTextField.text!) \(self.registerLastNameTextField.text!)"
                    
                    // initialize new record in Firestore
                    db.collection("users").document("\(user.uid)").setData([
                        "name": "\(fullName)",
                        "profile": "",
                        "cover": ""
                    ]) { err in
                        if let err = err {
                            print("ERROR: Could not write to document, with error \(err)")
                        } else {
                            print("LOG: initialized name and picture for user \(user.uid)")
                        }
                    }
                    db.collection("users").document("\(user.uid)").collection("posts").addDocument(data: [:]) { err in
                        if let err = err {
                            print("ERROR: Could not write to document, with error \(err)")
                        } else {
                            print("LOG: initialized posts for user \(user.uid)")
                        }
                    }
                    db.collection("users").document("\(user.uid)").collection("products").addDocument(data: [:]) { err in
                        if let err = err {
                            print("ERROR: Could not write to document, with error \(err)")
                        } else {
                            print("LOG: initialized products for user \(user.uid)")
                        }
                    }
                    db.collection("users").document("\(user.uid)").collection("connections").addDocument(data: [:]) { err in
                        if let err = err {
                            print("ERROR: Could not write to document, with error \(err)")
                        } else {
                            print("LOG: initialized connections for user \(user.uid)")
                        }
                    }
                    db.collection("users").document("\(user.uid)").collection("votes").addDocument(data: [:]) { err in
                        if let err = err {
                            print("ERROR: Could not write to document, with error \(err)")
                        } else {
                            print("LOG: initialized votes for user \(user.uid)")
                        }
                    }
                    
                    print("LOG: Account for \(fullName) created successfully")
                    
                    // TODO: why tf is it skipping this animation?
                    HUD.flash(.success, delay: 1.0) { finished in
                        self.loginEmailTextField.text = ""
                        self.loginPasswordTextField.text = ""
                        self.validLoginEmail = false
                        self.validLoginPassword = false
                        self.registerFirstNameTextField.text = ""
                        self.registerLastNameTextField.text = ""
                        self.registerEmailTextField.text = ""
                        self.registerPasswordTextField.text = ""
                        self.registerConfirmPasswordTextField.text = ""
                        self.validRegisterFirstName = false
                        self.validRegisterLastName = false
                        self.validRegisterEmail = false
                        self.validRegisterPassword = false
                        self.validRegisterConfirmPassword = false
                        self.performSegue(withIdentifier: "authenticationSuccessful", sender: nil)
                        print("LOG: would perform segue here")
                    }
                } else {
                    HUD.flash(.error, delay: 1.0)
                    if let error = error {
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if wasAlreadyLoggedIn {
            if let destination = segue.destination as? FeedViewController {
                destination.transitionStyle = .flipHorizontal
            }
        }
    }
    
    @IBAction func unwindToLoginScreen(segue: UIStoryboardSegue) {
        print("LOG: logout successful")
        self.cameFromLogOut = true
    }
}

extension LoginViewController: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag {
            gradient.colors = gradientSet[currentGradient]
            animateGradient()
        }
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
