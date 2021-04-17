//
//  AppleLoginUserDetailEntity.swift
//  ChanceUpon
//
//  Created by Dharmani Apps mini on 12/8/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation

struct AppleFBUserDetailData<T>{
  
  
    var status:String
    var alertMessage:String

    var appleFBUserDetailEntity:AppleFBUserDetail<T>
    
    init?(dict:[String:T]) {
        let status  = dict["status"] as? String ?? ""
        let alertMessage = dict["message"] as? String ?? ""

        let userDetailDict = dict["data"] as? [String:T] ?? [:]
//        let userDetailDict = userDetailArr[0]
       
        let userDetailTStruct = AppleFBUserDetail(dict: userDetailDict)!
       
        self.status = status
        self.alertMessage = alertMessage
        self.appleFBUserDetailEntity = userDetailTStruct

    }
}

struct AppleFBUserDetail<T>{
 
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
    var authToken:String

    
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
        let authToken = dict["authToken"] as? String ?? ""

  
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
        self.authToken = authToken

    }
}
