//
//  AppDelegate.swift
//  ChanceUpon
//
//  Created by Dharmani Apps mini on 8/13/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import GoogleMaps

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        IQKeyboardManager.shared.enable = true
        sleep(1)
        GMSServices.provideAPIKey("AIzaSyByiySX4_RNmcpDJR54Qgh89kP2fLHy9zs")
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        appDelegate?.window = self.window
        let occupation  = getSAppDefault(key: "Occupation") as? String ?? ""
        let authToken  = getSAppDefault(key: "AuthToken") as? String ?? ""
        if authToken != ""{
            if occupation == ""{
                appDelegate?.loginToVCPage()
            }else{
                appDelegate?.loginToHomePage()
                
            }
        }else{
            appDelegate?.logOut()
        }
        
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        return true
    }
    //MARK:-  Login Functionality
    func loginToHomePage(){
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        let mainStoryboard: UIStoryboard = UIStoryboard(name: StoryboardName.Main, bundle: nil)
        let homeViewController = mainStoryboard.instantiateViewController(withIdentifier: ViewControllerIdentifier.HomeTabVC) as! HomeTabVC
        homeViewController.selectedIndex = 1
        let nav = UINavigationController(rootViewController: homeViewController)
        nav.setNavigationBarHidden(true, animated: true)
        appdelegate.window?.rootViewController = nav
    }
    func loginToAddPage(){
        let storyBoard = UIStoryboard.init(name: StoryboardName.SignUp, bundle: nil)
        let rootVc = storyBoard.instantiateViewController(withIdentifier: ViewControllerIdentifier.AddUserProfilePicsVC) as! AddUserProfilePicsVC
        let nav = UINavigationController(rootViewController: rootVc)
        nav.isNavigationBarHidden = true
        self.window?.rootViewController = nav
        self.window?.makeKeyAndVisible()
    }
    func loginToVCPage(){
        let storyBoard = UIStoryboard.init(name: StoryboardName.Main, bundle: nil)
        let rootVc = storyBoard.instantiateViewController(withIdentifier: ViewControllerIdentifier.ViewController) as! ViewController
        let nav = UINavigationController(rootViewController: rootVc)
        nav.isNavigationBarHidden = true
        self.window?.rootViewController = nav
        self.window?.makeKeyAndVisible()
    }
    //MARK:-  Logout Functionality
    func logOut(){
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        let mainStoryboard: UIStoryboard = UIStoryboard(name: StoryboardName.Main, bundle: nil)
        let homeViewController = mainStoryboard.instantiateViewController(withIdentifier: ViewControllerIdentifier.ViewController) as! ViewController
        let nav = UINavigationController(rootViewController: homeViewController)
        nav.setNavigationBarHidden(true, animated: true)
        appdelegate.window?.rootViewController = nav
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let deviceTokenString = deviceToken.map { String(format: "%02x", $0) }.joined()
        setAppDefaults(deviceTokenString, key: "DeviceToken")
    }
    // MARK: UISceneSession Lifecycle
    
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    
}

