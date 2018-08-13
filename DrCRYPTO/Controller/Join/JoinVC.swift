//
//  JoinVC.swift
//  DrCRYPTO
//
//  Created by 갓거 on 2018. 8. 13..
//  Copyright © 2018년 Dr.CRYPTO. All rights reserved.
//

import UIKit

class JoinVC : UIViewController {
    
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var genderTextField: UITextField!
    @IBOutlet var birthTextField: UITextField!
    @IBOutlet var idTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var confirmPasswordTextField: UITextField!
    @IBOutlet var doneButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingView()
    }
}

extension JoinVC {
    
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
        
        
    }
}
