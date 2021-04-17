//
//  GetChatAllMessageDetailEntity.swift
//  ChanceUpon
//
//  Created by Dharmani Apps mini on 12/15/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation

struct GetChatAllMessagesDetailData<T>{

    var status:String
    var alertMessage:String
    var lastPage:String
    
    var allMessagesArr:[[String:T]]
    var recieverUserDetails:OtherUserDetails<T>


    init?(dict:[String:T]) {
        let status  = dict["status"] as? String ?? ""
        let alertMessage = dict["message"] as? String ?? ""
        let lastPage = dict["last_page"] as? String ?? ""
      

        let allMessagesArr = dict["all_messages"] as? [[String:T]] ?? [[:]]
        let recieverUserDetailsDict = dict["receiver_detail"] as? [String:T] ?? [:]
        let recieverUserDetailsStruct = OtherUserDetails(dict: recieverUserDetailsDict)!

        self.status = status
        self.alertMessage = alertMessage
        self.lastPage = lastPage
        self.allMessagesArr = allMessagesArr
        self.recieverUserDetails = recieverUserDetailsStruct
      
    }
}
//{
//    "status": "1",
//    "message": "List Of Messages",
//    "roomID": "BDwp#RagllqYVH7K%$kx1@x8sCeAwDld?P$wk14%YHpFT3qrQa",
//    "all_messages": [
//        {
//            "id": "32",
//            "userID": "4",
//            "otherID": "1",
//            "roomID": "BDwp#RagllqYVH7K%$kx1@x8sCeAwDld?P$wk14%YHpFT3qrQa",
//            "message": "fine bro",
//            "created": "1607662218",
//            "userProfileImage": "",
//            "username": "mandeep123",
//            "otherUserName": "hukan12"
//        }
//
//    ],
//    "last_page": "TRUE",
//    "receiver_detail": {
//        "userID": "4",
//        "name": "mandeep123",
//        "email": "dharmaniz.mandeepsharma@gmail123.com",
//        "password": "379dc6ee0bce9c1e41a498b0b9061cce",
//        "verificationCode": "9Y3JYB",
//        "verified": "1",
//        "image": "",
//        "gender": "2",
//        "genderCat": "0",
//        "age": "18",
//        "DOB": "",
//        "phoneNo": "",
//        "showMe": "0",
//        "mode": "0",
//        "startAge": "0",
//        "endAge": "0",
//        "occupation": "",
//        "closeAccount": "0",
//        "appleToken": "abvsdef",
//        "facebookToken": "",
//        "created": "1599027171",
//        "authDetails": {
//            "id": "10",
//            "userID": "4",
//            "authToken": "#NuFDPCr*%i3ZktBp4Wy%DIRHjyAj$$qs!TiojT0WZq?C9$7Gn",
//            "log": "76.743598",
//            "lat": "30.680512",
//            "deviceToken": "abcde",
//            "deviceType": "1",
//            "created": "1599031372"
//        }
//    }
//}
//
