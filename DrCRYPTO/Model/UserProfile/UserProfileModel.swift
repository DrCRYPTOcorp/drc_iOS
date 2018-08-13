//
//  UserProfileModel.swift
//  DrCRYPTO
//
//  Created by 갓거 on 2018. 8. 13..
//  Copyright © 2018년 Dr.CRYPTO. All rights reserved.
//

import Alamofire
import AlamofireObjectMapper

class UserProfileModel : NetworkModel{
    
    func profileShowingNetwork(userID: Int) {
        
        let URL = "\(baseURL)/doctor/app/profile/\(userID)"
        
        Alamofire.request(
            URL,
            method: .get,
            parameters: nil,
            encoding: JSONEncoding.default,
            headers: nil
            ).responseObject{
                (response:DataResponse<UserProfileVO>) in
                switch response.result {
                case .success:
                    guard let responseMessage = response.result.value else{
                        self.view.networkFailed()
                        return
                    }
                    self.view.networkResult(resultData: responseMessage, code: "Success")

                case .failure(let err):
                    print(err)
                    self.view.networkFailed()
                }
        }
    }
    
    func test(){
        
        let URL = "\(baseURL)/doctor/app/doctor_form/"
        
        Alamofire.request(
            URL,
            method: .get,
            parameters: nil,
            encoding: JSONEncoding.default,
            headers: nil
            ).responseObject{
                (response:DataResponse<UserProfileVO>) in
                switch response.result {
                case .success:
                    guard let responseMessage = response.result.value else{
                        self.view.networkFailed()
                        return
                    }
                    self.view.networkResult(resultData: responseMessage, code: "Success")
                    
                case .failure(let err):
                    print(err)
                    self.view.networkFailed()
                }
        }
    }
}
