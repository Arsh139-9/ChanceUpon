//
//  MeetUpDetailEntity.swift
//  ChanceUpon
//
//  Created by Dharmani Apps mini on 12/14/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation

struct MeetUpUserDetailData<T>{

    var status:String
    var alertMessage:String
    var meetLastPage:String
    var currentLastPage:String
    var sendLastPage:String
    var meetUpRequestArr:[[String:T]]
    var currentChatArr:[[String:T]]
    var sendInterestsArr:[[String:T]]

    init?(dict:[String:T]) {
        let status  = dict["status"] as? String ?? ""
        let alertMessage = dict["message"] as? String ?? ""
        let meetLastPage = dict["meet_last_page"] as? String ?? ""
        let currentLastPage = dict["current_last_page"] as? String ?? ""
        let sendLastPage = dict["send_last_page"] as? String ?? ""

        let meetUpRequestArr = dict["meetUpRequest"] as? [[String:T]] ?? [[:]]
        let currentChatArr = dict["currentChat"] as? [[String:T]] ?? [[:]]
        let sendInterestsArr = dict["sendInterests"] as? [[String:T]] ?? [[:]]

        self.status = status
        self.alertMessage = alertMessage
        self.meetLastPage = meetLastPage
        self.currentLastPage = currentLastPage
        self.sendLastPage = sendLastPage
        self.meetUpRequestArr = meetUpRequestArr
        self.currentChatArr = currentChatArr
        self.sendInterestsArr = sendInterestsArr

    }
}


//{
//    "status": "1",
//    "message": "All user lists.",
//    "meetUpRequest": [
//        {
//            "id": "41",
//            "userID": "4",
//            "otherID": "1",
//            "roomID": "6cZfg4!TnZ0SWDIM7UPFVXGtjO#vyUtciIxdoK7AGvQi8h?*Ij",
//            "chatStatus": "1",
//            "created": "1599197557",
//            "name": "mandeep123",
//            "image": ""
//        }
//    ],
//    "meet_last_page": "TRUE",
//    "currentChat": [
//        {
//            "id": "40",
//            "userID": "1",
//            "otherID": "4",
//            "roomID": "BDwp#RagllqYVH7K%$kx1@x8sCeAwDld?P$wk14%YHpFT3qrQa",
//            "chatStatus": "1",
//            "created": "1599197462",
//            "name": "hukan12",
//            "image": "https://www.dharmani.com/ChanceUpon/webservices/profileImage/5f730d3961564.png",
//            "lastMessage": "fine bro"
//        }
//    ],
//    "current_last_page": "TRUE",
//    "sendInterests": [
//        {
//            "id": "40",
//            "userID": "1",
//            "otherID": "4",
//            "roomID": "BDwp#RagllqYVH7K%$kx1@x8sCeAwDld?P$wk14%YHpFT3qrQa",
//            "chatStatus": "1",
//            "created": "1599197462",
//            "name": "mandeep123",
//            "image": ""
//        }
//    ],
//    "send_last_page": "TRUE"
//}



