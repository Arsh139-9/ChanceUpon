//
//  LocationChildTabVC.swift
//  ChanceUpon
//
//  Created by Dharmani Apps mini on 8/19/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import GoogleMaps
import SVProgressHUD

class LocationChildTabVC: UIViewController {
    
    let rest = RestManager()
    var pageCount = Int()
//    var nearByPeopleArr = [NearByUserDetail<AnyHashable>]()
    var appDel = AppDelegate()
    var fromAppDelegate: String?
    var otherId: String?

    
    @IBOutlet weak var swipeLbl: UILabel!
    
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var dynamicNumberPeople: UILabel!
    var nearByPeopleArr = [[String:AnyHashable]]()
    var nearByPeopleStruct = NearByUserDetailData<AnyHashable>(dict:[:])
    @IBOutlet weak var nearByPeopleCV: UICollectionView!
    
    @IBOutlet weak var userProfileImgView: UIImageView!
    
    @IBOutlet weak var nearByPeopleViewTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var swipeView: UIView!
    
    @IBOutlet weak var cardImgView: UIImageView!
    
    @IBOutlet weak var svpV: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        svpV.isHidden = true
        addSwipe(view: swipeView)
        addSwipe(view: cardImgView)
        addSwipe(view: svpV)

//        addSwipe(view: nearByPeopleCV)

        mapView.delegate = self
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

        let userProfileImg = getSAppDefault(key: "UserProfileImage") as? String ?? ""
           var photoStr = userProfileImg
           photoStr = photoStr.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
               userProfileImgView.sd_setImage(with: URL(string: photoStr), placeholderImage:UIImage(named: "userProfilePlaceholderImg"))
           