extension AppDelegate : UNUserNotificationCenterDelegate {
    
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        if let userInfo = notification.request.content.userInfo as? [String:Any]{
            print(userInfo)
            if let apnsData = userInfo["aps"] as? [String:Any]{
                if let dataObj = apnsData["data"] as? [String:Any]{
                    let notificationType = dataObj["notification_type"] as? String
                    let state = UIApplication.shared.applicationState
                    if state != .active{
                        
                        if notificationType == "1"{
                            let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
                            let rootVc = storyBoard.instantiateViewController(withIdentifier: "HomeTabVC") as! HomeTabVC
                            rootVc.selectedIndex = 1
                            setAppDefaults("YES", key: "fromAppDelegate")
                            setAppDefaults(dataObj["otherID"] as? String ?? "", key: "otherID")

//                            rootVc.fromAppDelegate = "YES"
//                            rootVc.otherId = dataObj["otherID"] as? String ?? ""
                           
                            let nav =  UINavigationController(rootViewController: rootVc)
                            nav.isNavigationBarHidden = true
                            if #available(iOS 13.0, *){
                                if let scene = UIApplication.shared.connectedScenes.first{
                                    guard let windowScene = (scene as? UIWindowScene) else { return }
                                    print(">>> windowScene: \(windowScene)")
                                    let window: UIWindow = UIWindow(frame: windowScene.coordinateSpace.bounds)
                                    window.windowScene = windowScene //Make sure to do this
                                    window.rootViewController = nav
                                    window.makeKeyAndVisible()
                                    self.window = window
                                }
                            } else {
                                self.window?.rootViewController = nav
                                self.window?.makeKeyAndVisible()
                            }
                        }
                        
                        else if notificationType == "2"{
                            let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
                            let rootVc = storyBoard.instantiateViewController(withIdentifier: "ChatDetailVC") as! ChatDetailVC
                            rootVc.fromAppDelegate = "YES"
                            let userProfilePic = UserDefaults.standard.value(forKey: "userProfilePic") as? String ?? ""
                            print(userProfilePic)
                            rootVc.closeAccount = dataObj["closeAccount"] as? String ?? ""

                            rootVc.roomId = dataObj["roomID"] as? String ?? ""
                            rootVc.onlineStatus = dataObj["online"] as? String ?? ""
                            rootVc.lastTimeOnline = dataObj["lastTime"] as? String ?? ""
                            rootVc.receiverName = dataObj["name"] as? String ?? ""
                            rootVc.dynamicMessage = dataObj["messageLabel"] as? String ?? ""
                            rootVc.cUserId = dataObj["userID"] as? String ?? ""
                            rootVc.otherId = dataObj["otherID"] as? String ?? ""
                            rootVc.profileImg = dataObj["image"] as? String ?? ""
                            rootVc.distanceInMiles = dataObj["distance_in_miles"] as? String ?? ""
                            rootVc.isFromCurrentChat = true
                            rootVc.isFromNearByPeople = false
                            
                            
                            
                            let nav = UINavigationController(rootViewController: rootVc)
                            nav.isNavigationBarHidden = true
                            if #available(iOS 13.0, *){
                                if let scene = UIApplication.shared.connectedScenes.first{
                                    guard let windowScene = (scene as? UIWindowScene) else { return }
                                    print(">>> windowScene: \(windowScene)")
                                    let window: UIWindow = UIWindow(frame: windowScene.coordinateSpace.bounds)
                                    window.windowScene = windowScene //Make sure to do this
                                    window.rootViewController = nav
                                    window.makeKeyAndVisible()
                                    self.window = window
                                }
                            } else {
                                self.window?.rootViewController = nav
                                self.window?.makeKeyAndVisible()
                            }
                        }
                        else if notificationType == "3"{
                            let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
                            let rootVc = storyBoard.instantiateViewController(withIdentifier: "ChatDetailVC") as! ChatDetailVC
                            rootVc.fromAppDelegate = "YES"
                            rootVc.onlineStatus = dataObj["online"] as? String ?? ""
                            rootVc.lastTimeOnline = dataObj["lastTime"] as? String ?? ""
                            rootVc.closeAccount = dataObj["closeAccount"] as? String ?? ""

                            let userProfilePic = UserDefaults.standard.value(forKey: "userProfilePic") as? String ?? ""
                            print(userProfilePic)
                            //                                    rootVc.senderId = dataObj["otherID"] as? String ?? ""
                            rootVc.roomId = dataObj["roomID"] as? String ?? ""
                            
                            rootVc.receiverName = dataObj["name"] as? String ?? ""
                            rootVc.dynamicMessage = dataObj["messageLabel"] as? String ?? ""
                            rootVc.cUserId = dataObj["userID"] as? String ?? ""
                            rootVc.otherId = dataObj["otherID"] as? String ?? ""
                            rootVc.profileImg = dataObj["image"] as? String ?? ""
                            rootVc.distanceInMiles = dataObj["distance_in_miles"] as? String ?? ""
                            rootVc.isFromCurrentChat = true
                            rootVc.isFromNearByPeople = false
                            
                            
                            
                            let nav = UINavigationController(rootViewController: rootVc)
                            nav.isNavigationBarHidden = true
                            if #available(iOS 13.0, *){
                                if let scene = UIApplication.shared.connectedScenes.first{
                                    guard let windowScene = (scene as? UIWindowScene) else { return }
                                    print(">>> windowScene: \(windowScene)")
                                    let window: UIWindow = UIWindow(frame: windowScene.coordinateSpace.bounds)
                                    window.windowScene = windowScene //Make sure to do this
                                    window.rootViewController = nav
                                    window.makeKeyAndVisible()
                                    self.window = window
                                }
                            } else {
                                self.window?.rootViewController = nav
                                self.window?.makeKeyAndVisible()
                            }
                        }else if notificationType == "4"{
                            let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
                            let rootVc = storyBoard.instantiateViewController(withIdentifier: "ChatDetailVC") as! ChatDetailVC
                            rootVc.fromAppDelegate = "YES"
                            rootVc.isFromMeetUpRequest = true
                            rootVc.onlineStatus = dataObj["online"] as? String ?? ""
                            rootVc.lastTimeOnline = dataObj["lastTime"] as? String ?? ""
                            rootVc.closeAccount = dataObj["closeAccount"] as? String ?? ""

                            let userProfilePic = UserDefaults.standard.value(forKey: "userProfilePic") as? String ?? ""
                            print(userProfilePic)
                            //                                    rootVc.senderId = dataObj["otherID"] as? String ?? ""
                            rootVc.roomId = dataObj["roomID"] as? String ?? ""
                            
                            rootVc.receiverName = dataObj["name"] as? String ?? ""
                            rootVc.dynamicMessage = dataObj["messageLabel"] as? String ?? ""
                            rootVc.cUserId = dataObj["userID"] as? String ?? ""
                            rootVc.otherId = dataObj["otherID"] as? String ?? ""
                            rootVc.profileImg = dataObj["image"] as? String ?? ""
                            rootVc.distanceInMiles = dataObj["distance_in_miles"] as? String ?? ""
                           
                            
                            
                            let nav = UINavigationController(rootViewController: rootVc)
                            nav.isNavigationBarHidden = true
                            if #available(iOS 13.0, *){
                                if let scene = UIApplication.shared.connectedScenes.first{
                                    guard let windowScene = (scene as? UIWindowScene) else { return }
                                    print(">>> windowScene: \(windowScene)")
                                    let window: UIWindow = UIWindow(frame: windowScene.coordinateSpace.bounds)
                                    window.windowScene = windowScene //Make sure to do this
                                    window.rootViewController = nav
                                    window.makeKeyAndVisible()
                                    self.window = window
                                }
                            } else {
                                self.window?.rootViewController = nav
                                self.window?.makeKeyAndVisible()
                            }
                        }
                        else if notificationType == "5"{
                            
                            let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
                            let rootVc = storyBoard.instantiateViewController(withIdentifier: "ChatDetailVC") as! ChatDetailVC
                            rootVc.fromAppDelegate = "YES"
                            rootVc.isFromMeetUpRequest = true
                            rootVc.onlineStatus = dataObj["online"] as? String ?? ""
                            rootVc.lastTimeOnline = dataObj["lastTime"] as? String ?? ""
                            rootVc.closeAccount = dataObj["closeAccount"] as? String ?? ""

                            let userProfilePic = UserDefaults.standard.value(forKey: "userProfilePic") as? String ?? ""
                            print(userProfilePic)
                            //                                    rootVc.senderId = dataObj["otherID"] as? String ?? ""
                            rootVc.roomId = dataObj["roomID"] as? String ?? ""
                            
                            rootVc.receiverName = dataObj["name"] as? String ?? ""
                            rootVc.dynamicMessage = dataObj["messageLabel"] as? String ?? ""
                            rootVc.cUserId = dataObj["userID"] as? String ?? ""
                            rootVc.otherId = dataObj["otherID"] as? String ?? ""
                            rootVc.profileImg = dataObj["image"] as? String ?? ""
                            rootVc.distanceInMiles = dataObj["distance_in_miles"] as? String ?? ""
                            //                                    rootVc.senderId = dataObj["otherID"] as? String ?? ""
                           
                            let nav = UINavigationController(rootViewController: rootVc)
                            nav.isNavigationBarHidden = true
                            if #available(iOS 13.0, *){
                                if let scene = UIApplication.shared.connectedScenes.first{
                                    guard let windowScene = (scene as? UIWindowScene) else { return }
                                    print(">>> windowScene: \(windowScene)")
                                    let window: UIWindow = UIWindow(frame: windowScene.coordinateSpace.bounds)
                                    window.windowScene = windowScene //Make sure to do this
                                    window.rootViewController = nav
                                    window.makeKeyAndVisible()
                                    self.window = window
                                }
                            } else {
                                self.window?.rootViewController = nav
                                self.window?.makeKeyAndVisible()
                            }
                        } else if notificationType == "6"{
                            
                            let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
                            let rootVc = storyBoard.instantiateViewController(withIdentifier: "ChatDetailVC") as! ChatDetailVC
                            rootVc.fromAppDelegate = "YES"
                            rootVc.isFromMeetUpRequest = true
                            rootVc.onlineStatus = dataObj["online"] as? String ?? ""
                            rootVc.lastTimeOnline = dataObj["lastTime"] as? String ?? ""
                            rootVc.closeAccount = dataObj["closeAccount"] as? String ?? ""

                            let userProfilePic = UserDefaults.standard.value(forKey: "userProfilePic") as? String ?? ""
                            print(userProfilePic)
                            //                                    rootVc.senderId = dataObj["otherID"] as? String ?? ""
                            rootVc.roomId = dataObj["roomID"] as? String ?? ""
                            
                            rootVc.receiverName = dataObj["name"] as? String ?? ""
                            rootVc.dynamicMessage = dataObj["messageLabel"] as? String ?? ""
                            rootVc.cUserId = dataObj["userID"] as? String ?? ""
                            rootVc.otherId = dataObj["otherID"] as? String ?? ""
                            rootVc.profileImg = dataObj["image"] as? String ?? ""
                            rootVc.distanceInMiles = dataObj["distance_in_miles"] as? String ?? ""
                            //                                    rootVc.senderId = dataObj["otherID"] as? String ?? ""
                           
                            let nav = UINavigationController(rootViewController: rootVc)
                            nav.isNavigationBarHidden = true
                            if #available(iOS 13.0, *){
                                if let scene = UIApplication.shared.connectedScenes.first{
                                    guard let windowScene = (scene as? UIWindowScene) else { return }
                                    print(">>> windowScene: \(windowScene)")
                                    let window: UIWindow = UIWindow(frame: windowScene.coordinateSpace.bounds)
                                    window.windowScene = windowScene //Make sure to do this
                                    window.rootViewController = nav
                                    window.makeKeyAndVisible()
                                    self.window = window
                                }
                            } else {
                                self.window?.rootViewController = nav
                                self.window?.makeKeyAndVisible()
                            }
                        } else if notificationType == "7"{
                            
                            let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
                            let rootVc = storyBoard.instantiateViewController(withIdentifier: "ChatDetailVC") as! ChatDetailVC
                            rootVc.fromAppDelegate = "YES"
                            rootVc.isFromCurrentChat = true
                            rootVc.isFromNearByPeople = false
                            rootVc.onlineStatus = dataObj["online"] as? String ?? ""
                            rootVc.lastTimeOnline = dataObj["lastTime"] as? String ?? ""
                            rootVc.closeAccount = dataObj["closeAccount"] as? String ?? ""

                            let userProfilePic = UserDefaults.standard.value(forKey: "userProfilePic") as? String ?? ""
                            print(userProfilePic)
                            //                                    rootVc.senderId = dataObj["otherID"] as? String ?? ""
                            rootVc.roomId = dataObj["roomID"] as? String ?? ""
                            
                            rootVc.receiverName = dataObj["name"] as? String ?? ""
                            rootVc.dynamicMessage = dataObj["messageLabel"] as? String ?? ""
                            rootVc.cUserId = dataObj["userID"] as? String ?? ""
                            rootVc.otherId = dataObj["otherID"] as? String ?? ""
                            rootVc.profileImg = dataObj["image"] as? String ?? ""
                            rootVc.distanceInMiles = dataObj["distance_in_miles"] as? String ?? ""
                            //                                    rootVc.senderId = dataObj["otherID"] as? String ?? ""
                           
                            let nav = UINavigationController(rootViewController: rootVc)
                            nav.isNavigationBarHidden = true
                            if #available(iOS 13.0, *){
                                if let scene = UIApplication.shared.connectedScenes.first{
                                    guard let windowScene = (scene as? UIWindowScene) else { return }
                                    print(">>> windowScene: \(windowScene)")
                                    let window: UIWindow = UIWindow(frame: windowScene.coordinateSpace.bounds)
                                    window.windowScene = windowScene //Make sure to do this
                                    window.rootViewController = nav
                                    window.makeKeyAndVisible()
                                    self.window = window
                                }
                            } else {
                                self.window?.rootViewController = nav
                                self.window?.makeKeyAndVisible()
                            }
                        }
                    }
                }
            }
        }
