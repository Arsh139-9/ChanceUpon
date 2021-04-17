//
//  SignUpVC.swift
//  ChanceUpon
//
//  Created by Dharmani Apps mini on 10/3/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import SVProgressHUD


class SignUpVC: UIViewController {
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var confirmPasswordTF: UITextField!
    let rest = RestManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    open func registerUserApi() {
        guard let url = URL(string: kBASEURL + WSMethods.signUp) else { return }
        var deviceToken  = getSAppDefault(key: "DeviceToken") as? String ?? ""
        if deviceToken == ""{
            deviceToken = "123"
        }
        let latitudeStr  = getSAppDefault(key: "Latitude") as? String ?? ""
        let longitudeStr  = getSAppDefault(key: "Longitude") as? String ?? ""
        rest.requestHttpHeaders.add(value: "application/json", forKey: "Content-Type")
        rest.httpBodyParameters.add(value: emailTF.text ?? "", forKey: "email")
        rest.httpBodyParameters.add(value: passwordTF.text ?? "", forKey: "password")
        rest.httpBodyParameters.add(value: confirmPasswordTF.text ?? "", forKey: "confirmPassword")
        rest.httpBodyParameters.add(value: latitudeStr, forKey: "latitude")
        rest.httpBodyParameters.add(value: longitudeStr, forKey: "longitude")
        rest.httpBodyParameters.add(value: deviceToken, forKey: "deviceToken")
        rest.httpBodyParameters.add(value: "1", forKey: "deviceType")
        
        SVProgressHUD.show()

        
        rest.makeRequest(toURL: url, withHttpMethod: .post) { (results) in
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
                let loginResp =   LoginData.init(dict: jsonResult ?? [:])
                if loginResp?.status == "1"{
                setAppDefaults(loginResp?.userID, key: "UserId")
                setAppDefaults(loginResp?.authToken, key: "AuthToken")
                setAppDefaults(loginResp?.occupation, key: "Occupation")

                DispatchQueue.main.async {
                    Alert.present(
                        title: AppAlertTitle.appName.rawValue,
                        message: loginResp?.alertMessage ?? "",
                        actions: .ok(handler: {
                            Navigation.init().pushCallBack(ViewControllerIdentifier.AddUserProfilePicsVC,StoryboardName.SignUp,SignUpVC(),self.storyboard!, self.navigationController!)
                        }),
                        from: self
                    )
                }
                }else{
                    DispatchQueue.main.async {
                        Alert.present(
                            title: AppAlertTitle.appName.rawValue,
                            message: loginResp?.alertMessage ?? "",
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
    
    
    
    @IBAction func signUpBtnAction(_ sender: Any) {
        if emailTF.text?.trimmingCharacters(in: .whitespaces) == ""{
            Alert.present(
                title: AppAlertTitle.appName.rawValue,
                message: AppSignInForgotSignUpAlertNessage.enterEmail,
                actions: .ok(handler: {
                }),
                from: self
            )
        }
        else  if !validateEmail(strEmail: emailTF.text ?? ""){
            Alert.present(
                title: AppAlertTitle.appName.rawValue,
                message:AppSignInForgotSignUpAlertNessage.validEmail,
                actions: .ok(handler: {
                }),
                from: self
            )
        }else if passwordTF.text?.trimmingCharacters(in: .whitespaces) == ""{
            Alert.present(
                title: AppAlertTitle.appName.rawValue,
                message:AppSignInForgotSignUpAlertNessage.enterPassword,
                actions: .ok(handler: {
                }),
                from: self
            )
        }
        else if confirmPasswordTF.text?.trimmingCharacters(in: .whitespaces) == ""{
            Alert.present(
                title: AppAlertTitle.appName.rawValue,
                message: AppSignInForgotSignUpAlertNessage.enterConfirmPassword,
                actions: .ok(handler: {
                }),
                from: self
            )
        }
        else if comparePasswordValidation(strPassword: passwordTF.text ?? "", strConfirmPassword: confirmPasswordTF.text ?? "") == false{
            Alert.present(
                title: AppAlertTitle.appName.rawValue,
                message: AppSignInForgotSignUpAlertNessage.passwordNotMatched,
                actions: .ok(handler: {
                }),
                from: self
            )
        }else{
            registerUserApi()
        }
    }
    
    @IBAction func signInBtnAction(_ sender: Any) {
        Navigation.init().pushCallBack(ViewControllerIdentifier.SignInVC,StoryboardName.Main,SignUpVC(),self.storyboard!, self.navigationController!)


    }
    
}
