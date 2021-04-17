//
//  LikedUserEntity.swift
//  ChanceUpon
//
//  Created by Dharmani Apps mini on 12/10/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation


struct LikedUserData<T>{


    var status:String
    var alertMessage:String
    var likedUserRequestData:LikedUserRequestData<T>
    var userDetails:OtherUserDetails<T>
    var otherUserDetails:OtherUserDetails<T>

    init?(dict:[String:T]) {
        let status  = dict["status"] as? String ?? ""
        let alertMessage = dict["message"] as? String ?? ""
        let likedRequestDataDict = dict["data"] as? [String:T] ?? [:]
        let userDetailDict = dict["userDetails"] as? [String:T] ?? [:]
        let otherUserDetailDict = dict["otherUserDetails"] as? [String:T] ?? [:]
        let requestDataStruct = LikedUserRequestData(dict: likedRequestDataDict)!
        let userDetailStruct = OtherUserDetails(dict: userDetailDict)!
        let otherUserDetailStruct = OtherUserDetails(dict: otherUserDetailDict)!

        self.status = status
        self.alertMessage = alertMessage
        self.likedUserRequestData = requestDataStruct
        self.userDetails = userDetailStruct
        self.otherUserDetails = otherUserDetailStruct
    }
}
struct LikedUserRequestData<T>{
    var id:String
    var userID:String
    var otherID:String
    var roomID:String
    var chatStatus:String
    var created:String
    var name:String

    init?(dict:[String:T]) {
    let id  = dict["id"] as? String ?? ""
    let userID = dict["userID"] as? String ?? ""
    let otherID = dict["otherID"] as? String ?? ""
    let roomID = dict["roomID"] as? String ?? ""
    let chatStatus = dict["chatStatus"] as? String ?? ""
    let created = dict["created"] as? String ?? ""
    let name = dict["name"] as? String ?? ""

        self.id = id
        self.userID = userID
        self.otherID = otherID
        self.roomID = roomID
        self.chatStatus = chatStatus
        self.created = created
        self.name = name

        
    }

}
struct OtherUserDetails<T>{
    
    var userID:String
    var name:String
    var email:String
    var password:String
    var verificationCode:String
    var verified:String
    var image:String
    var gender:String
    var genderCat:String
    var age:String
    var DOB:String
    var phoneNo:String
    var showMe:String
    var mode:String
    var startAge:String
    var endAge:String
    var occupation:String
    var closeAccount:String
    var appleToken:String
    var facebookToken:String
    var created:String
    var authDetails:AuthDetails<T>
    
    init?(dict:[String:T]) {
        
        let userID = dict["userID"] as? String ?? ""
        let name = dict["name"] as? String ?? ""
        let email = dict["email"] as? String ?? ""
        let password = dict["password"] as? String ?? ""
        let verificationCode = dict["verificationCode"] as? String ?? ""
        let verified = dict["verified"] as? String ?? ""
        let image = dict["image"] as? String ?? ""
        let gender = dict["gender"] as? String ?? ""
        let genderCat = dict["genderCat"] as? String ?? ""
        let age = dict["age"] as? String ?? ""
        let DOB = dict["DOB"] as? String ?? ""
        let phoneNo = dict["phoneNo"] as? String ?? ""
        let showMe = dict["showMe"] as? String ?? ""
        let mode = dict["mode"] as? String ?? ""
        let startAge = dict["startAge"] as? String ?? ""
        let endAge = dict["endAge"] as? String ?? ""
        let occupation = dict["occupation"] as? String ?? ""
        let closeAccount = dict["closeAccount"] as? String ?? ""
        let appleToken = dict["appleToken"] as? String ?? ""
        let facebookToken = dict["facebookToken"] as? String ?? ""
        let created = dict["created"] as? String ?? ""
        let authDetailsDict = dict["authDetails"] as? [String:T] ?? [:]
        let authDetailsStruct = AuthDetails(dict: authDetailsDict)!

  
        self.userID = userID
        self.name = name
        self.email = email
        self.password = password
        self.verificationCode = verificationCode
        self.verified = verified
        self.image = image
        self.gender = gender
        self.genderCat = genderCat
        self.age = age
        self.DOB = DOB
        self.phoneNo = phoneNo
        self.showMe = showMe
        self.mode = mode
        self.startAge = startAge
        self.endAge = endAge
        self.occupation = occupation
        self.closeAccount = closeAccount
        self.appleToken = appleToken
        self.facebookToken = facebookToken
        self.created = created
        self.authDetails = authDetailsStruct
    }

}

struct AuthDetails<T>{
    var id:String
    var userID:String
    var authToken:String
    var log:String
    var lat:String
    var deviceToken:String
    var deviceType:String
    var created:String

    init?(dict:[String:T]) {
    let id = dict["id"] as? String ?? ""
    let userID = dict["userID"] as? String ?? ""
    let authToken = dict["authToken"] as? String ?? ""
    let log = dict["log"] as? String ?? ""
    let lat = dict["lat"] as? String ?? ""
    let deviceToken = dict["deviceToken"] as? String ?? ""
    let deviceType = dict["deviceType"] as? String ?? ""
    let created = dict["created"] as? String ?? ""
        
        self.id = id
        self.userID = userID
        self.authToken = authToken
        self.log = log
        self.lat = lat
        self.deviceToken = deviceToken
        self.deviceType = deviceType
        self.created = created

        
    }
}
//{
//    "status": "1",
//    "message": "You request has been send",
//    "data": {
//        "id": "2",
//        "userID": "9",
//        "otherID": "2",
//        "roomID": "yp2o&LvRr1SgDDe$RariC4&pXUD0bdYjp#YjHhM@cR*tnGmCJq",
//        "chatStatus": "1",
//        "created": "1607599031"
//    },
//    "otherUserDetails": {
//        "userID": "2",
//        "name": "abhi",
//        "email": "bunny@gmail.com",
//        "password": "fd02cfb68cb22308bd2533189012327c",
//        "verificationCode": "79F3@N",
//        "verified": "1",
//        "image": "",
//        "gender": "1",
//        "genderCat": "2",
//        "age": "20",
//        "DOB": "01-05-2000",
//        "phoneNo": "",
//        "showMe": "2",
//        "mode": "0",
//        "startAge": "18",
//        "endAge": "25",
//        "occupation": "business",
//        "closeAccount": "0",
//        "appleToken": "",
//        "facebookToken": "",
//        "created": "1605862187",
//        "authDetails": {
//            "id": "3",
//            "userID": "2",
//            "authToken": "7jaT2aH98QnNhN&%EWug*%Y2g7inyO1SiPJy326HK?uulF#Sp7",
//            "log": "-122.0312186",
//            "lat": "37.33233141",
//            "deviceToken": "",
//            "deviceType": "0",
//            "created": "1605873252"
//        }
//    }
//}
