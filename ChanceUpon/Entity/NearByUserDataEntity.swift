//
//  NearByUserDataEntity.swift
//  ChanceUpon
//
//  Created by Dharmani Apps mini on 12/14/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation

struct NearByUserDetailData<T>{
  
  
    var status:String
    var alertMessage:String
    var lastPage:String
    var nearByUserDetailEntity:[NearByUserDetail<T>]
    var nearByUserArr:[[String:T]]
    
    init?(dict:[String:T]) {
        let status  = dict["status"] as? String ?? ""
        let alertMessage = dict["message"] as? String ?? ""
        let lastPage = dict["last_page"] as? String ?? ""
            
        let userDetailArr = dict["data"] as? [[String:T]] ?? [[:]]
        var nearByUserStructArr = [NearByUserDetail<T>]()
//        nearByUserStructArr.removeAll()
        for obj in userDetailArr{
            let nearByUserStruct = NearByUserDetail(dict:obj)!
            nearByUserStructArr.append(nearByUserStruct)
        }
   
        self.status = status
        self.alertMessage = alertMessage
        self.lastPage = lastPage
        self.nearByUserDetailEntity = nearByUserStructArr
        self.nearByUserArr = userDetailArr
    }
}

struct NearByUserDetail<T>{
 
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
    var distanceInKM:String
    var distanceInMiles:String
    var latitude:String
    var longitude:String

    var likeStatus:String

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
        let mode = dict["mode"] as? String ?? ""
        let startAge = dict["startAge"] as? String ?? ""
        let endAge = dict["endAge"] as? String ?? ""
        let occupation = dict["occupation"] as? String ?? ""
        let closeAccount = dict["closeAccount"] as? String ?? ""
        let appleToken = dict["appleToken"] as? String ?? ""
        let facebookToken = dict["facebookToken"] as? String ?? ""
        let created = dict["created"] as? String ?? ""
        let distanceInKM = dict["distance_in_kms"] as? String ?? ""
        let distanceInMiles = dict["distance_in_miles"] as? String ?? ""
        let latitude = dict["latitude"] as? String ?? ""
        let longitude = dict["longitude"] as? String ?? ""

        
        let likeStatus = dict["likeStatus"] as? String ?? ""

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
        self.mode = mode
        self.startAge = startAge
        self.endAge = endAge
        self.occupation = occupation
        self.closeAccount = closeAccount
        self.appleToken = appleToken
        self.facebookToken = facebookToken
        self.created = created
        self.distanceInKM = distanceInKM
        self.distanceInMiles = distanceInMiles
        self.latitude = latitude
        self.longitude = longitude
        self.likeStatus = likeStatus
        self.userImagesArr = userImgStructArr
        self.userInterestsArr = userInterestStructArr
    }
}

