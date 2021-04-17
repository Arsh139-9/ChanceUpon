//
//  ForgotPasswordVC.swift
//  ChanceUpon
//
//  Created by Dharmani Apps mini on 12/3/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import SVProgressHUD

class ForgotPasswordVC: UIViewController {
     let rest = RestManager()
    
    @IBOutlet weak var emailTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
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

    @IBAction func submitBtnAction(_ sender: Any) {
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
        }else{
        forgotPasswordApi()
        }
    }
    
    open func forgotPasswordApi(){
        guard let url = URL(string: kBASEURL + WSMethods.forgotPassword) else { return }
    
        
        rest.requestHttpHeaders.add(value: "application/json", forKey: "Content-Type")
        rest.httpBodyParameters.add(value: emailTF.text ?? "", forKey: "email")
        
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
                let logOutResp =   LogOutData.init(dict: jsonResult ?? [:])
                if logOutResp?.status == "1"{
                    DispatchQueue.main.async {
                        Alert.present(
                            title: AppAlertTitle.appName.rawValue,
                            message: logOutResp?.alertMessage ?? "",
                            actions: .ok(handler: {
                                self.navigationController?.popViewController(animated: true)
                            }),
                            from: self
                        )
                    }
                }else{
                    DispatchQueue.main.async {

                    Alert.present(
                        title: AppAlertTitle.appName.rawValue,
                        message: logOutResp?.alertMessage ?? "",
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
