//
//  UserProfileDetailEntity.swift
//  ChanceUpon
//
//  Created by Dharmani Apps mini on 12/1/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation

struct UserProfileDetailData<T>{
  
  
    var status:String
    var alertMessage:String
    var userDetailEntity:UserProfileDetail<T>
    
    init?(dict:[String:T]) {
        let status  = dict["status"] as? String ?? ""
        let alertMessage = dict["message"] as? String ?? ""

        let userDetailArr = dict["userDetails"] as? [[String:T]] ?? [[:]]
        let userDetailDict = userDetailArr[0]
       
        let userDetailTStruct = UserProfileDetail(dict: userDetailDict)!
       
        self.status = status
        self.userDetailEntity = userDetailTStruct
        self.alertMessage = alertMessage

    }
}

struct UserProfileDetail<T>{
 
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
    var online:String
    var lastTime:String
    var mode:String
    var startAge:String
    var endAge:String
    var occupation:String
    var pushNotification:String
    var closeAccount:String
    var appleToken:String
    var facebookToken:String
    var created:String
    var userImagesArr:[UserImageEntity<T>]
    var userInterestsArr:[InterestEntity<T>]

    
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
        let online = dict["online"] as? String ?? ""
        let lastTime = dict["lastTime"] as? String ?? ""

        let mode = dict["mode"] as? String ?? ""
        let startAge = dict["startAge"] as? String ?? ""
        let endAge = dict["endAge"] as? String ?? ""
        let occupation = dict["occupation"] as? String ?? ""
        let pushNotification = dict["pushNotification"] as? String ?? ""
        let closeAccount = dict["closeAccount"] as? String ?? ""
        let appleToken = dict["appleToken"] as? String ?? ""
        let facebookToken = dict["facebookToken"] as? String ?? ""
        let created = dict["created"] as? String ?? ""
        let userImageArr = dict["userImages"] as? [[String:T]] ?? [[:]]
        let interestArr = dict["interests"] as? [[String:T]] ?? [[:]]
      
        var userImgStructArr = [UserImageEntity<T>]()

        for obj in userImageArr{
            let userImageStruct = UserImageEntity(dict:obj)!
            userImgStructArr.append(userImageStruct)
        }
        var userInterestStructArr = [InterestEntity<T>]()

        for obj in interestArr{
            let userInterestStruct = InterestEntity(dict:obj)!
            userInterestStructArr.append(userInterestStruct)
        }
  
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
        self.online = online
        self.lastTime = lastTime

        self.mode = mode
        self.startAge = startAge
        self.endAge = endAge
        self.occupation = occupation
        self.pushNotification = pushNotification

        self.closeAccount = closeAccount
        self.appleToken = appleToken
        self.facebookToken = facebookToken
        self.created = created
        self.userImagesArr = userImgStructArr
        self.userInterestsArr = userInterestStructArr
    }
}
struct UserImageEntity<T>{
    var gallaryID:String
    var userID:String
    var image:String
    var created:String
    init?(dict:[String:T]) {
   
        let gallaryID = dict["gallaryID"] as? String ?? ""
        let userID = dict["userID"] as? String ?? ""
        let image = dict["userProfileImage"] as? String ?? ""
        let created = dict["created"] as? String ?? ""

        self.gallaryID = gallaryID
        self.userID = userID
        self.image = image
        self.created = created
    }
    
}
struct InterestEntity<T>{
    var id:String
    var userID:String
    var interests:String
    var created:String
    init?(dict:[String:T]) {
   
        let id = dict["id"] as? String ?? ""
        let userID = dict["userID"] as? String ?? ""
        let interests = dict["interests"] as? String ?? ""
        let created = dict["created"] as? String ?? ""
      

  
        self.id = id
        self.userID = userID
        self.interests = interests
        self.created = created
    }
    
}
