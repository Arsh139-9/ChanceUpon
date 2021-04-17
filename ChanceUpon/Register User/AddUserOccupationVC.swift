//
//  AddUserOccupationVC.swift
//  ChanceUpon
//
//  Created by Dharmani Apps mini on 8/20/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD

class AddUserOccupationVC: UIViewController {
    @IBOutlet weak var myOccupationTF: UITextField!
    let rest = RestManager()
    var appDel = AppDelegate()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        
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
    open func signUpStepApi() {
           
           let urlStr = kBASEURL + WSMethods.signUpStep
           let userId  = getSAppDefault(key: "UserId") as? String ?? ""
           let authToken  = getSAppDefault(key: "AuthToken") as? String ?? ""
           let dateOfBirth  = getSAppDefault(key: "DOB") as? String ?? ""
           let userName  = getSAppDefault(key: "name") as? String ?? ""
           let genderStr  = getSAppDefault(key: "Gender") as? String ?? ""
           let genderCategoryStr  = getSAppDefault(key: "GenderCategory") as? String ?? ""
           let showMe  = getSAppDefault(key: "ShowMe") as? String ?? ""
           let interestArr  = getSAppDefault(key: "AddedInterest") as? [AnyObject] ?? []
           
           
           
           var param =  [AnyHashable : Any]()
        
        
        param["userID"] = userId
        param["authToken"] = authToken
        param["DOB"] = dateOfBirth
        param["name"] = userName
        param["gender"] = genderStr
        param["genderCategory"] = genderCategoryStr
        param["showMe"] = showMe
        param["interest"] = interestArr
        param["occupation"] = myOccupationTF.text ?? ""

//           param = ["userID":userId,
//                    "authToken":authToken,
//                    "DOB":dateOfBirth,
//                    "name":userName,
//                    "gender":genderStr,
//                    "genderCategory":genderCategoryStr,
//                    "showMe":showMe,
//                    "interest":interestArr,
//                    "occupation":myOccupationTF.text ?? ""]
           
           
           
           
        self.requestWith(endUrl: urlStr , parameters: param)
           
           //
           //        for i in 0..<dataImgArr.count{
           //            let imageData1 = dataImgArr[i]
           //            debugPrint("mime type is\(imageData1.mimeType)")
           //            let ranStr = String.random(length: 7)
           //
           //            rest.multiPartFormDataApi(param:paramDict!, fileName:"photo\(i + 1)" , imgData: imageData1, url: url, mimeType: imageData1.mimeType) { (resp: [String : AnyObject]) in
           //                DispatchQueue.main.async {
           //                    self.spinner.stopAnimating()
           //                }
           //                print(resp)
           //            }
           //
           //
           //
           //        }
           
       }
       func requestWith(endUrl: String, parameters: [AnyHashable : Any]){
           
           let url = endUrl /* your API url */
           
           let headers: HTTPHeaders = [
               /* "Authorization": "your_access_token",  in case you need authorization header */
               "Content-type": "multipart/form-data"
           ]
        SVProgressHUD.show()

    
           AF.upload(multipartFormData: { (multipartFormData) in
               
               for (key, value) in parameters {
                   multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as! String)
               }
               
               let dataImgArr  = getSAppDefault(key: "ImageArray") as? [Data] ?? []
               
               for i in 0..<dataImgArr.count{
                   let imageData1 = dataImgArr[i]
                   debugPrint("mime type is\(imageData1.mimeType)")
                   let ranStr = String.random(length: 7)
                   if imageData1.mimeType == "application/pdf" ||
                       imageData1.mimeType == "application/vnd" ||
                       imageData1.mimeType == "text/plain"{
                       multipartFormData.append(imageData1, withName: "image[\(i + 1)]" , fileName: ranStr + String(i + 1) + ".pdf", mimeType: imageData1.mimeType)
                   }else{
                       multipartFormData.append(imageData1, withName: "image[\(i + 1)]" , fileName: ranStr + String(i + 1) + ".jpg", mimeType: imageData1.mimeType)
                   }
                   
                   
                   
               }
               
               
           }, to: url, usingThreshold: UInt64.init(), method: .post, headers: headers, interceptor: nil, fileManager: .default)
           
           .uploadProgress(closure: { (progress) in
               print("Upload Progress: \(progress.fractionCompleted)")
               
           })
           .responseJSON { (response) in
            SVProgressHUD.dismiss()

               print("Succesfully uploaded\(response)")
               let respDict =  response.value as? [String : AnyObject] ?? [:]
               if respDict.count != 0{
                var signUpStepData =  SignUpStepData.init(dict: respDict)
                   if signUpStepData?.status == "1"{
                       removeAppDefaults(key:"ImageArray")
                       removeAppDefaults(key:"DOB")
                    removeAppDefaults(key:"name")
                    removeAppDefaults(key:"Gender")
                    removeAppDefaults(key:"GenderCategory")
                    removeAppDefaults(key:"ShowMe")
                    removeAppDefaults(key:"AddedInterest")
                    setAppDefaults(signUpStepData?.userDetailEntity.image, key: "UserProfileImage")
                       setAppDefaults(signUpStepData?.userDetailEntity.occupation, key: "Occupation")
                       
                    let storyBoard = UIStoryboard(name: StoryboardName.Main, bundle: nil)
                    let DVC = storyBoard.instantiateViewController(withIdentifier: ViewControllerIdentifier.HomeTabVC) as? HomeTabVC
                       DVC?.selectedIndex = 1
                       if let DVC = DVC {
                           self.navigationController?.pushViewController(DVC, animated: true)
                       }
                   }
                   else{
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
    @IBAction func nextBtnAction(_ sender: Any) {
        if myOccupationTF.text == ""{
            Alert.present(
                title: AppAlertTitle.appName.rawValue,
                message: AppSignInForgotSignUpAlertNessage.enterOccupation,
                actions: .ok(handler: {
                }), 
                from: self
            )
            
        }else{
            signUpStepApi()
            
        }
        
        
    }
    
}

