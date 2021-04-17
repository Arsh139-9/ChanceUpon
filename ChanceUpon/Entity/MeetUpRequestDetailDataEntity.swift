//
//  MeetUpRequestDetailDataEntity.swift
//  ChanceUpon
//
//  Created by Dharmani Apps mini on 12/18/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation

struct MeetUpRequestData<T>{
    var status:String
    var alertMessage:String
    var meetUpRequestDataDetails:MeetUpRequestDetails<T>
    var meetUpRequestDetailDict:[String:T]
    
    init?(dict:[String:T]) {
        let status  = dict["status"] as? String ?? ""
        let alertMessage = dict["message"] as? String ?? ""
        let dataDict = dict["data"] as? [String:T] ?? [:]
        let meetUpRequestDetailStruct = MeetUpRequestDetails.init(dict: dataDict)
        
        self.status = status
        self.alertMessage = alertMessage
        self.meetUpRequestDataDetails = meetUpRequestDetailStruct!
        self.meetUpRequestDetailDict = dataDict
    }
}
struct MeetUpRequestDetails<T>{
    var id:String
    var userID:String
    var otherID:String
    var roomID:String
    var meetStatus:String
    var created:String
   

    init?(dict:[String:T]) {
    let id = dict["id"] as? String ?? ""
    let userID = dict["userID"] as? String ?? ""
    let otherID = dict["otherID"] as? String ?? ""
    let roomID = dict["roomID"] as? String ?? ""
    let meetStatus = dict["meetStatus"] as? String ?? ""
    let created = dict["created"] as? String ?? ""
 

        self.id = id
        self.userID = userID
        self.otherID = otherID
        self.roomID = roomID
        self.meetStatus = meetStatus
        self.created = created
       
        
    }
}
