//
//  SignInVC.swift
//  ChanceUpon
//
//  Created by Dharmani Apps mini on 10/3/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import SVProgressHUD

class SignInVC: UIViewController {
    let rest = RestManager()
    
    @IBOutlet weak var emailTF: UITextField!
    
    @IBOutlet weak var passwordTF: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        addSwipe(view: view)
    }
    open func addSwipe(view:UIView) {
        let directions: [UISwipeGestureRecognizer.Direction] = [.right, .left, .up, .down]
        for direction in directions {
            let gesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
            gesture.direction = direction
            view.addGestureRecognizer(gesture)// self.view
        }
    }
    
    @objc func handleSwipe(sender: UISwipeGestureRecognizer) {
        let direction = sender.direction
        switch direction {
        case .right:
            print("Gesture direction: Right")
            navigationController?.popToRootViewController(animated: true)
        case .left:
            print("Gesture direction: Left")
        case .up:
            print("Gesture direction: Up")
        case .down:
            print("Gesture direction: Down")
        default:
            print("Unrecognized Gesture Direction")
        }
    }
    open func loginUserApi() {
        guard let url = URL(string: kBASEURL + WSMethods.signIn) else { return }
        let latitudeStr  = getSAppDefault(key: "Latitude") as? String ?? ""
        let longitudeStr  = getSAppDefault(key: "Longitude") as? String ?? ""

        var deviceToken  = getSAppDefault(key: "DeviceToken") as? String ?? ""
        if deviceToken == ""{
            deviceToken = "123"
        }
        rest.requestHttpHeaders.add(value: "application/json", forKey: "Content-Type")
        rest.httpBodyParameters.add(value: emailTF.text ?? "", forKey: "email")
        rest.httpBodyParameters.add(value: passwordTF.text ?? "", forKey: "password")
        
        rest.httpBodyParameters.add(value:latitudeStr, forKey: "latitude")
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
                    setAppDefaults(loginResp?.image, key: "UserProfileImage")

                    let occupation  = getSAppDefault(key: "Occupation") as? String ?? ""

                    DispatchQueue.main.async {
                        if occupation == ""{
                            Navigation.init().pushCallBack(ViewControllerIdentifier.AddUserProfilePicsVC,StoryboardName.SignUp,SignInVC(),self.storyboard!, self.navigationController!)

                            
                            
                           
                        }else{
                            let storyBoard = UIStoryboard(name: StoryboardName.Main, bundle: nil)
                            let DVC = storyBoard.instantiateViewController(withIdentifier: ViewControllerIdentifier.HomeTabVC) as? HomeTabVC
                                        DVC?.selectedIndex = 1
                                        if let DVC = DVC {
                                            self.navigationController?.pushViewController(DVC, animated: true)
                                        }
                        }

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
    
    
    @IBAction func forgotPasswordBtnAction(_ sender: Any) {
        Navigation.init().pushCallBack(ViewControllerIdentifier.ForgotPasswordVC,StoryboardName.SignUp,SignInVC(),self.storyboard!, self.navigationController!)
    }
    
    
    @IBAction func loginBtnAction(_ sender: Any) {
        
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
                message: AppSignInForgotSignUpAlertNessage.validEmail,
                actions: .ok(handler: {
                }),
                from: self
            )
        }else if passwordTF.text?.trimmingCharacters(in: .whitespaces) == ""{
            Alert.present(
                title: AppAlertTitle.appName.rawValue,
                message: AppSignInForgotSignUpAlertNessage.enterPassword,
                actions: .ok(handler: {
                }),
                from: self
            )
        }
        //      else if !validatePasswordLength(strPassword: passwordTF.text){
        //        Alert.present(
        //            title: AppAlertTitle.appName.rawValue,
        //            message: "Please enter valid password",
        //            actions: .ok(handler: {
        //            }),
        //            from: self
        //        )
        //      }
        else{
            loginUserApi()
        }
        
    }
    
    
    @IBAction func signUpBtnAction(_ sender: Any) {
        
        Navigation.init().pushCallBack(ViewControllerIdentifier.SignUpVC,StoryboardName.SignUp,SignInVC(),self.storyboard!, self.navigationController!)

        
        
    }
    
    
    
}
