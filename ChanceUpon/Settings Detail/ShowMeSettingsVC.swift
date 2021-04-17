//
//  ShowMeSettingsVC.swift
//  ChanceUpon
//
//  Created by Dharmani Apps mini on 9/17/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import SVProgressHUD

class ShowMeSettingsVC: UIViewController {
     let rest = RestManager()
     var showMeStatus = String()
    
    @IBOutlet weak var menLbl: UILabel!
    
    @IBOutlet weak var menUnderLineLbl: UILabel!
    @IBOutlet weak var womenLbl: UILabel!
    
    @IBOutlet weak var womenUnderLineLbl: UILabel!
    
    @IBOutlet weak var otherLbl: UILabel!
    
    @IBOutlet weak var otherUnderLineLbl: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        addSwipe(view: view)
        if showMeStatus == "0"{
            menLbl.textColor = UIColor(red:215.0/255.0 , green:215.0/255.0 , blue:215.0/255.0 , alpha:1 )
            menUnderLineLbl.backgroundColor = UIColor(red:218.0/255.0 , green:218.0/255.0 , blue:218.0/255.0 , alpha:1 )
            womenLbl.textColor = UIColor(red:215.0/255.0 , green:215.0/255.0 , blue:215.0/255.0 , alpha:1 )
            womenUnderLineLbl.backgroundColor = UIColor(red:218.0/255.0 , green:218.0/255.0 , blue:218.0/255.0 , alpha:1 )
            otherLbl.textColor = UIColor(red:230.0/255.0 , green:43.0/255.0 , blue:78.0/255.0 , alpha:1 )
            otherUnderLineLbl.backgroundColor = UIColor(red:230.0/255.0 , green:43.0/255.0 , blue:78.0/255.0 , alpha:1 )
            
            
            
          
        }else if showMeStatus == "1"{
            
            menLbl.textColor = UIColor(red:230.0/255.0 , green:43.0/255.0 , blue:78.0/255.0 , alpha:1 )
            menUnderLineLbl.backgroundColor = UIColor(red:230.0/255.0 , green:43.0/255.0 , blue:78.0/255.0 , alpha:1 )
            womenLbl.textColor = UIColor(red:215.0/255.0 , green:215.0/255.0 , blue:215.0/255.0 , alpha:1 )
            womenUnderLineLbl.backgroundColor = UIColor(red:218.0/255.0 , green:218.0/255.0 , blue:218.0/255.0 , alpha:1 )
            otherLbl.textColor = UIColor(red:215.0/255.0 , green:215.0/255.0 , blue:215.0/255.0 , alpha:1 )
            otherUnderLineLbl.backgroundColor = UIColor(red:218.0/255.0 , green:218.0/255.0 , blue:218.0/255.0 , alpha:1 )
  
        }else{
            menLbl.textColor = UIColor(red:215.0/255.0 , green:215.0/255.0 , blue:215.0/255.0 , alpha:1 )
            menUnderLineLbl.backgroundColor = UIColor(red:218.0/255.0 , green:218.0/255.0 , blue:218.0/255.0 , alpha:1 )
            womenLbl.textColor = UIColor(red:230.0/255.0 , green:43.0/255.0 , blue:78.0/255.0 , alpha:1 )
            womenUnderLineLbl.backgroundColor = UIColor(red:230.0/255.0 , green:43.0/255.0 , blue:78.0/255.0 , alpha:1 )
            otherLbl.textColor = UIColor(red:215.0/255.0 , green:215.0/255.0 , blue:215.0/255.0 , alpha:1 )
            otherUnderLineLbl.backgroundColor = UIColor(red:218.0/255.0 , green:218.0/255.0 , blue:218.0/255.0 , alpha:1 )
        }
        
        
    }
    
    
    @IBAction func saveChangesBtnAction(_ sender: Any) {
        saveChangesApi(type:"1" , settingMode: showMeStatus,settingModeParamName: "showMe")
    }
    
    
    @IBAction func backBtnAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)

    }
    
    open func saveChangesApi(type:String,settingMode:String,settingModeParamName:String){
        guard let url = URL(string: kBASEURL + WSMethods.updateUserDetailsFromSettings) else { return }
        let userId  = getSAppDefault(key: "UserId") as? String ?? ""
        rest.requestHttpHeaders.add(value: "application/json", forKey: "Content-Type")
        rest.httpBodyParameters.add(value: userId, forKey: "userID")
        rest.httpBodyParameters.add(value: type, forKey: "type")
        rest.httpBodyParameters.add(value: settingMode, forKey: settingModeParamName)

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

   @IBAction func selectBtnAction(_ sender: UIButton) {
         if sender.tag == 0{
             menLbl.textColor = UIColor(red:230.0/255.0 , green:43.0/255.0 , blue:78.0/255.0 , alpha:1 )
             menUnderLineLbl.backgroundColor = UIColor(red:230.0/255.0 , green:43.0/255.0 , blue:78.0/255.0 , alpha:1 )
             womenLbl.textColor = UIColor(red:215.0/255.0 , green:215.0/255.0 , blue:215.0/255.0 , alpha:1 )
             womenUnderLineLbl.backgroundColor = UIColor(red:218.0/255.0 , green:218.0/255.0 , blue:218.0/255.0 , alpha:1 )
             otherLbl.textColor = UIColor(red:215.0/255.0 , green:215.0/255.0 , blue:215.0/255.0 , alpha:1 )
             otherUnderLineLbl.backgroundColor = UIColor(red:218.0/255.0 , green:218.0/255.0 , blue:218.0/255.0 , alpha:1 )
             showMeStatus = "1"
         }
         else if sender.tag == 1{
             menLbl.textColor = UIColor(red:215.0/255.0 , green:215.0/255.0 , blue:215.0/255.0 , alpha:1 )
             menUnderLineLbl.backgroundColor = UIColor(red:218.0/255.0 , green:218.0/255.0 , blue:218.0/255.0 , alpha:1 )
             womenLbl.textColor = UIColor(red:230.0/255.0 , green:43.0/255.0 , blue:78.0/255.0 , alpha:1 )
             womenUnderLineLbl.backgroundColor = UIColor(red:230.0/255.0 , green:43.0/255.0 , blue:78.0/255.0 , alpha:1 )
             otherLbl.textColor = UIColor(red:215.0/255.0 , green:215.0/255.0 , blue:215.0/255.0 , alpha:1 )
             otherUnderLineLbl.backgroundColor = UIColor(red:218.0/255.0 , green:218.0/255.0 , blue:218.0/255.0 , alpha:1 )
            showMeStatus = "2"


         }else if sender.tag == 2{
             menLbl.textColor = UIColor(red:215.0/255.0 , green:215.0/255.0 , blue:215.0/255.0 , alpha:1 )
             menUnderLineLbl.backgroundColor = UIColor(red:218.0/255.0 , green:218.0/255.0 , blue:218.0/255.0 , alpha:1 )
             womenLbl.textColor = UIColor(red:215.0/255.0 , green:215.0/255.0 , blue:215.0/255.0 , alpha:1 )
             womenUnderLineLbl.backgroundColor = UIColor(red:218.0/255.0 , green:218.0/255.0 , blue:218.0/255.0 , alpha:1 )
             otherLbl.textColor = UIColor(red:230.0/255.0 , green:43.0/255.0 , blue:78.0/255.0 , alpha:1 )
             otherUnderLineLbl.backgroundColor = UIColor(red:230.0/255.0 , green:43.0/255.0 , blue:78.0/255.0 , alpha:1 )
            showMeStatus = "0"

         }
         
         
     }

}
