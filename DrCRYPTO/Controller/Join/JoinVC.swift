//
//  JoinVC.swift
//  DrCRYPTO
//
//  Created by 갓거 on 2018. 8. 13..
//  Copyright © 2018년 Dr.CRYPTO. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class JoinVC : UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var genderTextField: UITextField!
    @IBOutlet var birthTextField: UITextField!
    @IBOutlet var idTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var confirmPasswordTextField: UITextField!
    @IBOutlet var doneButton: UIButton!
    @IBOutlet var centerYConstraint: NSLayoutConstraint!
    @IBOutlet var joinStackView: UIStackView!
    
    var genderArray = ["남자", "여자"]
    var sex = ""
    var check = true
    
    let genderPickerView = UIPickerView()
    let datePickerView = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap_mainview(_:)))
        tap.delegate = self
        self.view.addGestureRecognizer(tap)
        settingView()
        initAddTarget()
        unableDoneBtn()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigaionBarSetting()
        registerForKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        unregisterForKeyboardNotifications()
    }

    @IBAction func birthPickerEditing(_ sender: UITextField) {
        datePickerView.backgroundColor = UIColor.white
        datePickerView.datePickerMode = UIDatePickerMode.date
        datePickerView.maximumDate = Calendar.current.date(byAdding: .year, value: -16, to: Date())
        datePickerView.minimumDate = Calendar.current.date(byAdding: .year, value: -100, to: Date())
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
    }
    
}

extension JoinVC : UIPickerViewDataSource, UIPickerViewDelegate {
    
    //MARK: Date PickerView value Change Method
    @objc func datePickerValueChanged(sender:UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        birthTextField.text = dateFormatter.string(from: sender.date)
    }
    
    func initAddTarget(){
        nameTextField.addTarget(self, action: #selector(isValid), for: .editingChanged)
        birthTextField.addTarget(self, action: #selector(isValid), for: .editingChanged)
        genderTextField.addTarget(self, action: #selector(isValid), for: .editingChanged)
        idTextField.addTarget(self, action: #selector(isValid), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(isValid), for: .editingChanged)
        confirmPasswordTextField.addTarget(self, action: #selector(isValid), for: .editingChanged)
        confirmPasswordTextField.addTarget(self, action: #selector(passwordConfirmCheck), for: .editingChanged)
        doneButton.addTarget(self, action: #selector(doneButtonAction), for: .touchUpInside)
    }
    
    func navigaionBarSetting(){
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: UIFont(name: "NanumBarunGothicBold", size: 20)!]
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey(rawValue: NSAttributedStringKey.foregroundColor.rawValue): UIColor.white]
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.title = "회원가입"
    }
    
    func settingView(){
        nameTextField.delegate = self
        genderTextField.delegate = self
        birthTextField.delegate = self
        idTextField.delegate = self
        passwordTextField.delegate = self
        confirmPasswordTextField.delegate = self
        
        nameTextField.addBorderBottom(height: 1.0, color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.63))
        genderTextField.addBorderBottom(height: 1.0, color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.63))
        birthTextField.addBorderBottom(height: 1.0, color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.63))
        idTextField.addBorderBottom(height: 1.0, color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.63))
        passwordTextField.addBorderBottom(height: 1.0, color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.63))
        confirmPasswordTextField.addBorderBottom(height: 1.0, color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.63))
        
