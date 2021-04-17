//
//  AppConstant.swift
//  ChanceUpon
//
//  Created by Dharmani Apps mini on 11/20/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation

import UIKit

let DeviceSize = UIScreen.main.bounds.size
let appDel = (UIApplication.shared.delegate as! AppDelegate)
@available(iOS 13.0, *)
let appScene = (UIApplication.shared.delegate as! SceneDelegate)

struct WSMethods {
    static let signIn = "logIn.php"
    static let signUp = "signUp.php"
    static let signUpStep = "SignUpStep.php"
    static let logOut = "logOut.php"
    static let closeAccountS = "closeAccount.php"
    static let updateLocation = "updateLocation.php"
    static let getUserDetail = "getProfileDetails.php"
    static let editProfile = "editProfile.php"
    static let forgotPassword = "forgetPassword.php"
    static let appleLogin = "appleLogin.php"
    static let appleLoginByToken = "appleLoginByToken.php"
    static let fbLogin = "facebookLogin.php"
    static let getAllNearByUsers = "getAllNearByUsers.php"
    static let disLikeUser = "disLikeUser.php"
    static let likeUser = "likeUser.php"
    static let meetUpDetail = "home.php"
    static let getAllChatMessages = "getAllChatMessages.php"
    static let updateMessageSeen = "updateMessageSeen.php"
    static let sendMessage = "sendMessage.php"
    static let updateUserDetailsFromSettings = "updateUserDetailsFromSettings.php"
    static let requestForMeetUp = "requestForMeetUp.php"
    static let approveRejectMeetup = "approveRejectMeetup.php"
    static let changePassword = "changePassword.php"
}


let WS_Live = "http://chanceupon.co.uk/webservices/"
let WS_Staging = "https://www.dharmani.com/ChanceUpon/webservices/"

let kBASEURL = WS_Live


struct SettingWebLinks {
    static let guideLinesLive = "https://chanceupon.co.uk/Guidelines.html"
    static let privacyPolicyLive = "https://chanceupon.co.uk/PrivacyPolicy.html"
    static let safetyTipsLive = "https://chanceupon.co.uk/SafetyTips.html"
    static let termsAndConditionsLive = "https://chanceupon.co.uk/TermsAndConditions.html"
    static let guideLines = "https://www.dharmani.com/ChanceUpon/Guidelines.html"
    static let privacyPolicy = "https://www.dharmani.com/ChanceUpon/PrivacyPolicy.html"
    static let safetyTips = "https://www.dharmani.com/ChanceUpon/SafetyTips.html"
    static let termsAndConditions = "https://www.dharmani.com/ChanceUpon/TermsAndConditions.html"

}


struct ViewControllerIdentifier {
    static let SignInVC = "SignInVC"
    static let SignUpVC = "SignUpVC"
    static let HomeTabVC = "HomeTabVC"
    static let AddUserProfilePicsVC = "AddUserProfilePicsVC"
    static let ForgotPasswordVC = "ForgotPasswordVC"
    static let ViewController = "ViewController"
    static let ProfileVC = "ProfileVC"
    static let MeetNowChatVC = "ChatDetailVC"
    static let NearByPeopleVC = "NearByPeopleVC"
    static let ShowMeSettingsVC = "ShowMeSettingsVC"
    static let SelectSettingsVC = "SelectSettingsVC"
    static let ChangePasswordVC = "ChangePasswordVC"
    static let InterestVC = "InterestVC"
    static let ProfileSettingsVC = "ProfileSettingsVC"
    static let AddUserBirthVC = "AddUserBirthVC"
    static let AddUserNameVC = "AddUserNameVC"
    static let AddUserGenderVC = "AddUserGenderVC"
    static let AddUserInterestVC = "AddUserInterestVC"
    static let AddUserSexVC = "AddUserSexVC"
    static let AddUserOccupationVC = "AddUserOccupationVC"
}
struct StoryboardName {
    static let Main = "Main"
    static let SignUp = "SignUp"
    static let Settings = "Settings"
}


struct PhoneNumberFormat {
    static let uk = "+NN NNN NNN NNNN"
}

struct InputFiledFormat {
    static let passport = "xxxxxxxxxxxxxxxxxxxxxxxxx"
    static let licence = "xxxxxxxxxxxxxxxxxxxxxxxxx"
    static let Insurance = "xx xx xx xx x"
}


struct PostCodeFormat {
    static let chars7 = "xxxx xxx"
    static let chars6 = "xxx xxx"
    static let chars5 = "xxx xx"
}

struct AppInputRestrictions {
    static let _charNumbers = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-/ "
    static let charNumbersOnly = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
    static let charOnly = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
    static let numbersOnly = "0123456789"
}

struct AppRegex {
    static let minOneCapitalChar = "([^A-Z]{1,})"
    static let minOneDigitChar = "([^0-9]{1,})"
    static let minOneSpecialChar = "([^\\W]{1,})"
}

struct AppNotifications {
    static let signInInputs = NSNotification.Name(rawValue: "nc_signIn")
    static let signUpInputs = NSNotification.Name(rawValue: "nc_signUp")
    static let otpInputs = NSNotification.Name(rawValue: "nc_otpInput")
    static let idAddressInputs = NSNotification.Name(rawValue: "nc_address")
    static let idPassportInputs = NSNotification.Name(rawValue: "nc_passport")
    static let setSecurityInputs = NSNotification.Name(rawValue: "nc_setQues")
    static let forgotpassswordSecurityInputs = NSNotification.Name(rawValue: "nc_fpSecurityQues")
    
    static let nonregisteredUser = NSNotification.Name(rawValue: "nc_helpNonRegisteredUser")
    static let registeredUserSignInInputs = NSNotification.Name(rawValue: "nc_helpRegisteredUserSignIn")
    
    static let setTradingPin = NSNotification.Name(rawValue: "nc_setPin")
    static let setConfirmPin = NSNotification.Name(rawValue: "nc_setConfirmPin")
    static let insertPasscode = NSNotification.Name(rawValue: "nc_insertPasscode")
    static let forgotPasswordInputs = NSNotification.Name(rawValue: "nc_forgotPasswordInputs")
    static let signUpPassword = NSNotification.Name(rawValue: "passwordChanged")
    static let newPassword = NSNotification.Name(rawValue: "newPasswordChanged")
}

let kZoomDelta : Float = 100000000.0
let kRadiusInMeters  = 2
let kRadiusInKm  = 1000
let kRadiusInMiles = 1609.34
let kRegionDefaultValue = 100
let kMapPinAnnotIdentifier = "pinAnnot"
