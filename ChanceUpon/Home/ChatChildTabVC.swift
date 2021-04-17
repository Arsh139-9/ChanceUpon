//
//  ChatChildTabVC.swift
//  ChanceUpon
//
//  Created by Dharmani Apps mini on 8/19/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import SVProgressHUD

class ChatChildTabVC: UIViewController {
    let restM = RestManager()
    let restC = RestManager()
    let restS = RestManager()

    var meetUpPageCount = Int()
    var currentChatPageCount = Int()
    var sendInterestsPageCount = Int()
    var meetUpRequestArr = [[String:AnyHashable]]()
    var currentChatArr = [[String:AnyHashable]]()
    var sendInterestsArr = [[String:AnyHashable]]()
    var meetUpUserDetailStruct = MeetUpUserDetailData<AnyHashable>(dict:[:])
    var appDel = AppDelegate()
    
    @IBOutlet weak var noMeetUpRequestLbl: UILabel!
    
    @IBOutlet weak var noCurrentChatLbl: UILabel!
    @IBOutlet weak var noSendInterestLbl: UILabel!

    @IBOutlet weak var userProfileImgView: UIImageView!
    
    @IBOutlet weak var meetUpRequestCV: UICollectionView!
    @IBOutlet weak var sendInterestCV: UICollectionView!
    @IBOutlet weak var currentChatListTBView: UITableView!
    
    
    @IBOutlet weak var currentChatListTBHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var meetUpRequestCVHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var sendInterestCVHeightConstraint: NSLayoutConstraint!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        noMeetUpRequestLbl.isHidden = true
        noCurrentChatLbl.isHidden = true
        noSendInterestLbl.isHidden = true
 
        
        let  collectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionViewFlowLayout.scrollDirection = .horizontal
        meetUpRequestCV.collectionViewLayout = collectionViewFlowLayout
        meetUpRequestCV.isPagingEnabled = false
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        seObserverForOrientationChanging()
  