//        completionHandler()
        
        
        
        
        // Print full message.
        //        print("user info is \(userInfo)")
        
        // Change this to your preferred presentation option
        // completionHandler([])
        //Show Push notification in foreground
        completionHandler([.alert, .badge, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        if let userInfo = response.notification.request.content.userInfo as? [String:Any]{
            print(userInfo)
            if let apnsData = userInfo["aps"] as? [String:Any]{
                if let dataObj = apnsData["data"] as? [String:Any]{
                    let notificationType = dataObj["notification_type"] as? String
                    let state = UIApplication.shared.applicationState
                    if state != .active{
                        
                        if notificationType == "1"{
                            let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
                            let rootVc = storyBoard.instantiateViewController(withIdentifier: "HomeTabVC") as! HomeTabVC
                            rootVc.selectedIndex = 1
                            setAppDefaults("YES", key: "fromAppDelegate")
                            setAppDefaults(dataObj["otherID"] as? String ?? "", key: "otherID")
                           
                            let nav =  UINavigationController(rootViewController: rootVc)
                            nav.isNavigationBarHidden = true
                            if #available(iOS 13.0, *){
                                if let scene = UIApplication.shared.connectedScenes.first{
                                    guard let windowScene = (scene as? UIWindowScene) else { return }
                                    print(">>> windowScene: \(windowScene)")
                                    let window: UIWindow = UIWindow(frame: windowScene.coordinateSpace.bounds)
                                    window.windowScene = windowScene //Make sure to do this
                                    window.rootViewController = nav
                                    window.makeKeyAndVisible()
                                    self.window = window
                                }
                            } else {
                                self.window?.rootViewController = nav
                                self.window?.makeKeyAndVisible()
                            }
                        }
                        
                        else if notificationType == "2"{
                            let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
                            let rootVc = storyBoard.instantiateViewController(withIdentifier: "ChatDetailVC") as! ChatDetailVC
                            rootVc.fromAppDelegate = "YES"
                            let userProfilePic = UserDefaults.standard.value(forKey: "userProfilePic") as? String ?? ""
                            print(userProfilePic)
                            rootVc.closeAccount = dataObj["closeAccount"] as? String ?? ""

                            rootVc.roomId = dataObj["roomID"] as? String ?? ""
                            rootVc.onlineStatus = dataObj["online"] as? String ?? ""
                            rootVc.lastTimeOnline = dataObj["lastTime"] as? String ?? ""
                            rootVc.receiverName = dataObj["name"] as? String ?? ""
                            rootVc.dynamicMessage = dataObj["messageLabel"] as? String ?? ""
                            rootVc.cUserId = dataObj["userID"] as? String ?? ""
                            rootVc.otherId = dataObj["otherID"] as? String ?? ""
                            rootVc.profileImg = dataObj["image"] as? String ?? ""
                            rootVc.distanceInMiles = dataObj["distance_in_miles"] as? String ?? ""
                            rootVc.isFromCurrentChat = true
                            rootVc.isFromNearByPeople = false
                            
                            
                            
                            let nav = UINavigationController(rootViewController: rootVc)
                            nav.isNavigationBarHidden = true
                            if #available(iOS 13.0, *){
                                if let scene = UIApplication.shared.connectedScenes.first{
                                    guard let windowScene = (scene as? UIWindowScene) else { return }
                                    print(">>> windowScene: \(windowScene)")
                                    let window: UIWindow = UIWindow(frame: windowScene.coordinateSpace.bounds)
                                    window.windowScene = windowScene //Make sure to do this
                                    window.rootViewController = nav
                                    window.makeKeyAndVisible()
                                    self.window = window
                                }
                            } else {
                                self.window?.rootViewController = nav
                                self.window?.makeKeyAndVisible()
                            }
                        }
                        else if notificationType == "3"{
                            let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
                            let rootVc = storyBoard.instantiateViewController(withIdentifier: "ChatDetailVC") as! ChatDetailVC
                            rootVc.fromAppDelegate = "YES"
                            rootVc.onlineStatus = dataObj["online"] as? String ?? ""
                            rootVc.lastTimeOnline = dataObj["lastTime"] as? String ?? ""
                            rootVc.closeAccount = dataObj["closeAccount"] as? String ?? ""

                            let userProfilePic = UserDefaults.standard.value(forKey: "userProfilePic") as? String ?? ""
                            print(userProfilePic)
                            //                                    rootVc.senderId = dataObj["otherID"] as? String ?? ""
                            rootVc.roomId = dataObj["roomID"] as? String ?? ""
                            
                            rootVc.receiverName = dataObj["name"] as? String ?? ""
                            rootVc.dynamicMessage = dataObj["messageLabel"] as? String ?? ""
                            rootVc.cUserId = dataObj["userID"] as? String ?? ""
                            rootVc.otherId = dataObj["otherID"] as? String ?? ""
                            rootVc.profileImg = dataObj["image"] as? String ?? ""
                            rootVc.distanceInMiles = dataObj["distance_in_miles"] as? String ?? ""
                            rootVc.isFromCurrentChat = true
                            rootVc.isFromNearByPeople = false
                            
                            
                            
                            let nav = UINavigationController(rootViewController: rootVc)
                            nav.isNavigationBarHidden = true
                            if #available(iOS 13.0, *){
                                if let scene = UIApplication.shared.connectedScenes.first{
                                    guard let windowScene = (scene as? UIWindowScene) else { return }
                                    print(">>> windowScene: \(windowScene)")
                                    let window: UIWindow = UIWindow(frame: windowScene.coordinateSpace.bounds)
                                    window.windowScene = windowScene //Make sure to do this
                                    window.rootViewController = nav
                                    window.makeKeyAndVisible()
                                    self.window = window
                                }
                            } else {
                                self.window?.rootViewController = nav
                                self.window?.makeKeyAndVisible()
                            }
                        }else if notificationType == "4"{
                            let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
                            let rootVc = storyBoard.instantiateViewController(withIdentifier: "ChatDetailVC") as! ChatDetailVC
                            rootVc.fromAppDelegate = "YES"
                            rootVc.isFromMeetUpRequest = true
                            rootVc.onlineStatus = dataObj["online"] as? String ?? ""
                            rootVc.lastTimeOnline = dataObj["lastTime"] as? String ?? ""
                            rootVc.closeAccount = dataObj["closeAccount"] as? String ?? ""

                            let userProfilePic = UserDefaults.standard.value(forKey: "userProfilePic") as? String ?? ""
                            print(userProfilePic)
                            //                                    rootVc.senderId = dataObj["otherID"] as? String ?? ""
                            rootVc.roomId = dataObj["roomID"] as? String ?? ""
                            
                            rootVc.receiverName = dataObj["name"] as? String ?? ""
                            rootVc.dynamicMessage = dataObj["messageLabel"] as? String ?? ""
                            rootVc.cUserId = dataObj["userID"] as? String ?? ""
                            rootVc.otherId = dataObj["otherID"] as? String ?? ""
                            rootVc.profileImg = dataObj["image"] as? String ?? ""
                            rootVc.distanceInMiles = dataObj["distance_in_miles"] as? String ?? ""
                           
                            
                            
                            let nav = UINavigationController(rootViewController: rootVc)
                            nav.isNavigationBarHidden = true
                            if #available(iOS 13.0, *){
                                if let scene = UIApplication.shared.connectedScenes.first{
                                    guard let windowScene = (scene as? UIWindowScene) else { return }
                                    print(">>> windowScene: \(windowScene)")
                                    let window: UIWindow = UIWindow(frame: windowScene.coordinateSpace.bounds)
                                    window.windowScene = windowScene //Make sure to do this
                                    window.rootViewController = nav
                                    window.makeKeyAndVisible()
                                    self.window = window
                                }
                            } else {
                                self.window?.rootViewController = nav
                                self.window?.makeKeyAndVisible()
                            }
                        }
                        else if notificationType == "5"{
                            
                            let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
                            let rootVc = storyBoard.instantiateViewController(withIdentifier: "ChatDetailVC") as! ChatDetailVC
                            rootVc.fromAppDelegate = "YES"
                            rootVc.isFromMeetUpRequest = true
                            rootVc.onlineStatus = dataObj["online"] as? String ?? ""
                            rootVc.lastTimeOnline = dataObj["lastTime"] as? String ?? ""
                            rootVc.closeAccount = dataObj["closeAccount"] as? String ?? ""

                            let userProfilePic = UserDefaults.standard.value(forKey: "userProfilePic") as? String ?? ""
                            print(userProfilePic)
                            //                                    rootVc.senderId = dataObj["otherID"] as? String ?? ""
                            rootVc.roomId = dataObj["roomID"] as? String ?? ""
                            
                            rootVc.receiverName = dataObj["name"] as? String ?? ""
                            rootVc.dynamicMessage = dataObj["messageLabel"] as? String ?? ""
                            rootVc.cUserId = dataObj["userID"] as? String ?? ""
                            rootVc.otherId = dataObj["otherID"] as? String ?? ""
                            rootVc.profileImg = dataObj["image"] as? String ?? ""
                            rootVc.distanceInMiles = dataObj["distance_in_miles"] as? String ?? ""
                            //                                    rootVc.senderId = dataObj["otherID"] as? String ?? ""
                           
                            let nav = UINavigationController(rootViewController: rootVc)
                            nav.isNavigationBarHidden = true
                            if #available(iOS 13.0, *){
                                if let scene = UIApplication.shared.connectedScenes.first{
                                    guard let windowScene = (scene as? UIWindowScene) else { return }
                                    print(">>> windowScene: \(windowScene)")
                                    let window: UIWindow = UIWindow(frame: windowScene.coordinateSpace.bounds)
                                    window.windowScene = windowScene //Make sure to do this
                                    window.rootViewController = nav
                                    window.makeKeyAndVisible()
                                    self.window = window
                                }
                            } else {
                                self.window?.rootViewController = nav
                                self.window?.makeKeyAndVisible()
                            }
                        } else if notificationType == "6"{
                            
                            let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
                            let rootVc = storyBoard.instantiateViewController(withIdentifier: "ChatDetailVC") as! ChatDetailVC
                            rootVc.fromAppDelegate = "YES"
                            rootVc.isFromCurrentChat = true
                            rootVc.isFromNearByPeople = false
                            rootVc.onlineStatus = dataObj["online"] as? String ?? ""
                            rootVc.lastTimeOnline = dataObj["lastTime"] as? String ?? ""
                            rootVc.closeAccount = dataObj["closeAccount"] as? String ?? ""

                            let userProfilePic = UserDefaults.standard.value(forKey: "userProfilePic") as? String ?? ""
                            print(userProfilePic)
                            //                                    rootVc.senderId = dataObj["otherID"] as? String ?? ""
                            rootVc.roomId = dataObj["roomID"] as? String ?? ""
                            
                            rootVc.receiverName = dataObj["name"] as? String ?? ""
                            rootVc.dynamicMessage = dataObj["messageLabel"] as? String ?? ""
                            rootVc.cUserId = dataObj["userID"] as? String ?? ""
                            rootVc.otherId = dataObj["otherID"] as? String ?? ""
                            rootVc.profileImg = dataObj["image"] as? String ?? ""
                            rootVc.distanceInMiles = dataObj["distance_in_miles"] as? String ?? ""
                            //                                    rootVc.senderId = dataObj["otherID"] as? String ?? ""
                           
                            let nav = UINavigationController(rootViewController: rootVc)
                            nav.isNavigationBarHidden = true
                            if #available(iOS 13.0, *){
                                if let scene = UIApplication.shared.connectedScenes.first{
                                    guard let windowScene = (scene as? UIWindowScene) else { return }
                                    print(">>> windowScene: \(windowScene)")
                                    let window: UIWindow = UIWindow(frame: windowScene.coordinateSpace.bounds)
                                    window.windowScene = windowScene //Make sure to do this
                                    window.rootViewController = nav
                                    window.makeKeyAndVisible()
                                    self.window = window
                                }
                            } else {
                                self.window?.rootViewController = nav
                                self.window?.makeKeyAndVisible()
                            }
                        } else if notificationType == "7"{
                            
                            let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
                            let rootVc = storyBoard.instantiateViewController(withIdentifier: "ChatDetailVC") as! ChatDetailVC
                            rootVc.fromAppDelegate = "YES"
                            rootVc.isFromCurrentChat = true
                            rootVc.isFromNearByPeople = false
                            rootVc.onlineStatus = dataObj["online"] as? String ?? ""
                            rootVc.lastTimeOnline = dataObj["lastTime"] as? String ?? ""
                            rootVc.closeAccount = dataObj["closeAccount"] as? String ?? ""

                            let userProfilePic = UserDefaults.standard.value(forKey: "userProfilePic") as? String ?? ""
                            print(userProfilePic)
                            //                                    rootVc.senderId = dataObj["otherID"] as? String ?? ""
                            rootVc.roomId = dataObj["roomID"] as? String ?? ""
                            
                            rootVc.receiverName = dataObj["name"] as? String ?? ""
                            rootVc.dynamicMessage = dataObj["messageLabel"] as? String ?? ""
                            rootVc.cUserId = dataObj["userID"] as? String ?? ""
                            rootVc.otherId = dataObj["otherID"] as? String ?? ""
                            rootVc.profileImg = dataObj["image"] as? String ?? ""
                            rootVc.distanceInMiles = dataObj["distance_in_miles"] as? String ?? ""
                            //                                    rootVc.senderId = dataObj["otherID"] as? String ?? ""
                           
                            let nav = UINavigationController(rootViewController: rootVc)
                            nav.isNavigationBarHidden = true
                            if #available(iOS 13.0, *){
                                if let scene = UIApplication.shared.connectedScenes.first{
                                    guard let windowScene = (scene as? UIWindowScene) else { return }
                                    print(">>> windowScene: \(windowScene)")
                                    let window: UIWindow = UIWindow(frame: windowScene.coordinateSpace.bounds)
                                    window.windowScene = windowScene //Make sure to do this
                                    window.rootViewController = nav
                                    window.makeKeyAndVisible()
                                    self.window = window
                                }
                            } else {
                                self.window?.rootViewController = nav
                                self.window?.makeKeyAndVisible()
                            }
                        }
                    }
                }
            }
        }
        completionHandler()
    }
    
    func convertStringToDictionary(json: String) -> [String: AnyObject]? {
        if let data = json.data(using: String.Encoding.utf8) {
            let json = try? JSONSerialization.jsonObject(with: data, options:.mutableContainers) as? [String: AnyObject]
            //            if let error = error {
            //            print(error!)
            //}
            return json!
        }
        return nil
    }
    
}
