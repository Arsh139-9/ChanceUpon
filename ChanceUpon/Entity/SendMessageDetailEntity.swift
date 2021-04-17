//
//  SendMessageDetailEntity.swift
//  ChanceUpon
//
//  Created by Dharmani Apps mini on 12/15/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation

struct SendMessageDetailData<T>{
    var status:String
    var alertMessage:String
    var sendMessageDataDetails:SendMessageDetails<T>
    var sendMessageDetailDict:[String:T]
    
    init?(dict:[String:T]) {
        let status  = dict["status"] as? String ?? ""
        let alertMessage = dict["message"] as? String ?? ""
        let dataDict = dict["data"] as? [String:T] ?? [:]
        let sendMessageDetailStruct = SendMessageDetails.init(dict: dataDict)
        
        self.status = status
        self.alertMessage = alertMessage
        self.sendMessageDataDetails = sendMessageDetailStruct!
        self.sendMessageDetailDict = dataDict
    }
}
struct SendMessageDetails<T>{
    var id:String
    var userID:String
    var otherID:String
    var roomID:String
    var message:String
    var created:String
    var userProfileImage:String
    var username:String
    var otherUserName:String

    init?(dict:[String:T]) {
    let id = dict["id"] as? String ?? ""
    let userID = dict["userID"] as? String ?? ""
    let otherID = dict["otherID"] as? String ?? ""
    let roomID = dict["roomID"] as? String ?? ""
    let message = dict["message"] as? String ?? ""
    let created = dict["created"] as? String ?? ""
    let userProfileImage = dict["userProfileImage"] as? String ?? ""
    let username = dict["username"] as? String ?? ""
    let otherUserName = dict["otherUserName"] as? String ?? ""

        self.id = id
        self.userID = userID
        self.otherID = otherID
        self.roomID = roomID
        self.message = message
        self.created = created
        self.userProfileImage = userProfileImage
        self.username = username
        self.otherUserName = otherUserName
        
    }
}