        let userProfileImg = getSAppDefault(key: "UserProfileImage") as? String ?? ""
           var photoStr = userProfileImg
           photoStr = photoStr.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
               userProfileImgView.sd_setImage(with: URL(string: photoStr), placeholderImage:UIImage(named: "userProfilePlaceholderImg"))
//        self.currentChatListTBView.estimatedRowHeight = 130
//        self.currentChatListTBView.rowHeight = UITableView.automaticDimension
        DispatchQueue.global(qos: .utility).async {

            self.meetUpPageCount = 1
            self.currentChatPageCount = 1
            self.sendInterestsPageCount = 1
            self.meetUpRequestDataApi()
            self.currentChatDataApi()
            self.sendInterestsApi()
        }
//        meetUpUsersApi()
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        sendInterestCV.collectionViewLayout.invalidateLayout()
    }
    open func meetUpRequestDataApi(){
        guard let url = URL(string: kBASEURL + WSMethods.meetUpDetail) else { return }
        let userId  = getSAppDefault(key: "UserId") as? String ?? ""
        restM.requestHttpHeaders.add(value: "application/json", forKey: "Content-Type")
        restM.httpBodyParameters.add(value: getSAppDefault(key: "AuthToken") as? String ?? "", forKey: "authToken")
        restM.httpBodyParameters.add(value: userId, forKey: "userID")
        restM.httpBodyParameters.add(value: "1", forKey: "type")
        restM.httpBodyParameters.add(value: "\(meetUpPageCount)", forKey: "meetPageNo")
        SVProgressHUD.show()
        meetUpRequestArr.removeAll()
        restM.makeRequest(toURL: url, withHttpMethod: .post) { (results) in
            SVProgressHUD.dismiss()

            guard let response = results.response else { return }
            if response.httpStatusCode == 200 {
                guard let data = results.data else { return }
                
                let jsonResult = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:AnyHashable] ?? [:]
            
                let meetByUserResp = MeetUpUserDetailData.init(dict: jsonResult ?? [:])
                self.meetUpUserDetailStruct = meetByUserResp
                if meetByUserResp?.status == "1"{
                    
                    if Int(truncating: NSNumber(value: self.meetUpPageCount )) > 1 {
                        var meetUpRequestPageArray = getSAppDefault(key: "MeetUpRequestPageArray") as? [[String:AnyHashable]] ?? [[:]]

                        let meetUpReqPageDictArray = meetByUserResp?.meetUpRequestArr
                        for obj in meetUpReqPageDictArray ?? [] {
                            meetUpRequestPageArray.append(obj)
                            self.meetUpRequestArr = meetUpRequestPageArray
                        }
                        setAppDefaults(self.meetUpRequestArr, key: "MeetUpRequestPageArray")
                        
                    }
                    else{
                       
                        if  meetByUserResp!.meetUpRequestArr.count > 0{
                            let obj = meetByUserResp!.meetUpRequestArr[0]
                            if obj.count > 0{
                            self.meetUpRequestArr = meetByUserResp!.meetUpRequestArr
                            }
                        }
                        if self.meetUpRequestArr.count > 0{
                            setAppDefaults( self.meetUpRequestArr, key: "MeetUpRequestPageArray")
                            DispatchQueue.main.async {
                            self.noMeetUpRequestLbl.isHidden = true
                          //  self.meetUpRequestCVHeightConstraint.constant = 111.0
                            }

                        }else{
                            self.meetUpRequestArr.removeAll()
                            DispatchQueue.main.async {
                                self.noMeetUpRequestLbl.isHidden = false
                           // self.meetUpRequestCVHeightConstraint.constant = 63.0
                            }
                        }
                    }
                    DispatchQueue.main.async {
                    self.meetUpRequestCV.reloadData()
                    }
                }
              
                else{
                    self.meetUpRequestArr.removeAll()
                   
                    DispatchQueue.main.async {
                        self.noMeetUpRequestLbl.isHidden = false
                //    self.meetUpRequestCVHeightConstraint.constant = 63.0
                    self.meetUpRequestCV.reloadData()
                  
                    }
                    DispatchQueue.main.async {

                    Alert.present(
                        title: AppAlertTitle.appName.rawValue,
                        message: meetByUserResp?.alertMessage ?? "",
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
    
    open func currentChatDataApi(){
        
        guard let url = URL(string: kBASEURL + WSMethods.meetUpDetail) else { return }
        let userId  = getSAppDefault(key: "UserId") as? String ?? ""
       
        
        restC.requestHttpHeaders.add(value: "application/json", forKey: "Content-Type")
        restC.httpBodyParameters.add(value: getSAppDefault(key: "AuthToken") as? String ?? "", forKey: "authToken")

        restC.httpBodyParameters.add(value: userId, forKey: "userID")
        restC.httpBodyParameters.add(value: "2", forKey: "type")
        restC.httpBodyParameters.add(value: "\(currentChatPageCount)", forKey: "currentPageNo")
        SVProgressHUD.show()
        currentChatArr.removeAll()
        restC.makeRequest(toURL: url, withHttpMethod: .post) { (results) in
            SVProgressHUD.dismiss()

            guard let response = results.response else { return }
            if response.httpStatusCode == 200 {
                guard let data = results.data else { return }
                
                let jsonResult = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:AnyHashable] ?? [:]
            
                let meetByUserResp = MeetUpUserDetailData.init(dict: jsonResult ?? [:])
                self.meetUpUserDetailStruct = meetByUserResp
                if meetByUserResp?.status == "1"{
                
                   if Int(truncating: NSNumber(value: self.currentChatPageCount )) > 1 {
                    var currentChatPageArray = getSAppDefault(key: "CurrentChatPageArray") as? [[String:AnyHashable]] ?? [[:]]

                        let currentChatPageDictArray = meetByUserResp?.currentChatArr
                        for obj in currentChatPageDictArray ?? [] {
                            currentChatPageArray.append(obj)
                            self.currentChatArr = currentChatPageArray
                        }
                        setAppDefaults(self.currentChatArr, key: "CurrentChatPageArray")
                        
                    }
                    else{
                       
                        if meetByUserResp!.currentChatArr.count > 0{
                            let obj = meetByUserResp!.currentChatArr[0]
                            if obj.count > 0{
                            self.currentChatArr = meetByUserResp!.currentChatArr
                            }
                        }
                            if self.currentChatArr.count > 0{
                            setAppDefaults( self.currentChatArr, key: "CurrentChatPageArray")
                            DispatchQueue.main.async {
                            self.noCurrentChatLbl.isHidden = true
                                self.currentChatListTBHeightConstraint.constant = 190.0
                            }
                        }else{
                            self.currentChatArr.removeAll()
                            DispatchQueue.main.async {
                                self.noCurrentChatLbl.isHidden = false
                                self.currentChatListTBHeightConstraint.constant = 100.0
                            }
                        }
                    }
                    DispatchQueue.main.async {
                    self.currentChatListTBView.reloadData()
                        
                    }
                }else{
                    self.currentChatArr.removeAll()
                    DispatchQueue.main.async {
                        self.noCurrentChatLbl.isHidden = false
                    self.currentChatListTBHeightConstraint.constant = 100.0
                    self.currentChatListTBView.reloadData()
                    }
                    DispatchQueue.main.async {

                    Alert.present(
                        title: AppAlertTitle.appName.rawValue,
                        message: meetByUserResp?.alertMessage ?? "",
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
    open func sendInterestsApi(){
        guard let url = URL(string: kBASEURL + WSMethods.meetUpDetail) else { return }
        let userId  = getSAppDefault(key: "UserId") as? String ?? ""
       
        
        restS.requestHttpHeaders.add(value: "application/json", forKey: "Content-Type")
        restS.httpBodyParameters.add(value: userId, forKey: "userID")
        restS.httpBodyParameters.add(value: "3", forKey: "type")
        restS.httpBodyParameters.add(value: getSAppDefault(key: "AuthToken") as? String ?? "", forKey: "authToken")

        restS.httpBodyParameters.add(value: "\(sendInterestsPageCount)", forKey: "sendPageNo")
        SVProgressHUD.show()

        sendInterestsArr.removeAll()
        restS.makeRequest(toURL: url, withHttpMethod: .post) { (results) in
            SVProgressHUD.dismiss()

            guard let response = results.response else { return }
            if response.httpStatusCode == 200 {
                guard let data = results.data else { return }
                
                let jsonResult = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:AnyHashable] ?? [:]
            
                let meetByUserResp = MeetUpUserDetailData.init(dict: jsonResult ?? [:])
                self.meetUpUserDetailStruct = meetByUserResp
                if meetByUserResp?.status == "1"{
                   if Int(truncating: NSNumber(value: self.sendInterestsPageCount )) > 1 {
                    var sendInterestsPageArray = getSAppDefault(key: "SendInterestsPageArray") as? [[String:AnyHashable]] ?? [[:]]

                        let sendInterestsPageDictArray = meetByUserResp?.sendInterestsArr
                        for obj in sendInterestsPageDictArray ?? [] {
                            sendInterestsPageArray.append(obj)
                            self.sendInterestsArr = sendInterestsPageArray
                        }
                        setAppDefaults(self.sendInterestsArr, key: "SendInterestsPageArray")
                        
                    }
                    else{
                        
                        if meetByUserResp!.sendInterestsArr.count > 0{
                            let obj = meetByUserResp!.sendInterestsArr[0]
                            if obj.count > 0{
                            self.sendInterestsArr = meetByUserResp!.sendInterestsArr
                            }
                        }
                        if self.sendInterestsArr.count > 0{
                            setAppDefaults( self.sendInterestsArr, key: "SendInterestsPageArray")
                            DispatchQueue.main.async {
                            self.noSendInterestLbl.isHidden = true
                                self.sendInterestCVHeightConstraint.constant = 130.0
                            }
                        }else{
                            self.sendInterestsArr.removeAll()
                            DispatchQueue.main.async {
                                self.noSendInterestLbl.isHidden = false
                                self.sendInterestCVHeightConstraint.constant = 27.0
                            }
                        }
                    }
                    DispatchQueue.main.async {
                        self.sendInterestCV.reloadData()
                        
                    }
                }else{
                   
                    self.sendInterestsArr.removeAll()
                    DispatchQueue.main.async {
                        
                    self.noSendInterestLbl.isHidden = false
                    self.sendInterestCVHeightConstraint.constant = 27.0
                    self.sendInterestCV.reloadData()
                    }
                    DispatchQueue.main.async {

                    Alert.present(
                        title: AppAlertTitle.appName.rawValue,
                        message: meetByUserResp?.alertMessage ?? "",
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
//    open func meetUpUsersApi(){
//        guard let url = URL(string: WS_Staging + WSMethods.meetUpDetail) else { return }
//        let userId  = getSAppDefault(key: "UserId") as? String ?? ""
//       
//        
//        rest.requestHttpHeaders.add(value: "application/json", forKey: "Content-Type")
//        rest.httpBodyParameters.add(value: userId, forKey: "userID")
//        rest.httpBodyParameters.add(value: "0", forKey: "type")
//        rest.httpBodyParameters.add(value: "\(meetUpPageCount)", forKey: "meetPageNo")
//        rest.httpBodyParameters.add(value: "\(currentChatPageCount)", forKey: "currentPageNo")
//        rest.httpBodyParameters.add(value: "\(sendInterestsPageCount)", forKey: "sendPageNo")
//        SVProgressHUD.show()
//        meetUpRequestArr.removeAll()
//        currentChatArr.removeAll()
//        sendInterestsArr.removeAll()
//        rest.makeRequest(toURL: url, withHttpMethod: .post) { (results) in
//            SVProgressHUD.dismiss()
//
//            guard let response = results.response else { return }
//            if response.httpStatusCode == 200 {
//                guard let data = results.data else { return }
//                
//                let jsonResult = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:AnyHashable] ?? [:]
//            
//                let meetByUserResp = MeetUpUserDetailData.init(dict: jsonResult ?? [:])
//                self.meetUpUserDetailStruct = meetByUserResp
//                if meetByUserResp?.status == "1"{
//                    if Int(truncating: NSNumber(value: self.meetUpPageCount )) > 1 {
//
//                        var meetUpRequestPageArray = getSAppDefault(key: "MeetUpRequestPageArray") as? [[String:AnyHashable]] ?? [[:]]
//
//                        let meetUpReqPageDictArray = meetByUserResp?.meetUpRequestArr
//                        for obj in meetUpReqPageDictArray ?? [] {
//                            meetUpRequestPageArray.append(obj)
//                            self.meetUpRequestArr = meetUpRequestPageArray
//                        }
//                        setAppDefaults(self.meetUpRequestArr, key: "MeetUpRequestPageArray")
//                        
//                    }
//                  else if Int(truncating: NSNumber(value: self.currentChatPageCount )) > 1 {
//                    var currentChatPageArray = getSAppDefault(key: "CurrentChatPageArray") as? [[String:AnyHashable]] ?? [[:]]
//
//                        let currentChatPageDictArray = meetByUserResp?.currentChatArr
//                        for obj in currentChatPageDictArray ?? [] {
//                            currentChatPageArray.append(obj)
//                            self.currentChatArr = currentChatPageArray
//                        }
//                        setAppDefaults(self.currentChatArr, key: "CurrentChatPageArray")
//                        
//                    }
//                  else if Int(truncating: NSNumber(value: self.sendInterestsPageCount )) > 1 {
//                    var sendInterestsPageArray = getSAppDefault(key: "SendInterestsPageArray") as? [[String:AnyHashable]] ?? [[:]]
//
//                        let sendInterestsPageDictArray = meetByUserResp?.sendInterestsArr
//                        for obj in sendInterestsPageDictArray ?? [] {
//                            sendInterestsPageArray.append(obj)
//                            self.sendInterestsArr = sendInterestsPageArray
//                        }
//                        setAppDefaults(self.sendInterestsArr, key: "SendInterestsPageArray")
//                        
//                    }
//                    else{
//                        self.meetUpRequestArr = meetByUserResp!.meetUpRequestArr
//                        setAppDefaults( self.meetUpRequestArr, key: "MeetUpRequestPageArray")
//                        self.currentChatArr = meetByUserResp!.currentChatArr
//                        setAppDefaults( self.currentChatArr, key: "CurrentChatPageArray")
//                        self.sendInterestsArr = meetByUserResp!.sendInterestsArr
//                        setAppDefaults( self.sendInterestsArr, key: "SendInterestsPageArray")
//                    }
//                    DispatchQueue.main.async {
//                    self.meetUpRequestCV.reloadData()
//                    self.currentChatListTBView.reloadData()
//                    self.sendInterestCV.reloadData()
//                        
//                    }
//                }else{
//                    self.meetUpRequestArr.removeAll()
//                    self.currentChatArr.removeAll()
//                    self.sendInterestsArr.removeAll()
//                    DispatchQueue.main.async {
//                        self.noMeetUpRequestLbl.isHidden = false
//                        self.noCurrentChatLbl.isHidden = false
//                        self.noSendInterestLbl.isHidden = false
//                    self.meetUpRequestCVHeightConstraint.constant = 63.0
//                    self.currentChatListTBHeightConstraint.constant = 100.0
//                    self.sendInterestCVHeightConstraint.constant = 27.0
//                    self.meetUpRequestCV.reloadData()
//                    self.currentChatListTBView.reloadData()
//                    self.sendInterestCV.reloadData()
//                    }
//                    DispatchQueue.main.async {
//
//                    Alert.present(
//                        title: AppAlertTitle.appName.rawValue,
//                        message: meetByUserResp?.alertMessage ?? "",
//                        actions: .ok(handler: {
//                            
//                            
//                        }),
//                        from: self
//                    )
//                    }
//                }
//               
//            }else{
//                DispatchQueue.main.async {
//
//                Alert.present(
//                    title: AppAlertTitle.appName.rawValue,
//                    message: AppAlertTitle.connectionError.rawValue,
//                    actions: .ok(handler: {
//                    }),
//                    from: self
//                )
//                }
//            }
//        }
//    }
    
    
    func seObserverForOrientationChanging() {
        UIDevice.current.beginGeneratingDeviceOrientationNotifications()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(orientationChanged(_:)),
            name: UIDevice.orientationDidChangeNotification,
            object: UIDevice.current)
    }
    
    @objc func orientationChanged(_ note: Notification?) {
        if UI_USER_INTERFACE_IDIOM() == .pad {
            sendInterestCV.reloadData()
            //        [_vesselIPadCV invalidateIntrinsicContentSize];
        }
    }
    @IBAction func profileBtnAction(_ sender: UIButton) {
        Navigation.init().pushCallBack(ViewControllerIdentifier.ProfileVC,StoryboardName.Settings,ChatChildTabVC(),self.storyboard!, self.navigationController!)

    }
}

extension ChatChildTabVC:UICollectionViewDataSource,UICollectionViewDelegate{
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return 1
//    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == meetUpRequestCV{
            return meetUpRequestArr.count
        }else{
            return sendInterestsArr.count

        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == meetUpRequestCV{
            let cell = meetUpRequestCV.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? MeetUpRequestCell
            
            let imgDict =  meetUpRequestArr[indexPath.row]
            let image = imgDict["image"] as? String ?? ""
                var photoStr = image
                photoStr = photoStr.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
                    cell?.profileImgView.sd_setImage(with: URL(string: photoStr), placeholderImage:UIImage(named: "userProfilePlaceholderImg"))
                self.meetUpRequestCVHeightConstraint.constant = self.meetUpRequestCV.contentSize.height
            
           
            return cell!
        }else{
            
            let cell = sendInterestCV.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? SendInterestListCell
            
            self.sendInterestCVHeightConstraint.constant = self.sendInterestCV.contentSize.height
            if sendInterestsArr.count > 0{
            let objDict =  sendInterestsArr[indexPath.row]
            let image = objDict["image"] as? String ?? ""
                var photoStr = image
                photoStr = photoStr.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
                    cell?.nearByUserProfileImg?.sd_setImage(with: URL(string: photoStr), placeholderImage:UIImage(named: "nearByUserPlaceholderImg"))
                
            
            cell?.nearByUserDistanceLbl?.text = objDict["distance_in_miles"] as? String ?? ""
            cell?.nearByUserNameAgeLbl?.text = objDict["name"] as? String ?? "" + ", \(objDict["age"] as? String ?? "")"
            }
            
            return cell!
            
        }
        
        
        
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
//        if meetUpUserDetailStruct?.meetLastPage == "FALSE" {
//            meetUpPageCount = meetUpPageCount + 1
//            meetUpUsersApi()
//        }
//        if meetUpUserDetailStruct?.sendLastPage == "FALSE" {
//            sendInterestsPageCount = sendInterestsPageCount + 1
//            meetUpUsersApi()
//        }
//
        
        if collectionView == meetUpRequestCV{
            if indexPath.row == meetUpRequestArr.count - 1 {
                if meetUpUserDetailStruct?.meetLastPage == "FALSE" {
                    meetUpPageCount = meetUpPageCount + 1
                    meetUpRequestDataApi()
                }
            } else {
            }
        }else{
            if indexPath.row == sendInterestsArr.count - 1 {
                if meetUpUserDetailStruct?.sendLastPage == "FALSE" {
                    sendInterestsPageCount = sendInterestsPageCount + 1
                    sendInterestsApi()
                }
            } else {
            }
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        
        let CMDVC = self.storyboard?.instantiateViewController(withIdentifier: ViewControllerIdentifier.MeetNowChatVC) as? ChatDetailVC
        if collectionView == meetUpRequestCV{
            if meetUpRequestArr.count > 0{
             
                CMDVC?.onlineStatus = meetUpRequestArr[indexPath.row]["online"] as? String ?? ""
                CMDVC?.lastTimeOnline = meetUpRequestArr[indexPath.row]["lastTime"] as? String ?? ""
                CMDVC?.closeAccount = meetUpRequestArr[indexPath.row]["closeAccount"] as? String ?? ""

            CMDVC?.roomId = meetUpRequestArr[indexPath.row]["roomID"] as? String ?? ""
            CMDVC?.receiverName = meetUpRequestArr[indexPath.row]["name"] as? String ?? ""
            CMDVC?.dynamicMessage = meetUpRequestArr[indexPath.row]["message"] as? String ?? ""
            CMDVC?.cUserId = meetUpRequestArr[indexPath.row]["userID"] as? String ?? ""
            CMDVC?.otherName = meetUpRequestArr[indexPath.row]["otherName"] as? String ?? ""
//            CMDVC?.meetUpRequestStatus = currentChatArr[indexPath.row]["meetStatus"] as? String ?? ""
            CMDVC?.otherId = meetUpRequestArr[indexPath.row]["otherID"] as? String ?? ""
            CMDVC?.profileImg = meetUpRequestArr[indexPath.row]["image"] as? String ?? ""
            CMDVC?.distanceInMiles = meetUpRequestArr[indexPath.row]["distance_in_miles"] as? String ?? ""
            

            CMDVC?.isFromMeetUpRequest = true
                if let CMDVC = CMDVC {
                    navigationController?.pushViewController(CMDVC, animated: true)
                }
            }
          
        }else{
             
            if sendInterestsArr.count > 0{
            CMDVC?.isFromMeetUpRequest = false
            CMDVC?.isFromCurrentChat = false
            
            CMDVC?.onlineStatus = sendInterestsArr[indexPath.row]["online"] as? String ?? ""
            CMDVC?.lastTimeOnline = sendInterestsArr[indexPath.row]["lastTime"] as? String ?? ""
            CMDVC?.closeAccount = sendInterestsArr[indexPath.row]["closeAccount"] as? String ?? ""
            CMDVC?.nameSI =  sendInterestsArr[indexPath.row]["name"] as? String ?? ""
            CMDVC?.imageSI =  sendInterestsArr[indexPath.row]["image"] as? String ?? ""
            CMDVC?.otherId = sendInterestsArr[indexPath.row]["otherID"] as? String ?? ""

            CMDVC?.distanceSI =  sendInterestsArr[indexPath.row]["distance_in_miles"] as? String ?? ""
                if let CMDVC = CMDVC {
                    navigationController?.pushViewController(CMDVC, animated: true)
                }
            
            }
        }
        
        
        
    }
}
// MARK:- UICollectionViewDelegate method(s)

extension ChatChildTabVC:UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView == meetUpRequestCV{
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 16)
        }else{
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            
        }
        
    }
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            return 5
        }
      func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
          return 5
    
      }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == meetUpRequestCV{
            //             return CGSizeMake( self.newsCV.frame.size.height/1.19, self.newsCV.frame.size.height);
            return CGSize(width: UIScreen.main.bounds.size.width/7, height: UIScreen.main.bounds.size.height/9)
        }else{
            
            if UIScreen.main.bounds.size.width > UIScreen.main.bounds.size.height {
                return CGSize(width: UIScreen.main.bounds.size.width * 0.25/1.1, height: UIScreen.main.bounds.size.width * 0.25)
            } else {
                
                return CGSize(width: UIScreen.main.bounds.width/2.43, height: UIScreen.main.bounds.width/1.93)
            }
        }
    }
    
}

extension ChatChildTabVC:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentChatArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? CurrentChatListCell

        if currentChatArr.count > 0{
        let objDict =  currentChatArr[indexPath.row]
        let image = objDict["image"] as? String ?? ""
            var photoStr = image
            photoStr = photoStr.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
                cell?.userProfileImgView.sd_setImage(with: URL(string: photoStr), placeholderImage:UIImage(named: "userProfilePlaceholderImg"))
            
            if objDict["messageCount"] as? String ?? "" != "0"{
                cell?.chatNotificationBadgeLbl.isHidden = false

            cell?.chatNotificationBadgeLbl.text = objDict["messageCount"] as? String ?? ""
            }else{
                cell?.chatNotificationBadgeLbl.isHidden = true
            }
        cell?.userLastMessage.text = objDict["lastMessage"] as? String ?? ""
        let meetStatus = objDict["meetStatus"] as? String ?? ""
            if meetStatus == "0"{
                cell?.nameAgeLbl.halfTextColorChange(fullText:"\(objDict["name"] as? String ?? "") \(objDict["age"] as? String ?? "") Meetup now", changeText: "Meetup now")
            }else{
                cell?.nameAgeLbl.text = "\(objDict["name"] as? String ?? "") \(objDict["age"] as? String ?? "")"
            }
        }
        if currentChatArr.count > 1 && currentChatArr.count <= 3{
            tableView.layoutIfNeeded()
            tableView.estimatedRowHeight = UITableView.automaticDimension
        self.currentChatListTBHeightConstraint.constant = self.currentChatListTBView.contentSize.height;
        }else if currentChatArr.count == 1{
            self.currentChatListTBHeightConstraint.constant = 100
        }else{
            self.currentChatListTBHeightConstraint.constant = 293
        }
        
        return cell!
    }
    
    
}
extension ChatChildTabVC:UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
        //        return UIScreen.main.bounds.size.height * 0.179
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        if currentChatArr.count > 0{
            let CMDVC = self.storyboard?.instantiateViewController(withIdentifier: ViewControllerIdentifier.MeetNowChatVC) as? ChatDetailVC
            CMDVC?.onlineStatus = currentChatArr[indexPath.row]["online"] as? String ?? ""
            CMDVC?.closeAccount = currentChatArr[indexPath.row]["closeAccount"] as? String ?? ""

            CMDVC?.lastTimeOnline = currentChatArr[indexPath.row]["lastTime"] as? String ?? ""
            CMDVC?.roomId = currentChatArr[indexPath.row]["roomID"] as? String ?? ""
            CMDVC?.receiverName = currentChatArr[indexPath.row]["name"] as? String ?? ""
            CMDVC?.dynamicMessage = currentChatArr[indexPath.row]["message"] as? String ?? ""
            CMDVC?.cUserId = currentChatArr[indexPath.row]["userID"] as? String ?? ""
            CMDVC?.otherName = currentChatArr[indexPath.row]["otherName"] as? String ?? ""
//            CMDVC?.meetUpRequestStatus = currentChatArr[indexPath.row]["meetStatus"] as? String ?? ""
            CMDVC?.otherId = currentChatArr[indexPath.row]["otherID"] as? String ?? ""
            CMDVC?.profileImg = currentChatArr[indexPath.row]["image"] as? String ?? ""
            CMDVC?.distanceInMiles = currentChatArr[indexPath.row]["distance_in_miles"] as? String ?? ""
            CMDVC?.isFromCurrentChat = true
            CMDVC?.isFromNearByPeople = false
            if let CMDVC = CMDVC {
                navigationController?.pushViewController(CMDVC, animated: true)
            }
        }
     

        
       
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == currentChatArr.count - 1 {
            if meetUpUserDetailStruct?.currentLastPage == "FALSE" {
                currentChatPageCount = currentChatPageCount + 1
                currentChatDataApi()
            }
        } else {
        }
        
    }
}
extension UILabel {
    func halfTextColorChange (fullText : String , changeText : String ) {
        let strNumber: NSString = fullText as NSString
        let range = (strNumber).range(of: changeText)
        let attribute = NSMutableAttributedString.init(string: fullText)
        attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.systemPink , range: range)
        self.attributedText = attribute
    }
}
extension UIView {
    
    @IBInspectable var cornerRadiusV: CGFloat {
        get {
            return layer.cornerRadius
        }set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
}
