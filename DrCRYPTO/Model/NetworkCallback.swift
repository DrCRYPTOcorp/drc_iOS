//
//  NetworkCallback.swift
//  DrCRYPTO
//
//  Created by 갓거 on 2018. 8. 13..
//  Copyright © 2018년 Dr.CRYPTO. All rights reserved.
//

protocol NetworkCallback {
    
    func networkResult(resultData:Any, code:String)
    func networkFailed()
    
}
