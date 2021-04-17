//
//  ChatDetailVC.swift
//  ChanceUpon
//
//  Created by Dharmani Apps mini on 12/14/20.
//  Copyright © 2020 Apple. All rights reserved.
//


import UIKit
import SocketIO
import IQKeyboardManagerSwift
import SDWebImage
import SVProgressHUD

class ChatDetailVC: UIViewController,UITextViewDelegate{
    var movetoroot = Bool()
    let gCrest = RestManager()
    let aMrest = RestManager()
    let aRrest = RestManager()
    let sMrest = RestManager()

    
    var roomId = ""
    var otherId = ""
    var distanceInMiles = ""
    var responseArray =  [[String:AnyHashable]]()
    var getAllMessageStruct = GetChatAllMessagesDetailData<AnyHashable>(dict:[:])
    
    @IBOutlet weak var distanceLbl: UILabel!
    
    var refreshControl =  UIRefreshControl()
    var otherName  = ""
    var receiverName = ""
    var profileImg = ""
    var dynamicMessage = ""
    var cUserId = ""
    var onlineStatus = ""
    var lastTimeOnline = ""
    var closeAccount = ""
    var appDelegate  = AppDelegate()
    var pageCount = 0
    var fromAppDelegate: String?
    let textViewMaxHeight: CGFloat = 120
    //@IBOutlet weak var messagePlaceholderLbl: UILabel!
    @IBOutlet weak var dynamicChatStatusLbl: UILabel!
    
    
    @IBOutlet weak var interestChatView: UIView!
    @IBOutlet weak var meetFriendNotifyLbl: UILabel!
    
    var nameSI = String()
    var imageSI =  String()
    var distanceSI = String()
    var availableStatus = String()
    
    @IBOutlet weak var waitingSILbl: UILabel!
    
    lazy var isFromMeetUpRequest = Bool()
    lazy var isFromCurrentChat = Bool()
    lazy var isFromNearByPeople = Bool()
//    var gameTimer: Timer?

    @IBOutlet weak var sendMessageBtn: UIButton!
    @IBOutlet weak var userNameLbl: UILabel!
    
    @IBOutlet weak var userProfileImgView: UIImageView!
    
    @IBOutlet weak var dynamicStateButton: UIButton!
    
