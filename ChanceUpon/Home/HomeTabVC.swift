//
//  HomeTabVC.swift
//  ChanceUpon
//
//  Created by Dharmani Apps mini on 8/19/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import AuthenticationServices
import CoreLocation
import SVProgressHUD
class HomeTabVC: UITabBarController{
    let loc = LocationService()
    var longitudeStr = String()
    var latitudeStr = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        loc.requestLocationAuthorization()

//        RepeatingTimer.runThisEvery(seconds: 1.5, startAfterSeconds: 1) { (timer) in
   
            self.locationUpdateBackgroundApi()
        
                     // }
//        repositionBadge(tabIndex: 0)

        
      
    }
    open func notificationBadgeCountUpdate(badgeCount:String){
//        let notificationBadgeCount = getSAppDefault(key:"NotificationBadge") as? String ?? ""
    
        if badgeCount != "" {
            if badgeCount != "0"{
           
        self.tabBar.items?[0].badgeValue = badgeCount
        self.tabBar.items?[0].badgeColor = #colorLiteral(red: 0.8686757088, green: 0.2163295448, blue: 0.4347216785, alpha: 1)
                self.repositionBadge(tabIndex: 0)

            }else{
                self.tabBar.items?[0].badgeValue = ""
                self.tabBar.items?[0].badgeColor = .clear

            }
        }
    }
    open func locationUpdateBackgroundApi(){
        
        loc.newLocation = {result in
            switch result {
            case .success(let location):
                debugPrint(location.coordinate.latitude, location.coordinate.longitude)
                self.longitudeStr = "\(location.coordinate.longitude)"
                self.latitudeStr = "\(location.coordinate.latitude)"
                setAppDefaults(self.longitudeStr, key: "Longitude")
                setAppDefaults(self.latitudeStr, key: "Latitude")


                RepeatingTimer.runThisEvery(seconds: 1.5, startAfterSeconds: 1) { (timer) in
                    let authToken = getSAppDefault(key: "AuthToken") as? String ?? ""
                       if authToken != ""{
                        self.updateLocationApi()
                       }
               }
       
            case .failure(let error):
//                DispatchQueue.main.async {
//                    Alert.present(
//                        title: AppAlertTitle.appName.rawValue,
//                        message: "\(AppHomeTabAlertMessage.userLocationError)\(error)",
//                        actions: .ok(handler: {
//                        }),
//                        from: self
//                    )
                    debugPrint("\(AppHomeTabAlertMessage.userLocationError)\(error)")
//                }
            }
        }
    }

    @objc open func updateLocationApi(){
      
        let userId  = getSAppDefault(key: "UserId") as? String ?? ""
        let params:[String:String] = ["authToken": getSAppDefault(key: "AuthToken") as? String ?? "","userID": userId,"longitude":longitudeStr,"latitude":latitudeStr]
        
        AFWrapperClass.requestPOSTURL(kBASEURL + WSMethods.updateLocation, params: params, success: { (jsonResult) in
      
            
           
            let logOutResp =   UpdateLocationData.init(dict: jsonResult as? [String:AnyHashable] ?? [:])
                if logOutResp?.status == "1"{
                    DispatchQueue.main.async {
                        self.notificationBadgeCountUpdate(badgeCount:logOutResp?.notificationBadgeCount ?? "")

                    }
                   
//                    setAppDefaults(logOutResp?.notificationBadgeCount, key: "NotificationBadge")
                    debugPrint(logOutResp?.alertMessage ?? "")
                }
                else if logOutResp?.status == "101"{
                 DispatchQueue.main.async {
                     Alert.present(
                         title: AppAlertTitle.appName.rawValue,
                         message: logOutResp?.alertMessage ?? "",
                         actions: .ok(handler: {
                             removeAppDefaults(key:"AuthToken")
                             //                                removeAppDefaults(key:"Occupation")
                            let appDel = AppDelegate()
                            appDel.logOut()

                         }),
                         from: self
                     )
                 }

                }
                else{
                }
                
                
            
        }) { (error) in
        }
    }
   
    func repositionBadge(tabIndex: Int){

        for tabBarButton in self.tabBar.subviews{
                for badgeView in tabBarButton.subviews{
                var className=NSStringFromClass(badgeView.classForCoder)
                    if  className == "_UIBadgeView"
                    {
                        badgeView.layer.transform = CATransform3DIdentity
                        badgeView.layer.transform = CATransform3DMakeTranslation(-33.0, -13.0, 1.0)
                    }
                }
            }
        
        
//        for badgeView in self.tabBar.subviews[tabIndex].subviews {
//
//            if NSStringFromClass(badgeView.classForCoder) == "_UIBadgeView" {
//
//                badgeView.layer.transform = CATransform3DIdentity
//                badgeView.layer.transform = CATransform3DMakeTranslation(-33.0, -13.0, 1.0)
//            }
//        }
    }
    
    
    
}
