//
//  UserUpdateLocationEntity.swift
//  ChanceUpon
//
//  Created by Dharmani Apps mini on 1/12/21.
//  Copyright © 2021 Apple. All rights reserved.
//

import Foundation

struct UpdateLocationData<T>:Codable{
    var status:String
    var alertMessage:String
    var notificationBadgeCount:String

    init?(dict:[String:T]) {
        let status  = dict["status"] as? String ?? ""
        let alertMessage = dict["message"] as? String ?? ""
        let notificationBadgeCount = dict["count"] as? String ?? ""

        self.status = status
        self.alertMessage = alertMessage
        self.notificationBadgeCount = notificationBadgeCount

    }
}
