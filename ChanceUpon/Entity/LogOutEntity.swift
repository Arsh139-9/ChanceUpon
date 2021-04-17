//
//  LogOutEntity.swift
//  ChanceUpon
//
//  Created by Dharmani Apps mini on 11/21/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation

struct LogOutData<T>:Codable{
    var status:String
    var alertMessage:String
    
    init?(dict:[String:T]) {
        let status  = dict["status"] as? String ?? ""
        let alertMessage = dict["message"] as? String ?? ""
        
        self.status = status
        self.alertMessage = alertMessage
    }
}