    @IBOutlet weak var messageTV: UITextView!
    @IBOutlet weak var chatTableView: UITableView!
    @IBOutlet weak var bottomChatViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var messageTVHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var messageViewHeightConstraint: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }
    
    
    @IBAction func meetUpRequestDynamicBtnAction(_ sender: UIButton) {
        if dynamicMessage == "You wants to Meetup now!"{
            sender.isEnabled = true
            sendMeetUpRequestApi(sender: sender)
            
        }else if dynamicMessage == "\(receiverName) wants to meet you, arrange a safe place to meet"{
            sender.isEnabled = true
            let alert = UIAlertController(title:AppAlertTitle.appName.rawValue , message: "Meetup Request", preferredStyle: .alert) // 1
            let firstAction = UIAlertAction(title: "Approve", style: .default) { (alert: UIAlertAction!) -> Void in
                self.approveRejectMeetUpRequestApi(appoveRejectMeet:"2", sender: sender)
               } // 2
                   
            let secondAction = UIAlertAction(title: "Reject", style: .default) { (alert: UIAlertAction!) -> Void in
                self.approveRejectMeetUpRequestApi(appoveRejectMeet:"1", sender: sender)

               } // 3
                   
               alert.addAction(firstAction) // 4
               alert.addAction(secondAction) // 5
            present(alert, animated: true, completion:nil) // 6
        }else{
            
            sender.isEnabled = false

        }
       
    }
    
    open func approveRejectMeetUpRequestApi(appoveRejectMeet:String,sender:UIButton){
        guard let url = URL(string: kBASEURL + WSMethods.approveRejectMeetup) else { return }
        
        
//        let rest = RestManager()
        aRrest.requestHttpHeaders.add(value: "application/json", forKey: "Content-Type")
        
        aRrest.httpBodyParameters.add(value: cUserId, forKey: "userID")
        aRrest.httpBodyParameters.add(value: otherId, forKey: "otherID")
        aRrest.httpBodyParameters.add(value: roomId, forKey: "roomID")
        aRrest.httpBodyParameters.add(value: appoveRejectMeet, forKey: "appoveRejectMeet")

        
        
        SVProgressHUD.show()
        aRrest.makeRequest(toURL: url, withHttpMethod: .post) { (results) in
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
                let meetUpRequestResp =   MeetUpRequestData.init(dict: jsonResult ?? [:])
                if meetUpRequestResp?.status == "1"{
                    DispatchQueue.main.async {
                        Alert.present(
                            title: AppAlertTitle.appName.rawValue,
                            message: meetUpRequestResp?.alertMessage ?? "",
                            actions: .ok(handler: {
                                sender.isEnabled = false
                                if self.fromAppDelegate == "YES"{
                                    let storyBoard = UIStoryboard(name: StoryboardName.Main, bundle: nil)
                                    let DVC = storyBoard.instantiateViewController(withIdentifier: ViewControllerIdentifier.HomeTabVC) as? HomeTabVC
                                    DVC?.selectedIndex = 0
                                    if let DVC = DVC {
                                        self.navigationController?.pushViewController(DVC, animated: true)
                                    }
                                }else{
                                    self.navigationController?.popViewController(animated: true)

                                }
                                


                            }),
                            from: self
                        )
                    }
                }else{
                    DispatchQueue.main.async {
                        
                        Alert.present(
                            title: AppAlertTitle.appName.rawValue,
                            message: meetUpRequestResp?.alertMessage ?? "",
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
    open func sendMeetUpRequestApi(sender:UIButton){
        guard let url = URL(string: kBASEURL + WSMethods.requestForMeetUp) else { return }
        
        let userId  = getSAppDefault(key: "UserId") as? String ?? ""

        
        sMrest.requestHttpHeaders.add(value: "application/json", forKey: "Content-Type")

        if isFromNearByPeople == true{
            sMrest.httpBodyParameters.add(value: userId, forKey: "userID")
        }else{
            sMrest.httpBodyParameters.add(value: cUserId, forKey: "userID")
        }
        sMrest.httpBodyParameters.add(value: otherId, forKey: "otherID")

        
        
        SVProgressHUD.show()
        sMrest.makeRequest(toURL: url, withHttpMethod: .post) { (results) in
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
                let meetUpRequestResp =   MeetUpRequestData.init(dict: jsonResult ?? [:])
                if meetUpRequestResp?.status == "1"{
                    DispatchQueue.main.async {
                        Alert.present(
                            title: AppAlertTitle.appName.rawValue,
                            message: meetUpRequestResp?.alertMessage ?? "",
                            actions: .ok(handler: {
                                sender.isEnabled = false
                            
//                                self.dynamicChatStatusLbl.backgroundColor = UIColor(red:251.0/255.0 , green:251.0/255.0 , blue:251.0/255.0 , alpha:1 )
//                                self.dynamicChatStatusLbl.textColor = UIColor(red:219.0/255.0 , green:220.0/255.0 , blue:222.0/255.0 , alpha:1 )
                                self.navigationController?.popViewController(animated: true)

                            }),
                            from: self
                        )
                    }
                }else{
                    DispatchQueue.main.async {
                        
                        Alert.present(
                            title: AppAlertTitle.appName.rawValue,
                            message: meetUpRequestResp?.alertMessage ?? "",
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
    
    
    func textViewDidChange(_ textView: UITextView) {
        messageTV.isScrollEnabled = true
        // get the current height of your text from the content size
        var height = textView.contentSize.height
        
        // clamp your height to desired values
        if height > 90 {
            height = 90
        } else if height < 50 {
            height = 33
        }
        // update the constraint
        messageTVHeightConstraint.constant = height
        messageViewHeightConstraint.constant = height + 30
        self.view.layoutIfNeeded()
    }
    
    
    
    @IBAction func profileBtnAction(_ sender: UIButton) {
        let storyBoard = UIStoryboard(name: StoryboardName.Settings, bundle: nil)
        let DVC = storyBoard.instantiateViewController(withIdentifier: ViewControllerIdentifier.ProfileVC) as? ProfileVC
        DVC?.otherUserId = otherId
        if let DVC = DVC {
            self.navigationController?.pushViewController(DVC, animated: true)
        }
        
    }
    
    
    @IBAction func backBtnClicked(_ sender: UIButton) {
        // SocketManger.shared.disconnect()
        
        messageTV.resignFirstResponder()
        
        if fromAppDelegate == "YES"{
//            gameTimer?.invalidate()
            let storyBoard = UIStoryboard(name: StoryboardName.Main, bundle: nil)
            let DVC = storyBoard.instantiateViewController(withIdentifier: ViewControllerIdentifier.HomeTabVC) as? HomeTabVC
            DVC?.selectedIndex = 0
            if let DVC = DVC {
                self.navigationController?.pushViewController(DVC, animated: true)
            }
        }else{
//            gameTimer?.invalidate()

            if isFromNearByPeople == true{
                let storyBoard = UIStoryboard(name: StoryboardName.Main, bundle: nil)
                let DVC = storyBoard.instantiateViewController(withIdentifier: ViewControllerIdentifier.HomeTabVC) as? HomeTabVC
                DVC?.selectedIndex = 1
                if let DVC = DVC {
                    self.navigationController?.pushViewController(DVC, animated: true)
                }
            }else{
                self.navigationController?.popViewController(animated: true)
            }
            //            self.updateMessageSeen(chatUserId:self.roomId)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        //   SocketManger.shared.socket.disconnect()
        SocketManger.shared.socket.emit("leaveChat",self.roomId)
    }
    
    @objc  func dismissKeyboard() {
        view.endEditing(false)
    }
    func getMinutesDifferenceFromTwoDates(start: Date, end: Date) -> Int
       {

           let diff = Int(end.timeIntervalSince1970 - start.timeIntervalSince1970)

           let hours = diff / 3600
           let minutes = (diff - hours * 3600) / 60
           return minutes
       }
    @objc func runTimedCode(){
            self.updateMessageSeenApi()
        

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        pageCount = 1
        self.getChatApi()
        self.runTimedCode()
//            self.gameTimer = Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(self.runTimedCode), userInfo: nil, repeats: true)
        

                      
        messageTV.delegate = self
        messageTV.isScrollEnabled = false
        messageTV.textContainerInset = UIEdgeInsets(top: 7, left: 13, bottom: 11, right: 13)
       
        if closeAccount == "1"{
            availableStatus = "Not available"
        }else{
            if onlineStatus == "1"{
                let endTime = Date(timeIntervalSince1970: TimeInterval(lastTimeOnline)!)

                let timeDiff = getMinutesDifferenceFromTwoDates(start:Date(), end: endTime)
                if timeDiff > 10{
                    availableStatus = "Not available"
                }else{
                    availableStatus = "Available"
                }
            }else{
                availableStatus = "Not available"
            }
//            availableStatus = "Available"
        }
        
        if isFromCurrentChat == true{
            if dynamicMessage == "You wants to Meetup now!"{
                dynamicChatStatusLbl.text = dynamicMessage

            }else if dynamicMessage == "\(receiverName) wants to meet you, arrange a safe place to meet"{
                dynamicChatStatusLbl.text = dynamicMessage

            }
            else if dynamicMessage == "Meetup request sent"{
                dynamicChatStatusLbl.backgroundColor = UIColor(red:251.0/255.0 , green:251.0/255.0 , blue:251.0/255.0 , alpha:1 )
                dynamicChatStatusLbl.textColor = UIColor(red:219.0/255.0 , green:220.0/255.0 , blue:222.0/255.0 , alpha:1 )
                dynamicChatStatusLbl.text = "You wants to Meetup now!"
            }
            else{
                dynamicChatStatusLbl.text = dynamicMessage
                dynamicStateButton.isEnabled = false
            }
            
            distanceLbl.text = "\(distanceInMiles) | \(availableStatus)"
            meetFriendNotifyLbl.isHidden = true
            interestChatView.isHidden = true
         
          
            var photoStr = profileImg
            photoStr = photoStr.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
                userProfileImgView.sd_setImage(with: URL(string: photoStr), placeholderImage:UIImage(named: "userProfilePlaceholderImg"))
            
            
            self.navigationController?.navigationBar.barTintColor = UIColor.white
            print(receiverName, "jjj")
            userNameLbl.text = receiverName
            let refreshView = UIView(frame: CGRect(x: 0, y: 0, width: 55, height: 0))
            chatTableView.insertSubview(refreshView, at: 0)
            refreshControl.addTarget(self, action: #selector(reloadtV), for: .valueChanged)
            refreshView.addSubview(refreshControl)
         
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                debugPrint("connected")
                let socketConnectionStatus = SocketManger.shared.socket.status
                switch socketConnectionStatus {
                case .connected:
                    debugPrint("socket connected")
                    SocketManger.shared.socket.emit("ConncetedChat", self.roomId)
                    self.newMessageSocketOn()
                case .connecting:
                    debugPrint("socket connecting")
                case .disconnected:
                    debugPrint("socket disconnected")
                    debugPrint("socket not connected")
                    SocketManger.shared.socket.connect()
                    self.connectSocketOn()
                    self.newMessageSocketOn()
                case .notConnected:
                    debugPrint("socket not connected")
                    SocketManger.shared.socket.connect()
                    self.connectSocketOn()
                    self.newMessageSocketOn()
                }
            }
            let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
            view.addGestureRecognizer(tap)
        }
        
        else{
            meetFriendNotifyLbl.isHidden = false
            if isFromMeetUpRequest != true{
                userNameLbl.text = nameSI
                var photoStr = imageSI
                photoStr = photoStr.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
                    userProfileImgView.sd_setImage(with: URL(string: photoStr), placeholderImage:UIImage(named: "userProfilePlaceholderImg"))
                
                distanceLbl.text = "\(distanceSI) | \(availableStatus)"
                waitingSILbl.text = "Waiting for \(nameSI) to reply..."
                
                dynamicChatStatusLbl.backgroundColor = UIColor(red:251.0/255.0 , green:251.0/255.0 , blue:251.0/255.0 , alpha:1 )
                dynamicChatStatusLbl.textColor = UIColor(red:219.0/255.0 , green:220.0/255.0 , blue:222.0/255.0 , alpha:1 )
                dynamicChatStatusLbl.text = "You want to Meetup now"
                interestChatView.isHidden = false
            }else{
                dynamicChatStatusLbl.text = dynamicMessage
                if dynamicMessage == "You wants to Meetup now!"{
                    dynamicStateButton.isEnabled = true

                }else if dynamicMessage == "\(receiverName) wants to meet you, arrange a safe place to meet"{
                    dynamicStateButton.isEnabled = true

                }else{
                    dynamicStateButton.isEnabled = false
                }
                
                distanceLbl.text = "\(distanceInMiles) | \(availableStatus)"
                meetFriendNotifyLbl.isHidden = true
                interestChatView.isHidden = true
                var photoStr = profileImg
                photoStr = photoStr.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
                    userProfileImgView.sd_setImage(with: URL(string: photoStr), placeholderImage:UIImage(named: "userProfilePlaceholderImg"))
                
              
                self.navigationController?.navigationBar.barTintColor = UIColor.white
                print(receiverName, "jjj")
                userNameLbl.text = receiverName
                let refreshView = UIView(frame: CGRect(x: 0, y: 0, width: 55, height: 0))
                chatTableView.insertSubview(refreshView, at: 0)
                refreshControl.addTarget(self, action: #selector(reloadtV), for: .valueChanged)
                refreshView.addSubview(refreshControl)
               
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    debugPrint("connected")
                    let socketConnectionStatus = SocketManger.shared.socket.status
                    switch socketConnectionStatus {
                    case .connected:
                        debugPrint("socket connected")
                        SocketManger.shared.socket.emit("ConncetedChat", self.roomId)
                        self.newMessageSocketOn()
                    case .connecting:
                        debugPrint("socket connecting")
                    case .disconnected:
                        debugPrint("socket disconnected")
                        debugPrint("socket not connected")
                        SocketManger.shared.socket.connect()
                        self.connectSocketOn()
                        self.newMessageSocketOn()
                    case .notConnected:
                        debugPrint("socket not connected")
                        SocketManger.shared.socket.connect()
                        self.connectSocketOn()
                        self.newMessageSocketOn()
                    }
                }
                let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
                view.addGestureRecognizer(tap)
            }
        }
//        let userProfileImg = getSAppDefault(key: "UserProfileImage") as? String ?? ""
//
//        var photoStr = userProfileImg
//        photoStr = photoStr.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
//            userProfileImgView.sd_setImage(with: URL(string: photoStr), placeholderImage:UIImage(named: "userProfilePlaceholderImg"))
        IQKeyboardManager.shared.disabledDistanceHandlingClasses.append(ChatDetailVC.self)
        IQKeyboardManager.shared.disabledToolbarClasses = [ChatDetailVC.self]
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: UIResponder.keyboardWillShowNotification, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    open func updateMessageSeenApi(){
     
        let userId  = getSAppDefault(key: "UserId") as? String ?? ""
        let params:[String:String] = ["roomID": roomId,"userID": userId]
        
        AFWrapperClass.requestPOSTURL( kBASEURL + WSMethods.updateMessageSeen, params: params, success: { (jsonResult) in

         
            let logOutResp =   LogOutData.init(dict: jsonResult as? [String:AnyHashable] ?? [:])
                if logOutResp?.status == "1"{

                }else{
              
                }
                
                
        }) { (error) in
        }
    }
    
    
    @objc func handleKeyboardNotification(_ notification: Notification) {
        if let userInfo = notification.userInfo {
            let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            
            let isKeyboardShowing = notification.name == UIResponder.keyboardWillShowNotification
            if fromAppDelegate == "YES"{
                bottomChatViewConstraint?.constant = isKeyboardShowing ? keyboardFrame!.height : 0
            }else{
                bottomChatViewConstraint?.constant = isKeyboardShowing ? keyboardFrame!.height - 39 : 0

            }
            
            DispatchQueue.main.async(execute: {
                self.chatTableView.reloadData()
                if  self.pageCount == 1 {
                    if self.responseArray.count > 0 {
                        let ip = IndexPath(row: self.responseArray.count - 1, section: 0)
                        self.chatTableView.scrollToRow(at: ip, at: .bottom, animated: false)
                    }
                }
            })
            UIView.animate(withDuration: 0.1, animations: { () -> Void in
                self.view.layoutIfNeeded()
                self.scrollEnd()
            })
        }
    }
    
    func scrollEnd(){
        if responseArray.count != 0{
        
            let lastItemIndex = self.chatTableView.numberOfRows(inSection: 0) - 1
            let indexPath:IndexPath = IndexPath(item: lastItemIndex, section: 0)
            if lastItemIndex != -1{
            self.chatTableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
            }
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        sendMessageBtn.isUserInteractionEnabled = true
        
        if textView.text.count == 0 {
            messageTV.isScrollEnabled = false
            // messagePlaceholderLbl.isHidden = false
            messageTVHeightConstraint.constant = 33
            messageViewHeightConstraint.constant = 60
            
        }else  {
            //  messagePlaceholderLbl.isHidden = true
        }
        
        return true
    }
    
    func connectSocketOn(){
        SocketManger.shared.onConnect {
            SocketManger.shared.socket.emit("ConncetedChat", self.roomId)
        }
    }
    //    open func updateMessageSeen(chatUserId:String){
    //        let idValue = UserDefaults.standard.value(forKey: "Uid") as? String ?? ""
    //        let chatData = Constant.shared.baseUrl + Constant.shared.updateSeenMessage
    //
    //        let params:[String:Any] = [
    //            "userID":idValue,
    //            "roomID":chatUserId
    //        ]
    //        AFWrapperClass.requestPOSTURL(chatData, params: params, success: { (response) in
    //            print(response)
    //            let status = response["status"] as? String ?? ""
    //            print(status)
    //            let message = response["message"] as? String ?? ""
    //
    //            if status == "1"{
    //
    //            }else{
    //            }
    //        })
    //        { (error) in
    //            print(error)
    //        }
    //    }
    func newMessageSocketOn(){
        SocketManger.shared.handleNewMessage { (message) in
            print(message)
            self.responseArray.insert(message as? [String:AnyHashable] ?? [:], at: self.responseArray.count)
            setAppDefaults(self.responseArray, key: "FirstPageArray")
            DispatchQueue.main.async(execute: {
                self.chatTableView.reloadData()
                if self.responseArray.count > 0 {
                    let ip = IndexPath(row: self.responseArray.count - 1, section: 0)
                    self.chatTableView.scrollToRow(at: ip, at: .bottom, animated: false)
                }
            })
        }
    }
    func joinedMessageSocketOn(){
        SocketManger.shared.handleJoinedMessage { (message) in
        }
    }
    func typeSocketOn(){
        SocketManger.shared.handleUserTyping { (trueIndex) in
        }
    }
    
    @objc func reloadtV() {
        if responseArray.count != 0{
            if (self.getAllMessageStruct?.lastPage == "FALSE") {
                pageCount = pageCount + 1
                getChatApi()
            }
        }
        self.refreshControl.endRefreshing()
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    open func getChatApi(){
        guard let url = URL(string: kBASEURL + WSMethods.getAllChatMessages) else { return }
        
        let userId  = getSAppDefault(key: "UserId") as? String ?? ""
        
        
        gCrest.requestHttpHeaders.add(value: "application/json", forKey: "Content-Type")
        gCrest.httpBodyParameters.add(value: userId, forKey: "userID")
        gCrest.httpBodyParameters.add(value: roomId, forKey: "roomID")
        gCrest.httpBodyParameters.add(value: "\(pageCount)", forKey: "pageNo")
        
        
        SVProgressHUD.show()
        gCrest.makeRequest(toURL: url, withHttpMethod: .post) { (results) in
            SVProgressHUD.dismiss()

            
            guard let response = results.response else { return }
            if response.httpStatusCode == 200 {
                guard let data = results.data else { return }
                
                let jsonResult = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:AnyHashable] ?? [:]
                
                let getChatAllMessagesDetailResp = GetChatAllMessagesDetailData.init(dict: jsonResult ?? [:])
                self.getAllMessageStruct = getChatAllMessagesDetailResp
                if getChatAllMessagesDetailResp?.status == "1"{
                    self.responseArray.removeAll()
                    if Int(truncating: NSNumber(value: self.pageCount )) > 1 {
                        var firstPageArray = getSAppDefault(key: "FirstPageArray") as? [[String:AnyHashable]]
                        let pageDictArray = getChatAllMessagesDetailResp?.allMessagesArr  ?? [[:]]
                        
                        for obj in pageDictArray {
                            
                            firstPageArray?.insert(obj, at: 0)
                            
                            self.responseArray = firstPageArray!
                        }
                        setAppDefaults(self.responseArray, key: "FirstPageArray")
                    } else {
                        
                        let reversedArr = getChatAllMessagesDetailResp?.allMessagesArr  ?? [[:]]
                        
                        let reversedArray = ((reversedArr as NSArray?)?.reverseObjectEnumerator())?.allObjects
                        self.responseArray = reversedArray! as! [[String : AnyHashable]]
                        
                        setAppDefaults(self.responseArray, key: "FirstPageArray")
                        
                    }
                    
                }else{
                    DispatchQueue.main.async {
                        
//                        Alert.present(
//                            title: AppAlertTitle.appName.rawValue,
//                            message: getChatAllMessagesDetailResp?.alertMessage ?? "",
//                            actions: .ok(handler: {
//                            }),
//                            from: self
//                        )
                    }
                }
                DispatchQueue.main.async(execute: {
                    
                    self.chatTableView.reloadData()
                    if  self.pageCount == 1 {
                        if self.responseArray.count > 0 {
                            let ip = IndexPath(row: self.responseArray.count-1, section: 0)
                            self.chatTableView.scrollToRow(at: ip, at: .bottom, animated: false)
                        }
                    }
                })
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
    open func addMessageApi(){
        guard let url = URL(string: kBASEURL + WSMethods.sendMessage) else { return }
        
        let userId  = getSAppDefault(key: "UserId") as? String ?? ""
        
        
        
        aMrest.requestHttpHeaders.add(value: "application/json", forKey: "Content-Type")
        if isFromCurrentChat == true{
            aMrest.httpBodyParameters.add(value: "1", forKey: "type")
        }else{
            aMrest.httpBodyParameters.add(value: "2", forKey: "type")
        }
        aMrest.httpBodyParameters.add(value: userId, forKey: "userID")
        aMrest.httpBodyParameters.add(value: roomId, forKey: "roomID")
        aMrest.httpBodyParameters.add(value: otherId, forKey: "otherID")
        aMrest.httpBodyParameters.add(value: messageTV.text ?? "", forKey: "message")
        
        
        SVProgressHUD.show()
        aMrest.makeRequest(toURL: url, withHttpMethod: .post) { (results) in
            SVProgressHUD.dismiss()

            
            guard let response = results.response else { return }
            if response.httpStatusCode == 200 {
                guard let data = results.data else { return }
                
                let jsonResult = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:AnyHashable] ?? [:]
                
                let sendMessageDetailResp = SendMessageDetailData.init(dict: jsonResult ?? [:])
                if sendMessageDetailResp?.status == "1"{
                    //                    let appendData = result["data"] as? [String:Any] ?? [:]
                    let appendData = sendMessageDetailResp?.sendMessageDetailDict ?? [:]
                    SocketManger.shared.socket.emit("newMessage",self.roomId,appendData)
                    self.responseArray.insert(appendData  , at: self.responseArray.count)
                    
                    setAppDefaults(self.responseArray, key: "FirstPageArray")
                    DispatchQueue.main.async {
                    self.sendMessageBtn.isUserInteractionEnabled = false
                    self.messageTV.resignFirstResponder()
                    self.messageTV.text = ""
                    self.messageTVHeightConstraint.constant = 33
                    // self.messagePlaceholderLbl.isHidden = false
                    self.messageViewHeightConstraint.constant = 60

                    }
                    
                    
                }else{
                    DispatchQueue.main.async {
                        
                        Alert.present(
                            title: AppAlertTitle.appName.rawValue,
                            message: sendMessageDetailResp?.alertMessage ?? "",
                            actions: .ok(handler: {
                            }),
                            from: self
                        )
                    }
                }
                DispatchQueue.main.async(execute: {
                    self.chatTableView.reloadData()
                    if self.responseArray.count > 0 {
                        let ip = IndexPath(row: self.responseArray.count - 1, section: 0)
                        self.chatTableView.scrollToRow(at: ip, at: .bottom, animated: false)
                    }
                    
                })
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
    
    
    @IBAction func sendMsgBtnAction(_ sender: UIButton) {
        let trimmedString = messageTV.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        if trimmedString == ""{
        }else{
            messageTV.resignFirstResponder()
            addMessageApi()
            messageTV.text = ""
        }
    }
}
extension ChatDetailVC:UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return responseArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let respDict = responseArray[indexPath.row]
        let userId  = getSAppDefault(key: "UserId") as? String ?? ""
        let recieverId = respDict["otherID"] as? String ?? ""
        
        let senderId = respDict["userID"] as? String ?? ""
        if  userId == senderId {
            
            var cell = tableView.dequeueReusableCell(withIdentifier: "identifier") as? RightMessageTableViewCell
            if cell == nil {
                let arr = Bundle.main.loadNibNamed("RightMessageTableViewCell", owner: self, options: nil)
                cell = arr?[0] as? RightMessageTableViewCell
            }
            //  let dateStr = respDict["created"] as? String ?? ""
            let unixtimeInterval = respDict["created"] as? String ?? ""
            print(unixtimeInterval,"Timeee")
            let date = Date(timeIntervalSince1970:  unixtimeInterval.doubleValue)
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = TimeZone(abbreviation: "IST") //Set timezone that you want
            dateFormatter.locale = NSLocale.current
            dateFormatter.dateFormat = "h:mm a" //Specify your format that you want
            let strDate = dateFormatter.string(from: date)
            
            //creation_date
            //            cell?.timeLabel.text = strDate
            //creation_date
            //  cell?.timeLabel.text = dateStr.substring(index: 12, length: 8)
            cell?.messageLBL.text = respDict["message"] as? String ?? ""
            return cell!
            
        }
        else {
            var cell1 = tableView.dequeueReusableCell(withIdentifier: "identifier") as? LeftMessageTableViewCell
            if cell1 == nil {
                let arr = Bundle.main.loadNibNamed("LeftMessageTableViewCell", owner: self, options: nil)
                cell1 = arr?[0] as? LeftMessageTableViewCell
            }
            
            let respDict = responseArray[indexPath.row]
            
            let unixtimeInterval = respDict["created"] as? String ?? ""
            print(unixtimeInterval,"Timeee")
            let date = Date(timeIntervalSince1970:  unixtimeInterval.doubleValue)
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = TimeZone(abbreviation: "IST") //Set timezone that you want
            dateFormatter.locale = NSLocale.current
            dateFormatter.dateFormat = "h:mm a" //Specify your format that you want
            let strDate = dateFormatter.string(from: date)
            
            //creation_date
            //            cell1?.timeLabel.text = strDate
            cell1?.messageLBL.text = respDict["message"] as? String ?? ""
            
            //            let recieverDetailDict = self.responseDict["receiver_detail"] as? [String:AnyObject] ?? [:]
            
            //            let unwrappedName = respDict["username"] as? String  ?? ""
            //            cell1?.recieverUserNameLbl.text = "\(unwrappedName) ,"
            // cell1?.recieverUserNameLbl.text = "\(recieverDetailDict["username"] as? String ?? ""),"
            
            
            //            var photoStr = respDict["userProfileImage"] as? String
            //            photoStr = photoStr?.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
            //            cell1?.senderTxtProfileImageView.roundCorners([.topRight,.bottomLeft,.bottomRight], radius: 11)
            //            cell1?.senderTxtProfileImageView.sd_setImage(with: URL(string:photoStr ?? ""), placeholderImage:UIImage(named: "user"))
            return cell1!
            
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}





