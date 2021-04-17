//
//  SettingChildTabVC.swift
//  ChanceUpon
//
//  Created by Dharmani Apps mini on 8/19/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

import RangeSeekSlider
import SVProgressHUD

struct Category {
    let name : String
    var items : [String]
}


class SettingChildTabVC: UIViewController {
    var sections = [Category]()
    var appDel = AppDelegate()
    var ageLblStr = String()
    let upUrest = RestManager()
    let gUrest = RestManager()
    let cArest = RestManager()
    let lOrest = RestManager()

    
    var minVal = CGFloat()
    var maxVal = CGFloat()
    var modeStr = String()
    var userProfileDetail = UserProfileDetailData<AnyHashable>(dict:[:])
    
    @IBOutlet weak var settingsTBView: UITableView!
    
    @IBOutlet weak var userProfileImgView: UIImageView!
    
    @IBOutlet weak var settingTbHeightConstraint: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        
        //        settingsTBView.estimatedSectionHeaderHeight = 43
        
        settingsTBView.sectionHeaderHeight = 43
        
        
        sections = [Category(name:"  Account settings", items:["Change password...","Phone number...","Email address..."]),
                    Category(name:"  Discovery", items:["Location settings","Show me","Age range","Invisible mode"]),
                    Category(name:"  Notifications", items:["Push notifications"]),
                    Category(name:"  Community", items:["Guidelines","Safety tips"]),
                    Category(name:"  Legal", items: ["Privacy policy","Terms and conditions"]),
                    Category(name:"  ", items: ["Sign out"]),
                    Category(name:"  ", items: ["Close account"])]
        
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        let userProfileImg = getSAppDefault(key: "UserProfileImage") as? String ?? ""
        var photoStr = userProfileImg
        photoStr = photoStr.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
            userProfileImgView.sd_setImage(with: URL(string: photoStr), placeholderImage:UIImage(named: "userProfilePlaceholderImg"))
        getUserDetailApi()
        // Recalculates height
        //        let indexPosition = IndexPath(row:0 , section: 1)
        //        let indexPosition1 = IndexPath(row:1 , section: 1)
        //        settingsTBView.reloadRows(at: [indexPosition,indexPosition1], with: .none)
        
    }
    open func saveChangesApi(type:String,isFromAge:Bool){
        guard let url = URL(string: kBASEURL + WSMethods.updateUserDetailsFromSettings) else { return }
        let userId  = getSAppDefault(key: "UserId") as? String ?? ""
        upUrest.requestHttpHeaders.add(value: "application/json", forKey: "Content-Type")
        upUrest.httpBodyParameters.add(value: userId, forKey: "userID")
        upUrest.httpBodyParameters.add(value: type, forKey: "type")
        if isFromAge == true{
            upUrest.httpBodyParameters.add(value: "\(Int(minVal))", forKey: "startAge")
            upUrest.httpBodyParameters.add(value: "\(Int(maxVal))", forKey: "endAge")
        }else{
            upUrest.httpBodyParameters.add(value: modeStr, forKey: "mode")

        }
        
//        SVProgressHUD.show()

        upUrest.makeRequest(toURL: url, withHttpMethod: .post) { (results) in
//            SVProgressHUD.dismiss()

            
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
                    self.getUserDetailApi()

                   
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
    open func getUserDetailApi(){
        guard let url = URL(string: kBASEURL + WSMethods.getUserDetail) else { return }
        
        gUrest.requestHttpHeaders.add(value: "application/json", forKey: "Content-Type")
        gUrest.httpBodyParameters.add(value: getSAppDefault(key: "UserId") as? String ?? "", forKey: "userID")
        gUrest.httpBodyParameters.add(value: getSAppDefault(key: "AuthToken") as? String ?? "", forKey: "authToken")

        
        SVProgressHUD.show()

        gUrest.makeRequest(toURL: url, withHttpMethod: .post) { (results) in
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
                self.userProfileDetail =   UserProfileDetailData.init(dict: jsonResult ?? [:])
                if self.userProfileDetail?.status == "1"{
                    DispatchQueue.main.async {
                        self.settingsTBView.reloadData()
                    }
                }
              
                
                else{
                    DispatchQueue.main.async {
                        
                        Alert.present(
                            title: AppAlertTitle.appName.rawValue,
                            message: AppAlertTitle.connectionError.rawValue,
                            actions: .ok(handler: {
                                self.navigationController?.popViewController(animated: true)
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
                            self.navigationController?.popViewController(animated: true)
                        }),
                        from: self
                    )
                }
            }
        }
    }
    open func closeAccountApi(){
        guard let url = URL(string: kBASEURL + WSMethods.closeAccountS) else { return }
        let userId  = getSAppDefault(key: "UserId") as? String ?? ""
        
        
        cArest.requestHttpHeaders.add(value: "application/json", forKey: "Content-Type")
        cArest.httpBodyParameters.add(value: userId, forKey: "userID")
        let cAStatus = self.userProfileDetail?.userDetailEntity.closeAccount ?? ""
        if cAStatus == "0"{
            cArest.httpBodyParameters.add(value: "1", forKey: "type")
        }else{
            cArest.httpBodyParameters.add(value: "2", forKey: "type")
        }

//        cArest.httpBodyParameters.add(value: cAStatus, forKey: "closeAccount")
        
        SVProgressHUD.show()

        cArest.makeRequest(toURL: url, withHttpMethod: .post) { (results) in
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
                    self.getUserDetailApi()
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
    open func logOutApi(){
        guard let url = URL(string: kBASEURL + WSMethods.logOut) else { return }
        let userId  = getSAppDefault(key: "UserId") as? String ?? ""
        let authToken  = getSAppDefault(key: "AuthToken") as? String ?? ""
        
        
        lOrest.requestHttpHeaders.add(value: "application/json", forKey: "Content-Type")
        lOrest.httpBodyParameters.add(value: userId, forKey: "userID")
        lOrest.httpBodyParameters.add(value: authToken, forKey: "authToken")
        
        SVProgressHUD.show()

        lOrest.makeRequest(toURL: url, withHttpMethod: .post) { (results) in
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
                                removeAppDefaults(key:"AuthToken")
                                removeAppDefaults(key:"NotificationBadge")
                                removeAppDefaults(key:"Longitude")
                                removeAppDefaults(key:"Latitude")

                             

                                //                                removeAppDefaults(key:"Occupation")
                                
                                
                                self.appDel.logOut()
                                
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
    
    @objc func onClick(_ sender: UIButton?) {
        let firstBtnImage = sender?.image(for: .normal)
        let defaultImage = UIImage(named: "toggleOff")
        if firstBtnImage?.pngData() != defaultImage?.pngData(){
            DispatchQueue.main.async {
                let alert = UIAlertController(title:AppAlertTitle.appName.rawValue , message: "Do you want to enable your account?", preferredStyle: .alert) // 1
                let firstAction = UIAlertAction(title: "Yes", style: .default) { (alert: UIAlertAction!) -> Void in
                    self.modeStr = "1"
                    sender?.setImage(UIImage(named: "toggleOn"), for: .selected)
                    sender?.setImage(UIImage(named: "toggleOff"), for: .normal)
                    self.saveChangesApi(type:"2", isFromAge:false)

    //                            self.appDel.logOut()
                   } // 2
                       
                let secondAction = UIAlertAction(title: "No", style: .default) { (alert: UIAlertAction!) -> Void in
                    

                   } // 3
                       
                   alert.addAction(firstAction) // 4
                   alert.addAction(secondAction) // 5
                self.present(alert, animated: true, completion:nil) // 6
                
              
            }
           
        }else{
            DispatchQueue.main.async {
                let alert = UIAlertController(title:AppAlertTitle.appName.rawValue , message: "Do you want to disable your account?", preferredStyle: .alert) // 1
                let firstAction = UIAlertAction(title: "Yes", style: .default) { (alert: UIAlertAction!) -> Void in
                    self.modeStr = "0"
                    sender?.setImage(UIImage(named: "toggleOff"), for: .selected)
                    sender?.setImage(UIImage(named: "toggleOn"), for: .normal)
                    self.saveChangesApi(type:"2", isFromAge:false)

    //                            self.appDel.logOut()
                   } // 2
                       
                let secondAction = UIAlertAction(title: "No", style: .default) { (alert: UIAlertAction!) -> Void in
                    

                   } // 3
                       
                   alert.addAction(firstAction) // 4
                   alert.addAction(secondAction) // 5
                self.present(alert, animated: true, completion:nil) // 6
                
              
            }
            
            
            
           
        }

        

    }
    @IBAction func profileBtnAction(_ sender: UIButton) {
        Navigation.init().pushCallBack(ViewControllerIdentifier.ProfileVC,StoryboardName.Settings,SettingChildTabVC(),self.storyboard!, self.navigationController!)
        
        
    }
    
    
}
extension SettingChildTabVC:UITableViewDataSource,RangeSeekSliderDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.sections.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.sections[section].name
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let items = self.sections[section].items
        return items.count
    }
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        //For Header Background Color
        if #available(iOS 13.0, *) {
            view.tintColor = .systemBackground
        } else {
            // Fallback on earlier versions
        }
        // For Header Text Color
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = .darkGray
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? SettingChildCell
        
        
        let items = self.sections[indexPath.section].items
        let item = items[indexPath.row]
        
        cell?.initiateLbl.text = item
        cell?.invisibleSwitchBtn.isHidden = true
        cell?.rangeSliderView.isHidden = true
        cell?.settingStatusSelectedView.isHidden = true
        cell?.centerSOLbl.isHidden = true
        cell?.resultLbl.isHidden = true
        if indexPath.section == 1{
            if indexPath.row == 0{
                cell?.settingStatusSelectedView.isHidden = false
                let locationStatus = getSAppDefault(key:"LocationStatus") as? String ?? ""
                if locationStatus == ""{
                    switch LocationService().status{
                         case .notDetermined:
                            // Request when-in-use authorization initially
                            cell?.lSSMLbl.text = "Off"
                            break
                         case .restricted, .denied:
                            // Disable location features
                            cell?.lSSMLbl.text = "Off"
                            break
                         case .authorizedWhenInUse, .authorizedAlways:
                            // Enable location features
                            cell?.lSSMLbl.text = "On"
                            break
                    @unknown default:
                        fatalError()
                    }

                    
                    
                }else{
                    cell?.lSSMLbl.text = locationStatus
                }
                
                
            }
            if indexPath.row == 1{
                cell?.settingStatusSelectedView.isHidden = false
                let showMStatus = self.userProfileDetail?.userDetailEntity.showMe ?? ""
                if showMStatus == "0"{
                    cell?.lSSMLbl.text = "Both"
                    
                }else if showMStatus == "1"{
                    cell?.lSSMLbl.text = "Men"
                    
                }else{
                    cell?.lSSMLbl.text = "Women"
                    
                }
            }
            if indexPath.row == 2{
                cell?.rangeSliderView.isHidden = false
                cell?.sliderObj.delegate = self
                let sAge = CGFloat(((self.userProfileDetail?.userDetailEntity.startAge ?? "") as NSString).doubleValue)
                let eAge = CGFloat(((self.userProfileDetail?.userDetailEntity.endAge ?? "") as NSString).doubleValue)
                
                
                cell?.sliderObj.selectedMinValue = sAge
                
                cell?.sliderObj.selectedMaxValue = eAge
                cell?.sliderObj.setNeedsLayout()
                cell?.sliderObj.layoutIfNeeded()
                if Int(eAge) == 100{
                    ageLblStr = "\(Int(sAge)) - \(Int(eAge)) +"
                }else{
                    ageLblStr = "\(Int(sAge)) - \(Int(eAge))"
                }
                
                cell?.resultLbl.isHidden = false
                if ageLblStr != ""{
                    cell?.resultLbl.text = ageLblStr
                }
            }
            if indexPath.row == 3{
                cell?.invisibleSwitchBtn.isHidden = false
                let modeStatus = self.userProfileDetail?.userDetailEntity.mode ?? ""
                cell?.invisibleSwitchBtn.isSelected = true

                if modeStatus == "0"{
                    cell?.invisibleSwitchBtn.setImage(UIImage(named: "toggleOff"), for: .selected)
                    cell?.invisibleSwitchBtn.setImage(UIImage(named: "toggleOn"), for: .normal)
                   
                }else{
                    cell?.invisibleSwitchBtn.setImage(UIImage(named: "toggleOn"), for: .selected)
                    cell?.invisibleSwitchBtn.setImage(UIImage(named: "toggleOff"), for: .normal)
                }
                
                cell?.invisibleSwitchBtn?.addTarget(self, action: #selector(onClick(_:)), for: .touchUpInside)
                
            }
        }
        if indexPath.section == 5 {
            if indexPath.row == 0{
                cell?.centerSOLbl.isHidden = false
                cell?.initiateLbl.isHidden = true
            }
        }
        else if indexPath.section == 6 {
            if indexPath.row == 0{
                cell?.centerSOLbl.isHidden = false
                let cAStatus = self.userProfileDetail?.userDetailEntity.closeAccount ?? ""
                if cAStatus == "0"{
                    cell?.centerSOLbl.text = "Close account"
                }else{
                    cell?.centerSOLbl.text = "Reactivate account"
                }
                cell?.initiateLbl.isHidden = true
            }
        }
        tableView.layoutIfNeeded()
        tableView.estimatedRowHeight = UITableView.automaticDimension
        settingTbHeightConstraint.constant = settingsTBView.contentSize.height
        return cell!
    }
    func rangeSeekSlider(_ slider: RangeSeekSlider, didChange minValue: CGFloat, maxValue: CGFloat) {
        minVal = minValue
        maxVal = maxValue
        if Int(maxValue) == 100{
            ageLblStr = "\(Int(minValue)) - \(Int(maxValue)) +"
        }else{
            ageLblStr = "\(Int(minValue)) - \(Int(maxValue))"
        }
        let indexPath = IndexPath(row: 2, section: 1)
        if let cell = settingsTBView.cellForRow(at: indexPath) as? SettingChildCell {
            
            cell.resultLbl.text = ageLblStr
        }
        
        
        
        
        
    }
    
    func didStartTouches(in slider: RangeSeekSlider) {
        debugPrint("did start touches")
    }
    
    func didEndTouches(in slider: RangeSeekSlider) {
        debugPrint("did end touches")
        saveChangesApi(type: "3",isFromAge:true)
    }
    
}
extension SettingChildTabVC:UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 5{
            return UIScreen.main.bounds.size.height * 0.039
        }
        else if section == 6{
            return UIScreen.main.bounds.size.height * 0.039
            
        }
        else{
            //            return UIScreen.main.bounds.size.height * 0.063
            return UITableView.automaticDimension
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 && indexPath.row == 2{
            return UIScreen.main.bounds.size.height * 0.09
            
        }else{
            return UITableView.automaticDimension
        }
        //        return UIScreen.main.bounds.size.height * 0.179
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let items = self.sections[indexPath.section].items
        let item = items[indexPath.row]
        
        if indexPath.section == 3{
            if indexPath.row == 0{
                if let url = URL(string:SettingWebLinks.guideLinesLive) {
                    UIApplication.shared.open(url)
                }
            }
            else if indexPath.row == 1{
                if let url = URL(string:SettingWebLinks.safetyTipsLive) {
                    UIApplication.shared.open(url)
                }
            }
        }
        if indexPath.section == 4{
            if indexPath.row == 0{
                if let url = URL(string:SettingWebLinks.privacyPolicyLive) {
                    UIApplication.shared.open(url)
                }
            }
            else if indexPath.row == 1{
                if let url = URL(string:SettingWebLinks.termsAndConditionsLive) {
                    UIApplication.shared.open(url)
                }
            }
        }
        
        if indexPath.section == 5 {
            if indexPath.row == 0{
                logOutApi()
            }
        }
        if indexPath.section == 6 {
            if indexPath.row == 0{
                let cAStatus = self.userProfileDetail?.userDetailEntity.closeAccount ?? ""
                if cAStatus == "0"{
                DispatchQueue.main.async {
                    let alert = UIAlertController(title:AppAlertTitle.appName.rawValue , message:"Your account has been disabled", preferredStyle: .alert) // 1
                    let firstAction = UIAlertAction(title: "Yes", style: .default) { (alert: UIAlertAction!) -> Void in
//                            self.appDel.logOut()
                        self.closeAccountApi()

                       } // 2
                           
                    let secondAction = UIAlertAction(title: "No", style: .default) { (alert: UIAlertAction!) -> Void in
                       

                       } // 3
                           
                       alert.addAction(firstAction) // 4
                       alert.addAction(secondAction) // 5
                    self.present(alert, animated: true, completion:nil) // 6
                    
                  
                }
                }else{
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title:AppAlertTitle.appName.rawValue , message:"Your account has been enabled", preferredStyle: .alert) // 1
                        let firstAction = UIAlertAction(title: "Yes", style: .default) { (alert: UIAlertAction!) -> Void in
    //                            self.appDel.logOut()
                            self.closeAccountApi()

                           } // 2
                               
                        let secondAction = UIAlertAction(title: "No", style: .default) { (alert: UIAlertAction!) -> Void in
                           

                           } // 3
                               
                           alert.addAction(firstAction) // 4
                           alert.addAction(secondAction) // 5
                        self.present(alert, animated: true, completion:nil) // 6
                        
                      
                    }
                    }
            }
        }
        
        let storyBoard = UIStoryboard(name: "Settings", bundle: nil)
        if item == "Show me"{
            let CMDVC = storyBoard.instantiateViewController(withIdentifier: ViewControllerIdentifier.ShowMeSettingsVC) as? ShowMeSettingsVC
            
            CMDVC?.showMeStatus = self.userProfileDetail?.userDetailEntity.showMe ?? ""
            
            if let CMDVC = CMDVC {
                navigationController?.pushViewController(CMDVC, animated: true)
            }
        }
        else if item == "Change password..."{
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let CMDVC = storyBoard.instantiateViewController(withIdentifier: ViewControllerIdentifier.ChangePasswordVC) as? ChangePasswordVC
            if let CMDVC = CMDVC {
                navigationController?.pushViewController(CMDVC, animated: true)
            }
        }
        else if item == "Phone number..."{
            
            let CMDVC = storyBoard.instantiateViewController(withIdentifier: ViewControllerIdentifier.SelectSettingsVC) as? SelectSettingsVC
            CMDVC?.isFromPhoneSettings = true
            let phoneNo = self.userProfileDetail?.userDetailEntity.phoneNo ?? ""
            if phoneNo == ""{
                CMDVC?.dynamicTFStr = "Please enter Phone Number"
                
            }else{
                CMDVC?.dynamicTFStr = phoneNo
            }
            if let CMDVC = CMDVC {
                navigationController?.pushViewController(CMDVC, animated: true)
            }
        }
        
        else if item == "Email address..."{
            let CMDVC = storyBoard.instantiateViewController(withIdentifier: ViewControllerIdentifier.SelectSettingsVC) as? SelectSettingsVC
            CMDVC?.dynamicLblStr = "Email address"
            CMDVC?.dynamicBtnStr = "Edit email address"
            CMDVC?.isFromEmailSettings = true
            let email = self.userProfileDetail?.userDetailEntity.email ?? ""
            if email == ""{
                CMDVC?.dynamicTFStr = "Please enter email"
                
            }else{
                CMDVC?.dynamicTFStr = email
            }
            if let CMDVC = CMDVC {
                navigationController?.pushViewController(CMDVC, animated: true)
            }
        }else if item == "Location settings"{
            let CMDVC = storyBoard.instantiateViewController(withIdentifier: ViewControllerIdentifier.SelectSettingsVC) as? SelectSettingsVC
            
            
            CMDVC?.dynamicLblStr = "Location settings"
            CMDVC?.isFromLocationSettings = true
            
            if let CMDVC = CMDVC {
                navigationController?.pushViewController(CMDVC, animated: true)
            }
        }
        else if item == "Push notifications"{
            let CMDVC = storyBoard.instantiateViewController(withIdentifier: ViewControllerIdentifier.SelectSettingsVC) as? SelectSettingsVC
            CMDVC?.dynamicLblStr = "Push notifications"
            CMDVC?.pushStatus =  self.userProfileDetail?.userDetailEntity.pushNotification ?? ""
            CMDVC?.isFromPushSettings = true
            
            if let CMDVC = CMDVC {
                navigationController?.pushViewController(CMDVC, animated: true)
            }
        }
        
        
        
        
        
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //        if indexPath.row == responseArr.count - 1 {
        //            if (((resultDict["data"] as? [AnyHashable : Any])?["last_page"] as? String ?? "") == "FALSE") {
        //                pageCount = pageCount + 1
        //                getLetterApi()
        //            }
        //        } else {
        //        }
        
    }
}
