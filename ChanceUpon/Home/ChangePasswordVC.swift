//
//  ChangePasswordVC.swift
//  Chance Upon
//
//  Created by Dharmani Apps mini on 2/23/21.
//  Copyright © 2021 Apple. All rights reserved.
//

import UIKit
import SVProgressHUD

class ChangePasswordVC: UIViewController {

    @IBOutlet weak var oldPasswordTF: UITextField!
    
    @IBOutlet weak var newPasswordTF: UITextField!
    
    @IBOutlet weak var confirmPasswordTF: UITextField!
    let rest = RestManager()

    
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
            navigationController?.popViewController(animated: true)
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
    @IBAction func submitButtonAction(_ sender: Any) {
        if oldPasswordTF.text?.trimmingCharacters(in: .whitespaces) == ""{
            Alert.present(
                title: AppAlertTitle.appName.rawValue,
                message: "Please enter old password",
                actions: .ok(handler: {
                }),
                from: self
            )
        }else if newPasswordTF.text?.trimmingCharacters(in: .whitespaces) == ""{
            Alert.present(
                title: AppAlertTitle.appName.rawValue,
                message:"Please enter new password",
                actions: .ok(handler: {
                }),
                from: self
            )
        }else if confirmPasswordTF.text?.trimmingCharacters(in: .whitespaces) == ""{
            Alert.present(
                title: AppAlertTitle.appName.rawValue,
                message:"Please enter confirm password",
                actions: .ok(handler: {
                }),
                from: self
            )
        }
        else if oldPasswordTF.text?.trimmingCharacters(in: .whitespaces) == newPasswordTF.text?.trimmingCharacters(in: .whitespaces){
            Alert.present(
                title: AppAlertTitle.appName.rawValue,
                message:"New & old password should be different",
                actions: .ok(handler: {
                }),
                from: self
            )
        }
        else{
            changePasswordApi()
        }
    }
    open func changePasswordApi(){
        guard let url = URL(string: kBASEURL + WSMethods.changePassword) else { return }
    
        let userId  = getSAppDefault(key: "UserId") as? String ?? ""
      
        rest.requestHttpHeaders.add(value: "application/json", forKey: "Content-Type")
        rest.httpBodyParameters.add(value:userId, forKey: "userID")
        rest.httpBodyParameters.add(value:newPasswordTF.text ?? "", forKey: "newPassword")
        rest.httpBodyParameters.add(value:oldPasswordTF.text ?? "", forKey: "oldPassword")
        rest.httpBodyParameters.add(value:confirmPasswordTF.text ?? "", forKey: "confirmPassword")

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
    @IBAction func backBtnAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    


}