        seObserverForOrientationChanging()
        pageCount = 1
        getAllNearByUsersApi(indexPath:IndexPath())
        if self.nearByPeopleViewTopConstraint.constant == 479{
            self.mapView.isHidden = false
        }else{
            self.mapView.isHidden = true

        }
    }
    open func getAllNearByUsersApi(indexPath:IndexPath){
        guard let url = URL(string: kBASEURL + WSMethods.getAllNearByUsers) else { return }

        let userId  = getSAppDefault(key: "UserId") as? String ?? ""
        let authToken  = getSAppDefault(key: "AuthToken") as? String ?? ""
        let latitudeStr  = getSAppDefault(key: "Latitude") as? String ?? ""
        let longitudeStr  = getSAppDefault(key: "Longitude") as? String ?? ""
        
        rest.requestHttpHeaders.add(value: "application/json", forKey: "Content-Type")
        rest.httpBodyParameters.add(value: userId, forKey: "userID")
        rest.httpBodyParameters.add(value: authToken, forKey: "authToken")
        rest.httpBodyParameters.add(value: latitudeStr, forKey: "latitude")
        rest.httpBodyParameters.add(value: longitudeStr, forKey: "longitude")
        rest.httpBodyParameters.add(value: "10", forKey: "distance")
        rest.httpBodyParameters.add(value: "\(pageCount)", forKey: "pageNo")

        SVProgressHUD.show()
        self.nearByPeopleArr.removeAll()
        rest.makeRequest(toURL: url, withHttpMethod: .post) { (results) in
            SVProgressHUD.dismiss()

            
            guard let response = results.response else { return }
            if response.httpStatusCode == 200 {
                guard let data = results.data else { return }
                
                let jsonResult = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:AnyHashable] ?? [:]
            
                let nearByUserResp = NearByUserDetailData.init(dict: jsonResult ?? [:])
                self.nearByPeopleStruct = nearByUserResp
                if nearByUserResp?.status == "1"{
                    if Int(truncating: NSNumber(value: self.pageCount )) > 1 {
                        var firstPageArray = getSAppDefault(key: "FirstPageArray") as? [[String:AnyHashable]]
//                        var firstPageArray = UserDefaults.standard.array(forKey: "FirstPageArray") as? [NearByUserDetail<AnyHashable>]
                        let pageDictArray = nearByUserResp?.nearByUserArr
                        for obj in pageDictArray ?? [] {
                            firstPageArray?.append(obj)
                            self.nearByPeopleArr = firstPageArray!
                        }
                        setAppDefaults(self.nearByPeopleArr, key: "FirstPageArray")

                    }else{

                        self.nearByPeopleArr = nearByUserResp!.nearByUserArr
                      
                        setAppDefaults( self.nearByPeopleArr, key: "FirstPageArray")

                    }
                    self.fromAppDelegate = getAppDefaults(key: "fromAppDelegate") ?? ""
                    self.otherId = getAppDefaults(key: "otherID") ?? ""

                
                    if self.fromAppDelegate == "YES" {
                        for  i in 0..<self.nearByPeopleArr.count {
                            let userId = (self.nearByPeopleArr[i])["userID"] as? String ?? ""
                            if self.otherId == userId {
                               removeAppDefaults(key: "fromAppDelegate")
                                removeAppDefaults(key: "otherID")

                                let storyBoard = UIStoryboard(name: StoryboardName.Main, bundle: nil)
                                    let CMDVC = storyBoard.instantiateViewController(withIdentifier: ViewControllerIdentifier.NearByPeopleVC) as? NearByPeopleVC
                                CMDVC?.onlineStatus = self.nearByPeopleArr[i]["online"] as? String ?? ""
                                CMDVC?.lastTimeOnline = self.nearByPeopleArr[i]["lastTime"] as? String ?? ""
                                CMDVC?.index = i
                                CMDVC?.fromAppDelegate = "YES"
                                    if let CMDVC = CMDVC {
                                        self.navigationController?.pushViewController(CMDVC, animated: true)
                                    }
                                self.fromAppDelegate = "NO"
                                break
                            }
                            }
                        }
                    
                }
                
                else{
                    DispatchQueue.main.async {

                    Alert.present(
                        title: AppAlertTitle.appName.rawValue,
                        message: nearByUserResp?.alertMessage ?? "",
                        actions: .ok(handler: {
                        }),
                        from: self
                    )
                    }
                }
                DispatchQueue.main.async {
                    self.dynamicNumberPeople.text = "\(self.nearByPeopleArr.count) people near you"
                self.nearByPeopleCV.reloadData()
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
            gesture.numberOfTouchesRequired = 1
            view.addGestureRecognizer(gesture)// self.view
        }
    }

    @objc func handleSwipe(sender: UISwipeGestureRecognizer) {
        let direction = sender.direction
        switch direction {
            case .right:
                print("Gesture direction: Right")
            case .left:
                print("Gesture direction: Left")
            case .up:
                print("Gesture direction: Up")
            
                    self.svpV.isHidden = true

                
                
                self.mapView.isHidden = true
            self.nearByPeopleViewTopConstraint.constant = 150
                
            case .down:
                svpV.isHidden = false

             
                self.nearByPeopleViewTopConstraint.constant = 479
                self.mapView.isHidden = false

                let latitudeStr  = getSAppDefault(key: "Latitude") as? String ?? ""
                let longitudeStr  = getSAppDefault(key: "Longitude") as? String ?? ""
                let latitude = (latitudeStr as NSString).doubleValue
                let longitude = (longitudeStr as NSString).doubleValue
                let camera = GMSCameraPosition.camera(withLatitude:latitude, longitude: longitude, zoom: 13.0)
                
                    let  mapView = GMSMapView.map(withFrame: self.mapView.frame, camera: camera)
                if let styleStringURLPath = Bundle.main.path(forResource: "mapstyle-Mark", ofType: "json") {
                                let styleURL = URL(fileURLWithPath: styleStringURLPath)
                                do {
                                    mapView.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
                                } catch let error {
                                    debugPrint(error.localizedDescription)
                                }
                            }
                self.mapView.addSubview(mapView)
                // Creates a marker in the center of the map.
                for obj in nearByPeopleArr{
                  let latStr =  obj["latitude"] as? String ?? ""
                    let longStr =  obj["longitude"] as? String ?? ""
                    let lati = (latStr as NSString).doubleValue
                    let longi = (longStr as NSString).doubleValue
                        let marker = GMSMarker()
                        marker.position = CLLocationCoordinate2D(latitude: lati, longitude: longi)
//                        marker.title = "Punjab"
//                        marker.snippet = "Patiala"
                       
                let house = UIImage(named: "markerViewIcon")!.withRenderingMode(.alwaysTemplate)
                    let markerView = UIImageView(image: house)
                     markerView.tintColor = .red
//                        marker.iconView = markerView
                marker.icon = UIImage(named: "markerIcon")
                        marker.map = mapView
                
                }
                print("Gesture direction: Down")
            default:
                print("Unrecognized Gesture Direction")
        }
        

        
    }
    @IBAction func profileBtnAction(_ sender: UIButton) {
        Navigation.init().pushCallBack(ViewControllerIdentifier.ProfileVC,StoryboardName.Settings,LocationChildTabVC(),self.storyboard!, self.navigationController!)
 
    }
    
    @IBAction func animateViewBtnAction(_ sender: UIButton) {
        if sender.tag == 0{
            UIView.animate(withDuration: 13.0) {
                self.nearByPeopleViewTopConstraint.constant = 479
            }
            sender.tag = 1
        }else{
            UIView.animate(withDuration: 13.0) {
                self.nearByPeopleViewTopConstraint.constant = 150
            }
            sender.tag = 0
        }
        
        
    }
    
   
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        nearByPeopleCV.collectionViewLayout.invalidateLayout()
    }
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
            nearByPeopleCV.reloadData()
            //        [_vesselIPadCV invalidateIntrinsicContentSize];
        }
    }
 
    
    
}
extension LocationChildTabVC:UICollectionViewDataSource,UICollectionViewDelegate{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return nearByPeopleArr.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let cell = nearByPeopleCV.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? SendInterestListCell
        if nearByPeopleArr.count > 0{
        
        let obj =  nearByPeopleArr[indexPath.row]
        let imgArr = obj["userImages"] as? [[String:AnyHashable]] ?? [[:]]
        if imgArr.count > 0{
        let imgDict = imgArr[0]
        let image = imgDict["userProfileImage"] as? String ?? ""
            var photoStr = image
            photoStr = photoStr.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
//            if photoStr != ""{
                cell?.nearByUserProfileImg.sd_setImage(with: URL(string: photoStr), placeholderImage:UIImage(named: "nearByUserPlaceholderImg"))
            //}
        }else{
            cell?.nearByUserProfileImg.sd_setImage(with: URL(string: ""), placeholderImage:UIImage(named: "nearByUserPlaceholderImg"))

        }

      
        cell?.nearByUserDistanceLbl.text = obj["distance_in_miles"] as? String ?? ""
        cell?.nearByUserNameAgeLbl.text = obj["name"] as? String ?? "" + ", \(obj["age"] as? String ?? "")"
        }
      

//                    self.sendInterestCVHeightConstraint.constant = self.sendInterestCV.contentSize.height
        return cell!
        
        
        
        
        
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == nearByPeopleArr.count - 1 {
            if nearByPeopleStruct?.lastPage == "FALSE" {
                pageCount = pageCount + 1
                getAllNearByUsersApi(indexPath: IndexPath())
            }
        } else {
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
        if nearByPeopleArr.count > 0{
        let storyBoard = UIStoryboard(name: StoryboardName.Main, bundle: nil)
            let CMDVC = storyBoard.instantiateViewController(withIdentifier: ViewControllerIdentifier.NearByPeopleVC) as? NearByPeopleVC
            CMDVC?.closeAccount = self.nearByPeopleArr[indexPath.row]["closeAccount"] as? String ?? ""
            CMDVC?.onlineStatus = self.nearByPeopleArr[indexPath.row]["online"] as? String ?? ""
            CMDVC?.lastTimeOnline = self.nearByPeopleArr[indexPath.row]["lastTime"] as? String ?? ""
        CMDVC?.nearByPeopleArr = self.nearByPeopleArr
        CMDVC?.indexPath = indexPath
            if let CMDVC = CMDVC {
                self.navigationController?.pushViewController(CMDVC, animated: true)
            }
        }
       
    }
    
}

extension LocationChildTabVC:UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }
            func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
                return 10
            }
    
            func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
                return 10
            }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //        return  CGSizeMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.width/2.3);
//        return CGSize(width: collectionView.frame.size.width/2, height: collectionView.frame.size.width/2)
      
        
        
        return CGSize(width: UIScreen.main.bounds.width/2.213, height: UIScreen.main.bounds.width/1.77)
        
        //            let yourWidth = (UIScreen.main.bounds.width * 0.95)/2
        //            return CGSize(width: yourWidth-10.0, height: yourWidth-10.0)
    }
}
extension LocationChildTabVC:GMSMapViewDelegate{

    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
//        let storyBoard = UIStoryboard(name: StoryboardName.Main, bundle: nil)
//            let CMDVC = storyBoard.instantiateViewController(withIdentifier: ViewControllerIdentifier.NearByPeopleVC) as? NearByPeopleVC
//        CMDVC?.nearByPeopleArr = nearByPeopleArr
//            if let CMDVC = CMDVC {
//                navigationController?.pushViewController(CMDVC, animated: true)
//            }
        print("")
        return true
    }
}
