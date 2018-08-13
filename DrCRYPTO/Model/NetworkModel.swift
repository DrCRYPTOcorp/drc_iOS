//
//  NetworkModel.swift
//  DrCRYPTO
//
//  Created by 갓거 on 2018. 8. 13..
//  Copyright © 2018년 Dr.CRYPTO. All rights reserved.
//

class NetworkModel {
    
    var view : NetworkCallback
    
    init(_ vc : NetworkCallback){
        self.view = vc
    }
    
    let baseURL = "http://192.168.45.48:8000"
}
