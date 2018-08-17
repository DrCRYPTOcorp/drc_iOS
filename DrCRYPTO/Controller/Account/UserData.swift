//
//  UserData.swift
//  DrCRYPTO
//
//  Created by 갓거 on 2018. 8. 16..
//  Copyright © 2018년 Dr.CRYPTO. All rights reserved.
//

import Foundation

class UserData: NSObject {
    
    var name: String
    var birth: String
    var email: String
    var gender: String
    var uid: String
    
    
    init(name:String, birth:String,
         email:String, gender:String,
         uid:String) {
        
        self.name       = name
        self.birth       = birth
        self.email       = email
        self.gender       = gender
        self.uid       = uid
    }
    
    convenience override init() {
        self.init(name: "", birth: "",
                  email: "", gender: "",
                  uid: "")
    }
}
