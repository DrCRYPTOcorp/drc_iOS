//
//  UserProfileVO.swift
//  DrCRYPTO
//
//  Created by 갓거 on 2018. 8. 13..
//  Copyright © 2018년 Dr.CRYPTO. All rights reserved.
//

import ObjectMapper

class UserProfileVO : Mappable {
    
    var id : Int?
    var password : String?
    var last_login : String?
    var is_superuser : Bool?
    var username : String?
    var first_name : String?
    var last_name : String?
    var email : String?
    var is_staff : Bool?
    var is_active : Bool?
    var date_joined : String?
    var group : [String]?
    var user_permissions : [String]?
    var detail : String?
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        detail <- map["detail"]
    }
}
