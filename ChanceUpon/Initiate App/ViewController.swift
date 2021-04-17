//
//  ViewController.swift
//  ChanceUpon
//
//  Created by Dharmani Apps mini on 8/13/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import AuthenticationServices
import CoreLocation
import FBSDKLoginKit
import SVProgressHUD

class ViewController: UIViewController {
    
    let fLrest = RestManager()
    let aLrest = RestManager()
    let aLTrest = RestManager()

    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    var appleFBUserDetail = AppleFBUserDetailData<AnyHashable>(dict:[:])
    let loc = LocationService()
    var longitudeStr = String()
    var latitudeStr = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        loc.requestLocationAuthorization()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
            self.locationUpdateBackgroundApi()
                      
        
    }
    open func locationUpdateBackgroundApi(){
        
        loc.newLocation = {result in
            switch result {
            case .success(let location):
                debugPrint(location.coordinate.latitude, location.coordinate.longitude)
                self.longitudeStr = "\(location.coordinate.longitude)"
                self.latitudeStr = "\(location.coordinate.latitude)"
                setAppDefaults(self.longitudeStr, key: "Longitude")
                setAppDefaults(self.latitudeStr, key: "Latitude")

                
//                RepeatingTimer.runThisEvery(seconds: 1.5, startAfterSeconds: 1) { (timer) in
//                    self.updateLocationApi()
//               }
       
            case .failure(let error):
//                DispatchQueue.main.async {
//                    Alert.present(
//                        title: AppAlertTitle.appName.rawValue,
//                        message: "\(AppHomeTabAlertMessage.userLocationError)\(error)",
//                        actions: .ok(handler: {
//                        }),
//                        from: self
//                    )
                    debugPrint("\(AppHomeTabAlertMessage.userLocationError)\(error)")
//                }
            }
            
        }
    }
    @IBAction func alreadyHveAccountBtnAction(_ sender: UIButton) {
        Navigation.init().pushCallBack(ViewControllerIdentifier.SignInVC,StoryboardName.Main, ViewController(),self.storyboard!, self.navigationController!)
        
    }
    
    @IBAction func signUpWithEmailBtnAction(_ sender: Any) {
        Navigation.init().pushCallBack(ViewControllerIdentifier.SignInVC,StoryboardName.Main, ViewController(),self.storyboard!, self.navigationController!)
    }
    
    @IBAction func troubleSignInBtnAction(_ sender: Any) {
        Navigation.init().pushCallBack(ViewControllerIdentifier.ForgotPasswordVC,StoryboardName.SignUp, ViewController(),self.storyboard!, self.navigationController!)
        
    }
    
    
    @IBAction func fbLoginBtnAction(_ sender: Any) {
        let login = LoginManager()
        login.logIn(permissions: ["public_profile","email"], from: self) { (result, error) in
            if error != nil {
            }else {
                if let token = result?.token?.tokenString {
                    SVProgressHUD.show()
                    guard let accessToken = FBSDKLoginKit.AccessToken.current else { return }
                   
                    let graphRequest = FBSDKLoginKit.GraphRequest(graphPath: "me",
                                                                  parameters: ["fields": "email, name"],
                                                                  tokenString: accessToken.tokenString,
                                                                  version: nil,
                                                                  httpMethod: .get)
                    graphRequest.start { (connection, resultInfo, error) -> Void in
                        if error == nil {
                            if let dict = resultInfo as? NSDictionary {
                            self.faceBookLoginServiceCall(email: dict["email"] as? String ?? "", name: dict["name"] as? String ?? "", fbID: dict["id"] as? String ?? "")
                            }
                        }
                        else {
                            SVProgressHUD.dismiss()

                                           
                        }
                    }
                                   }
            }
        }
    }
    open func faceBookLoginServiceCall(email:String,name:String,fbID:String) {
        
        guard let url = URL(string: kBASEURL + WSMethods.fbLogin) else { return }
        
        var deviceToken  = getSAppDefault(key: "DeviceToken") as? String ?? ""
        if deviceToken == ""{
            deviceToken = "123"
        }
        
        fLrest.requestHttpHeaders.add(value: "application/json", forKey: "Content-Type")
        fLrest.httpBodyParameters.add(value: name, forKey: "name")
        fLrest.httpBodyParameters.add(value: email, forKey: "email")
        fLrest.httpBodyParameters.add(value: fbID, forKey: "facebookToken")
        fLrest.httpBodyParameters.add(value: latitudeStr, forKey: "latitude")
        fLrest.httpBodyParameters.add(value: longitudeStr, forKey: "longitude")
        fLrest.httpBodyParameters.add(value: deviceToken, forKey: "deviceToken")
        fLrest.httpBodyParameters.add(value: "1", forKey: "deviceType")
        
        SVProgressHUD.show()
        
        fLrest.makeRequest(toURL: url, withHttpMethod: .post) { (results) in
            SVProgressHUD.dismiss()
            
            
            guard let response = results.response else { return }
            if response.httpStatusCode == 200 {
                guard let data = results.data else { return }
                
                let jsonResult = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:AnyHashable] ?? [:]
                //                    let dataString = String(data: data, encoding: .utf8)
                //                    let jsondata = dataString?.data(using: .utf8)
                //                    let decoder = JSONDecoder()
                //                    let jobUser = try? decoder.decode(LoginData, from: jsondata!)
                //
                self.appleFBUserDetail = AppleFBUserDetailData.init(dict: jsonResult ?? [:])
               
                if self.appleFBUserDetail?.status == "1"{
                    DispatchQueue.main.async {
                        let occupation  = self.appleFBUserDetail?.appleFBUserDetailEntity.occupation
                        setAppDefaults(self.appleFBUserDetail?.appleFBUserDetailEntity.userID, key: "UserId")
                        setAppDefaults(self.appleFBUserDetail?.appleFBUserDetailEntity.image, key: "UserProfileImage")

                        setAppDefaults(self.appleFBUserDetail?.appleFBUserDetailEntity.authToken, key: "AuthToken")
                        setAppDefaults(occupation, key: "Occupation")
                        if occupation == ""{
                            self.appDelegate?.loginToAddPage()
                        }else{
                            self.appDelegate?.loginToHomePage()
                            
                        }
//                        Alert.present(
//                            title: AppAlertTitle.appName.rawValue,
//                            message: self.appleFBUserDetail?.alertMessage ?? "",
//                            actions: .ok(handler: {
//                                let occupation  = self.appleFBUserDetail?.appleFBUserDetailEntity.occupation
//                                setAppDefaults(self.appleFBUserDetail?.appleFBUserDetailEntity.userID, key: "UserId")
//
//                                setAppDefaults(self.appleFBUserDetail?.appleFBUserDetailEntity.authToken, key: "AuthToken")
//                                setAppDefaults(occupation, key: "Occupation")
//                                if occupation == ""{
//                                    self.appDelegate?.loginToAddPage()
//                                }else{
//                                    self.appDelegate?.loginToHomePage()
//
//                                }
//                            }),
//                            from: self
//                        )
                    }
                }else{
                    DispatchQueue.main.async {
                        
                        Alert.present(
                            title: AppAlertTitle.appName.rawValue,
                            message: self.appleFBUserDetail?.alertMessage ?? "",
                            actions: .ok(handler: {
                            }),
                            from: self
                        )
                    }
                }
                
                
            }else{
                DispatchQueue.main.async {
                    
                    Alert.present(
                        title: AppAlertTitle.appName.rawValue,
                        message: AppAlertTitle.connectionError.rawValue,
                        actions: .ok(handler: {
                        }),
                        from: self
                    )
                }
            }
        }
    }
        
        
    
    @IBAction func appleLoginBtnAction(_ sender: Any) {
        if #available(iOS 13.0, *) {
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            let request = appleIDProvider.createRequest()
            request.requestedScopes = [.fullName, .email]
            
            let authorizationController = ASAuthorizationController(authorizationRequests: [request])
            authorizationController.delegate = self
            authorizationController.performRequests()
        } else {
            DispatchQueue.main.async {
                Alert.present(
                    title: AppAlertTitle.appName.rawValue,
                    message: AppHomeTabAlertMessage.appleLoginSupport,
                    actions: .ok(handler: {
                    }),
                    from: self
                )
            }
            
            
        }
    }
    open func getAppleLoginDetailApi(appleID:String){
        
        guard let url = URL(string: kBASEURL + WSMethods.appleLoginByToken) else { return }
        
        var deviceToken  = getSAppDefault(key: "DeviceToken") as? String ?? ""
        if deviceToken == ""{
            deviceToken = "123"
        }
        
        aLTrest.requestHttpHeaders.add(value: "application/json", forKey: "Content-Type")
        aLTrest.httpBodyParameters.add(value: appleID, forKey: "appleToken")
        aLTrest.httpBodyParameters.add(value: latitudeStr, forKey: "latitude")
        aLTrest.httpBodyParameters.add(value: longitudeStr, forKey: "longitude")
        aLTrest.httpBodyParameters.add(value: deviceToken, forKey: "deviceToken")
        aLTrest.httpBodyParameters.add(value: "1", forKey: "deviceType")
        
        SVProgressHUD.show()

        aLTrest.makeRequest(toURL: url, withHttpMethod: .post) { (results) in
            SVProgressHUD.dismiss()

            
            guard let response = results.response else { return }
            if response.httpStatusCode == 200 {
                guard let data = results.data else { return }
                
                let jsonResult = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:AnyHashable] ?? [:]
                //                    let dataString = String(data: data, encoding: .utf8)
                //                    let jsondata = dataString?.data(using: .utf8)
                //                    let decoder = JSONDecoder()
                //                    let jobUser = try? decoder.decode(LoginData, from: jsondata!)
                //
                self.appleFBUserDetail = AppleFBUserDetailData.init(dict: jsonResult ?? [:])
                if self.appleFBUserDetail?.status == "1"{
                    
                    self.appleLoginServiceCall(email:self.appleFBUserDetail?.appleFBUserDetailEntity.email ?? "", name: self.appleFBUserDetail?.appleFBUserDetailEntity.name ?? "", appleID: self.appleFBUserDetail?.appleFBUserDetailEntity.appleToken ?? "")
                    
                }else{
                    DispatchQueue.main.async {
                        
                        Alert.present(
                            title: AppAlertTitle.appName.rawValue,
                            message: AppAlertTitle.connectionError.rawValue,
                            actions: .ok(handler: {
                            }),
                            from: self
                        )
                    }
                }
                
                
            }else{
                DispatchQueue.main.async {
                    
                    Alert.present(
                        title: AppAlertTitle.appName.rawValue,
                        message: AppAlertTitle.connectionError.rawValue,
                        actions: .ok(handler: {
                        }),
                        from: self
                    )
                }
            }
        }
    }
    open func appleLoginServiceCall(email:String,name:String,appleID:String) {
        
        guard let url = URL(string: kBASEURL + WSMethods.appleLogin) else { return }
        
        var deviceToken  = getSAppDefault(key: "DeviceToken") as? String ?? ""
        if deviceToken == ""{
            deviceToken = "123"
        }
        
        aLrest.requestHttpHeaders.add(value: "application/json", forKey: "Content-Type")
        aLrest.httpBodyParameters.add(value: name, forKey: "name")
        aLrest.httpBodyParameters.add(value: email, forKey: "email")
        aLrest.httpBodyParameters.add(value: appleID, forKey: "appleToken")
        aLrest.httpBodyParameters.add(value: latitudeStr, forKey: "latitude")
        aLrest.httpBodyParameters.add(value: longitudeStr, forKey: "longitude")
        aLrest.httpBodyParameters.add(value: deviceToken, forKey: "deviceToken")
        aLrest.httpBodyParameters.add(value: "1", forKey: "deviceType")
        
        SVProgressHUD.show()

        aLrest.makeRequest(toURL: url, withHttpMethod: .post) { (results) in
            SVProgressHUD.dismiss()

            
            guard let response = results.response else { return }
            if response.httpStatusCode == 200 {
                guard let data = results.data else { return }
                
                let jsonResult = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:AnyHashable] ?? [:]
                //                    let dataString = String(data: data, encoding: .utf8)
                //                    let jsondata = dataString?.data(using: .utf8)
                //                    let decoder = JSONDecoder()
                //                    let jobUser = try? decoder.decode(LoginData, from: jsondata!)
                //
                self.appleFBUserDetail = AppleFBUserDetailData.init(dict: jsonResult ?? [:])

                if self.appleFBUserDetail?.status == "1"{
                    DispatchQueue.main.async {
                        let occupation  = self.appleFBUserDetail?.appleFBUserDetailEntity.occupation
                        setAppDefaults(self.appleFBUserDetail?.appleFBUserDetailEntity.userID, key: "UserId")
                        setAppDefaults(self.appleFBUserDetail?.appleFBUserDetailEntity.image, key: "UserProfileImage")

                        setAppDefaults(self.appleFBUserDetail?.appleFBUserDetailEntity.authToken, key: "AuthToken")
                        setAppDefaults(occupation, key: "Occupation")

                        if occupation == ""{
                            self.appDelegate?.loginToAddPage()
                        }else{
                            self.appDelegate?.loginToHomePage()
                            
                        }
//                        Alert.present(
//                            title: AppAlertTitle.appName.rawValue,
//                            message: self.appleFBUserDetail?.alertMessage ?? "",
//                            actions: .ok(handler: {
//                                let occupation  = self.appleFBUserDetail?.appleFBUserDetailEntity.occupation
//                                setAppDefaults(self.appleFBUserDetail?.appleFBUserDetailEntity.userID, key: "UserId")
//
//                                setAppDefaults(self.appleFBUserDetail?.appleFBUserDetailEntity.authToken, key: "AuthToken")
//                                setAppDefaults(occupation, key: "Occupation")
//
//                                if occupation == ""{
//                                    self.appDelegate?.loginToAddPage()
//                                }else{
//                                    self.appDelegate?.loginToHomePage()
//
//                                }
//                            }),
//                            from: self
//                        )
                    }
                }else{
                    DispatchQueue.main.async {
                        
                        Alert.present(
                            title: AppAlertTitle.appName.rawValue,
                            message: self.appleFBUserDetail?.alertMessage ?? "",
                            actions: .ok(handler: {
                            }),
                            from: self
                        )
                    }
                }
                
                
            }else{
                DispatchQueue.main.async {
                    
                    Alert.present(
                        title: AppAlertTitle.appName.rawValue,
                        message: AppAlertTitle.connectionError.rawValue,
                        actions: .ok(handler: {
                        }),
                        from: self
                    )
                }
            }
        }
    }
    
    
    
    
    
}
extension ViewController : ASAuthorizationControllerDelegate {
    
    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as?  ASAuthorizationAppleIDCredential {
            let userIdentifier = appleIDCredential.user
            let fullName = appleIDCredential.fullName
            if let email = appleIDCredential.email {
                self.appleLoginServiceCall(email: email, name: fullName?.familyName ?? "", appleID: userIdentifier)
            }else {
                self.getAppleLoginDetailApi(appleID: userIdentifier)
            }
        }
    }
    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error.
        DispatchQueue.main.async {
            Alert.present(
                title: AppAlertTitle.appName.rawValue,
                message: error.localizedDescription,
                actions: .ok(handler: {
                }),
                from: self
            )
        }
    }
    
    
}
