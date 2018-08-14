//
//  LoginVC.swift
//  DrCRYPTO
//
//  Created by 갓거 on 2018. 8. 10..
//  Copyright © 2018년 Dr.CRYPTO. All rights reserved.
//

import UIKit

class LoginVC : UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet var logoImageView: UIImageView!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var signUpButton: UIButton!
    @IBOutlet var loginStackView: UIStackView!
    @IBOutlet var buttonStackView: UIStackView!
    @IBOutlet var centerYConstraint: NSLayoutConstraint!
    @IBOutlet var logoCenterYConstraint: NSLayoutConstraint!
    
    var check = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap_mainview(_:)))
        tap.delegate = self
        self.view.addGestureRecognizer(tap)
        splashView()
        loginView()
        initAddTarget()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0) {
            self.logoAnimation()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        unregisterForKeyboardNotifications()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
        registerForKeyboardNotifications()
    }
}

extension LoginVC {
    
    @objc func loginButtonAction(){
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = mainStoryboard.instantiateViewController(withIdentifier: "TabBarVC") as! TabBarVC
        UIApplication.shared.keyWindow?.rootViewController = viewController
    }
    
    func navigaionBarSetting(){
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.title = " "
    }
    
    func splashView(){
        logoCenterYConstraint.constant = -30
        centerYConstraint.constant = 90
        loginStackView.alpha = 0.0
        buttonStackView.alpha = 0.0
    }
    
    func logoAnimation(){
        logoCenterYConstraint.constant = -149.5
        UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0, options: .curveEaseIn, animations: {
            self.view.layoutIfNeeded()
            self.centerYConstraint.constant = 44.9
            self.loginStackView.fadeIn()
            self.buttonStackView.fadeIn()
            
            UIView.animate(withDuration: 0.725, delay: 0.075, usingSpringWithDamping: 1.0, initialSpringVelocity: 0, options: .curveEaseIn, animations: {
                self.view.layoutIfNeeded()
            })
        })
    }
    
    func loginView(){
        emailTextField.delegate = self
        passwordTextField.delegate = self
        emailTextField.addBorderBottom(height: 1.0, color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.63))
        passwordTextField.addBorderBottom(height: 1.0, color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.63))
        emailTextField.attributedPlaceholder = NSAttributedString(
            string: "이메일을 입력하세요.",
            attributes: [NSAttributedStringKey.foregroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.43)]
        )
        passwordTextField.attributedPlaceholder = NSAttributedString(
            string: "비밀번호를 입력하세요.",
            attributes: [NSAttributedStringKey.foregroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.43)]
        )
        unableLoginBtn()
    }
    
    //MARK: Outlet Add Action
    func initAddTarget(){
        loginButton.addTarget(self, action: #selector(loginButtonAction), for: .touchUpInside)
        signUpButton.addTarget(self, action: #selector(signupButtonAction), for: .touchUpInside)
        emailTextField.addTarget(self, action: #selector(isValid), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(isValid), for: .editingChanged)
    }
    
    @objc func signupButtonAction(){
        guard let joinVC = self.storyboard?.instantiateViewController(
            withIdentifier : "JoinVC"
            ) as? JoinVC
            else{return}
        self.navigationController?.pushViewController(joinVC, animated: true)
    }
    
    //MARK: Login Button isEnabled
    func unableLoginBtn(){
        self.loginButton.isEnabled = false
    }
    func enableLoginBtn(){
        self.loginButton.isEnabled = true
    }
    
    //MARK: LoginTextField isEmpty 검사
    @objc func isValid(){
        if !((emailTextField.text?.isEmpty)! || (passwordTextField.text?.isEmpty)!) {
            enableLoginBtn()
        }
        else {
            unableLoginBtn()
        }
    }
    
    //MARK: Keyboard Up Method
    func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldReceive touch: UITouch
        ) -> Bool {
        if(touch.view?.isDescendant(of: loginStackView))!{
            return false
        }
        return true
    }
    @objc func handleTap_mainview(_ sender: UITapGestureRecognizer?){
        self.loginStackView.becomeFirstResponder()
        self.loginStackView.resignFirstResponder()
        
    }
    
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector:#selector(keyboardWillShow),
            name: .UIKeyboardWillShow,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector:#selector(keyboardWillHide),
            name: .UIKeyboardWillHide,
            object: nil
        )
    }
    func unregisterForKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name:.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name:.UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if check {
            if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey]
                as? NSValue)?.cgRectValue {
                centerYConstraint.constant = -10
                check = false
                view.layoutIfNeeded()
            }
        }
    }
    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey]
            as? NSValue)?.cgRectValue {
            centerYConstraint.constant = 44.5
            check = true
            view.layoutIfNeeded()
        }
    }
    
    override func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            textField.resignFirstResponder()
        }
        return true
    }
    
    
}
