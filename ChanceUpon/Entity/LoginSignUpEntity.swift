//
//  LoginSignUpEntity.swift
//  ChanceUpon
//
//  Created by Dharmani Apps mini on 11/21/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation

struct LoginData<T>:Codable{
  
    var status:String
    var alertMessage:String
    var userID:String
    var name:String
    var email:String
    var password:String
    var verificationCode:String
    var verified:String
    var image:String
    var gender:String
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
        let status  = dict["status"] as? String ?? ""
        let alertMessage = dict["message"] as? String ?? ""
       
       let  dataDict = dict["data"] as? [String:T] ?? [:]
       
        
        let userID = dataDict["userID"] as? String ?? ""
        let name = dataDict["name"] as? String ?? ""
        let email = dataDict["email"] as? String ?? ""
        let password = dataDict["password"] as? String ?? ""
        let verificationCode = dataDict["verificationCode"] as? String ?? ""
        let verified = dataDict["verified"] as? String ?? ""
        let image = dataDict["image"] as? String ?? ""
        let gender = dataDict["gender"] as? String ?? ""
        let age = dataDict["age"] as? String ?? ""
        let DOB = dataDict["DOB"] as? String ?? ""
        let phoneNo = dataDict["phoneNo"] as? String ?? ""
        let showMe = dataDict["showMe"] as? String ?? ""
        let mode = dataDict["mode"] as? String ?? ""
        let startAge = dataDict["startAge"] as? String ?? ""
        let endAge = dataDict["endAge"] as? String ?? ""
        let occupation = dataDict["occupation"] as? String ?? ""
        let closeAccount = dataDict["closeAccount"] as? String ?? ""
        let appleToken = dataDict["appleToken"] as? String ?? ""
        let facebookToken = dataDict["facebookToken"] as? String ?? ""
        let created = dataDict["created"] as? String ?? ""
        let authToken = dataDict["authToken"] as? String ?? ""

        self.status = status
        self.alertMessage = alertMessage
        self.userID = userID
        self.name = name
        self.email = email
        self.password = password
        self.verificationCode = verificationCode
        self.verified = verified
        self.image = image
        self.gender = gender
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

extension LoginData {

    enum CodingKeys: CodingKey {
        case status
        case alertMessage
        case userID
        case name
        case email
        case password
        case verificationCode
        case verified
        case image
        case gender
        case age
        case DOB
        case phoneNo
        case showMe
        case mode
        case startAge
        case endAge
        case occupation
        case closeAccount
        case appleToken
        case facebookToken
        case created
        case authToken
        }
}