        genderPickerView.delegate = self
        genderPickerView.dataSource = self
        genderPickerView.backgroundColor = UIColor.white
        genderPickerView.showsSelectionIndicator = true
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 4/255, green: 141/255, blue: 129/255, alpha: 1)
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "확인", style: UIBarButtonItemStyle.done, target: self, action: #selector(donePicker))
        let cancelButton = UIBarButtonItem(title: "취소", style: UIBarButtonItemStyle.plain, target: self, action: #selector(donePicker))
        
        toolBar.setItems([cancelButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        genderTextField.inputView = genderPickerView
        genderTextField.inputAccessoryView = toolBar
        
        birthTextField.inputAccessoryView = toolBar
    }
    
    //MARK: TextField isEmpty 검사
    @objc func isValid(){
        if !((nameTextField.text?.isEmpty)! || (idTextField.text?.isEmpty)! || (birthTextField.text?.isEmpty)! ||  (genderTextField.text?.isEmpty)! || (passwordTextField.text?.isEmpty)! || (confirmPasswordTextField.text?.isEmpty)!) {
            enableDoneBtn()
        }
        else {
            unableDoneBtn()
        }
    }
    
    //MARK: Confirm Check Method
    @objc func passwordConfirmCheck(){
        if passwordTextField.text == confirmPasswordTextField.text {
            confirmPasswordTextField.textColor = UIColor.white
        }
        else {
            confirmPasswordTextField.textColor = UIColor.red
        }
        isValid()
    }
    
    //MARK: Gender PickerView Delegate
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return genderArray.count
    }
    func pickerView(_ pickerView: UIPickerView,titleForRow row: Int,forComponent component: Int) -> String? {
        return genderArray[row]
    }
    func pickerView(_ pickerView: UIPickerView,didSelectRow row: Int,inComponent component: Int) {
        genderTextField.text = genderArray[row]
        switch gsno(genderTextField.text) {
        case "남자":
            sex = "남자"
        case "여자":
            sex = "여자"
        default:
            break
        }
    }
    
    @objc func doneButtonAction(){
        Auth.auth().createUser(withEmail: gsno(idTextField.text), password: gsno(confirmPasswordTextField.text)
        ) { (user, error) in
            if user !=  nil{
                
                //MARK: Firebase Database User Data Save - UID 구분
                Database.database().reference().child("users/\(self.gsno(user?.user.uid))").setValue([
                    "email" : self.gsno(self.idTextField.text),
                    "uid": self.gsno(user?.user.uid),
                    "name": self.gsno(self.nameTextField.text),
                    "gender": self.gsno(self.genderTextField.text),
                    "birth": self.gsno(self.birthTextField.text)
                    ])
                self.performSegue(withIdentifier: "unwindToSplash", sender: self)
            }
            else{
                print("register failed")
            }
            
        }
    }
    
    @objc func donePicker() {
        genderTextField.resignFirstResponder()
        birthTextField.resignFirstResponder()
    }
    
    //MARK: Login Button isEnabled
    func unableDoneBtn(){
        self.doneButton.isEnabled = false
        self.doneButton.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.21).cgColor
        self.doneButton.layer.shadowOffset = CGSize(width: 0, height: 8)
        self.doneButton.layer.shadowRadius = 23
        self.doneButton.layer.shadowOpacity = 1.0
        self.doneButton.layer.masksToBounds = false
        
    }
    func enableDoneBtn(){
        self.doneButton.isEnabled = true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == genderTextField{
            self.genderPickerView.selectRow(0, inComponent: 0, animated: true)
            self.pickerView(genderPickerView, didSelectRow: 0, inComponent: 0)
        }
        else if textField == idTextField {
            self.centerYConstraint.constant = -45
            UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    override func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nameTextField {
            genderTextField.becomeFirstResponder()
        } else if textField == genderTextField{
            birthTextField.becomeFirstResponder()
        } else if textField == birthTextField{
            idTextField.becomeFirstResponder()
        } else if textField == idTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField{
            confirmPasswordTextField.becomeFirstResponder()
        } else if textField == confirmPasswordTextField {
            textField.resignFirstResponder()
        }
        return true
    }
    
    //MARK: Keyboard Up Method
    func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldReceive touch: UITouch
        ) -> Bool {
        if(touch.view?.isDescendant(of: joinStackView))!{
            return false
        }
        return true
    }
    @objc func handleTap_mainview(_ sender: UITapGestureRecognizer?){
        self.joinStackView.becomeFirstResponder()
        self.joinStackView.resignFirstResponder()
        
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
                centerYConstraint.constant = -80
                check = false
                view.layoutIfNeeded()
            }
        }
    }
    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey]
            as? NSValue)?.cgRectValue {
            centerYConstraint.constant = -45
            check = true
            view.layoutIfNeeded()
        }
    }
}
