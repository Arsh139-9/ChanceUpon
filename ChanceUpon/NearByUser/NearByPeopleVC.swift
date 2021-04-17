//
//  NearByPeopleVC.swift
//  ChanceUpon
//
//  Created by Dharmani Apps mini on 8/24/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import UserNotifications
import ImageSlideshow
import SVProgressHUD
import GoogleMaps

class NearByPeopleVC: UIViewController {
    let rest = RestManager()
    @IBOutlet weak var nearByPeopleCV: UICollectionView!
    lazy var collectionViewFlowLayout = UICollectionViewFlowLayout()
    @IBOutlet weak var nearByPeopleViewTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var userProfileImgView: UIImageView!
    @IBOutlet weak var animateCardImgView: UIImageView!
    
    @IBOutlet weak var dynamicNumberPeople: UILabel!
    
    @IBOutlet weak var mapView: GMSMapView!
    var onlineStatus = ""
    var closeAccount = ""

    var lastTimeOnline = ""
    var appDelegate  = AppDelegate()
    var fromAppDelegate: String?
    var nearByPeopleArr = [[String:AnyHashable]]()
   var sdWebSourceImageArr = [SDWebImageSource]()
    var currentPage = 0
    var indexPath = IndexPath()
    var index = Int()
    var availableStatus = String()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.dynamicNumberPeople.text = "\(self.nearByPeopleArr.count) people near you"
        mapView.delegate = self

        
        let userProfileImg = getSAppDefault(key: "UserProfileImage") as? String ?? ""
           var photoStr = userProfileImg
           photoStr = photoStr.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
               userProfileImgView.sd_setImage(with: URL(string: photoStr), placeholderImage:UIImage(named: "userProfilePlaceholderImg"))
           
        // Do any additional setup after loading the view.
        nearByPeopleCV.register(UINib(nibName: "NearByCV", bundle: nil), forCellWithReuseIdentifier: "NearByCV")
        collectionViewFlowLayout.scrollDirection = .horizontal
        nearByPeopleCV.collectionViewLayout = collectionViewFlowLayout
        nearByPeopleCV.isPagingEnabled = false
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
            if fromAppDelegate == "YES"{
                let storyBoard = UIStoryboard(name: StoryboardName.Main, bundle: nil)
                let DVC = storyBoard.instantiateViewController(withIdentifier: ViewControllerIdentifier.HomeTabVC) as? HomeTabVC
                DVC?.selectedIndex = 1
                if let DVC = DVC {
                    self.navigationController?.pushViewController(DVC, animated: true)
                }
            }else{
                navigationController?.popViewController(animated: true)
            }
        case .left:
            print("Gesture direction: Left")
        case .up:
            self.mapView.isHidden = true
            self.nearByPeopleViewTopConstraint.constant = 150
            print("Gesture direction: Up")
            animateCardImgView.contentMode = .scaleToFill
            
        case .down:
            self.nearByPeopleViewTopConstraint.constant = 517
            self.mapView.isHidden = false
            animateCardImgView.layer.cornerRadius = 27
            animateCardImgView.layer.masksToBounds = true
            animateCardImgView.contentMode = .scaleAspectFill
            
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
    func getMinutesDifferenceFromTwoDates(start: Date, end: Date) -> Int
       {

           let diff = Int(end.timeIntervalSince1970 - start.timeIntervalSince1970)

           let hours = diff / 3600
           let minutes = (diff - hours * 3600) / 60
           return minutes
       }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tabBarController?.tabBar.isHidden = false

        if self.nearByPeopleViewTopConstraint.constant == 517{
            self.mapView.isHidden = false
        }else{
            self.mapView.isHidden = true

        }
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
                availableStatus = "Not Available"
            }
//            availableStatus = "Available"
        }
        
        self.nearByPeopleCV.performBatchUpdates ({
            self.nearByPeopleCV.reloadData()
        }, completion: { _ in
            if self.fromAppDelegate == "YES"{
                self.nearByPeopleCV.scrollToItem(at: IndexPath(item:self.index, section: 0),
                 at: .right,
                 animated: false)
                self.fromAppDelegate = "NO"
            }else{
                self.nearByPeopleCV.scrollToItem(at: IndexPath(item: self.indexPath.item, section: 0),
                 at: .right,
                 animated: false)
            }
          
        })
        
    }
    open func likeDisLikeUserApi(otherId:String,url:URL,likeStatus:String,indexPath:IndexPath){

        let userId  = getSAppDefault(key: "UserId") as? String ?? ""
       
        
        rest.requestHttpHeaders.add(value: "application/json", forKey: "Content-Type")
        rest.httpBodyParameters.add(value: userId, forKey: "userID")
        rest.httpBodyParameters.add(value: otherId, forKey: "otherID")
       
        SVProgressHUD.show()

        rest.makeRequest(toURL: url, withHttpMethod: .post) { (results) in
            SVProgressHUD.dismiss()
            
            guard let response = results.response else { return }
            if response.httpStatusCode == 200 {
                guard let data = results.data else { return }
                
                let jsonResult = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:AnyHashable] ?? [:]
                if likeStatus == "0"{
                    let disLikeUserResp = LogOutData.init(dict: jsonResult ?? [:])
                    if disLikeUserResp?.status == "1"{
                            DispatchQueue.main.async {

                        self.navigationController?.popViewController(animated: true)
                            }

                    }else{
                        DispatchQueue.main.async {

                        Alert.present(
                            title: AppAlertTitle.appName.rawValue,
                            message: disLikeUserResp?.alertMessage ?? "",
                            actions: .ok(handler: {
                            }),
                            from: self
                        )
                        }
                    }
                }else{
                    let likeUserResp = LikedUserData.init(dict: jsonResult ?? [:])
                    if likeUserResp?.status == "1"{
    //
                        DispatchQueue.main.async {

                        Alert.present(
                            title: AppAlertTitle.appName.rawValue,
                            message: likeUserResp?.alertMessage ?? "",
                            actions: .ok(handler: {
                                let CMDVC = self.storyboard?.instantiateViewController(withIdentifier: ViewControllerIdentifier.MeetNowChatVC) as? ChatDetailVC
                                if self.nearByPeopleArr.count > 0{
                                    CMDVC?.dynamicMessage = self.nearByPeopleArr[indexPath.row]["message"] as? String ?? ""

                                    CMDVC?.roomId = self.nearByPeopleArr[indexPath.row]["roomID"] as? String ?? ""
                                    CMDVC?.receiverName = self.nearByPeopleArr[indexPath.row]["name"] as? String ?? ""
                                    CMDVC?.otherId = self.nearByPeopleArr[indexPath.row]["otherID"] as? String ?? ""
                                    CMDVC?.profileImg = self.nearByPeopleArr[indexPath.row]["image"] as? String ?? ""
                                    CMDVC?.distanceInMiles = self.nearByPeopleArr[indexPath.row]["distance_in_miles"] as? String ?? ""
                                }
                                CMDVC?.isFromCurrentChat = true
                                CMDVC?.isFromNearByPeople = true

                                
                                if let CMDVC = CMDVC {
                                    self.navigationController?.pushViewController(CMDVC, animated: true)
                                }
                            }),
                            from: self
                        )
                        }
                    }else{
                        DispatchQueue.main.async {

                        Alert.present(
                            title: AppAlertTitle.appName.rawValue,
                            message: likeUserResp?.alertMessage ?? "",
                            actions: .ok(handler: {
                            }),
                            from: self
                        )
                        }
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
    @objc func disLikeUserBtnAction(_ sender:UIButton){
        var parentCell = sender.superview

        while !(parentCell is UICollectionViewCell) {
            parentCell = parentCell?.superview
        }
        var indexPath: IndexPath? = nil
        if let cell1 = parentCell as? UICollectionViewCell {
            indexPath = nearByPeopleCV.indexPath(for: cell1)
        }
        let otherId =  nearByPeopleArr[indexPath?.row ?? 0]["userID"] as? String ?? ""
        guard let url = URL(string: kBASEURL + WSMethods.disLikeUser) else { return }

        self.likeDisLikeUserApi(otherId:otherId, url: url, likeStatus: "0",indexPath: indexPath!)
    }
    
    @objc func chanceItBtnAction(_ sender:UIButton){
        var parentCell = sender.superview

        while !(parentCell is UICollectionViewCell) {
            parentCell = parentCell?.superview
        }
        var indexPath: IndexPath? = nil
        if let cell1 = parentCell as? UICollectionViewCell {
            indexPath = nearByPeopleCV.indexPath(for: cell1)
        }
        let otherId =  nearByPeopleArr[indexPath?.row ?? 0]["userID"] as? String ?? ""
        guard let url = URL(string: kBASEURL + WSMethods.likeUser) else { return }
        let likeStatus =  nearByPeopleArr[indexPath?.row ?? 0]["likeStatus"] as? String ?? ""
        self.likeDisLikeUserApi(otherId:otherId, url: url, likeStatus:likeStatus,indexPath: indexPath!)
        
    }
    
    //Horizontal Scrolling
    @IBAction func profileBtnAction(_ sender: UIButton) {
        Navigation.init().pushCallBack(ViewControllerIdentifier.ProfileVC,StoryboardName.Settings,NearByPeopleVC(),self.storyboard!, self.navigationController!)
        
    }
//    @objc func didTap(slideShow:UIView) {
//        let fullScreenController = slideShow.presentFullScreenController(from: self)
//        // set the activity indicator for full screen controller (skipping the line will show no activity indicator)
//        fullScreenController.slideshow.activityIndicator = DefaultActivityIndicator(style: .white, color: nil)
//    }
    
}
extension NearByPeopleVC:UICollectionViewDataSource,UICollectionViewDelegate{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return nearByPeopleArr.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NearByCV", for: indexPath) as? NearByCV
        if cell == nil {
            let nib = Bundle.main.loadNibNamed("NearByCV", owner: self, options: nil)
            cell = nib?[0] as? NearByCV
        }
        cell?.userImgSlideShow.slideshowInterval = 7.0
        cell?.userImgSlideShow.pageIndicatorPosition = .init(horizontal: .center, vertical: .customTop(padding: 170))
        cell?.userImgSlideShow.contentScaleMode = UIViewContentMode.scaleAspectFill
        let pageIndicator = UIPageControl()
        pageIndicator.currentPageIndicatorTintColor = UIColor.systemPink
        pageIndicator.pageIndicatorTintColor = UIColor.lightGray

        // optional way to show activity indicator during image load (skipping the line will show no activity indicator)
        cell?.userImgSlideShow.activityIndicator = DefaultActivityIndicator()
        cell?.userImgSlideShow.delegate = self

        // can be used with other sample sources as `afNetworkingSource`, `alamofireSource` or `sdWebImageSource` or `kingfisherSource`

//        let recognizer = UITapGestureRecognizer(target: self, action: #selector(didTap(slideShow:)))
//        cell?.userImgSlideShow.addGestureRecognizer(recognizer)
        
        
        let obj =  nearByPeopleArr[indexPath.row]
        let imgArr = obj["userImages"] as? [[String:AnyHashable]] ?? [[:]]
        let interestArr = obj["interests"] as? [[String:AnyHashable]] ?? [[:]]
        let likeStatus = obj["likeStatus"] as? String ?? ""
        if likeStatus == "1"{
            cell?.chanceItBtn.setImage(UIImage(named: "interestedBtnImg"), for: .normal)
            sdWebSourceImageArr.removeAll()
            if imgArr.count > 0{
                cell?.userImgSlideShow.isHidden = false
                if imgArr.count > 1{
                    cell?.userImgSlideShow.pageIndicator = pageIndicator
                }
                for obj in imgArr{
                    let image = obj["userProfileImage"] as? String ?? ""
                    var photoStr = image
                    photoStr = photoStr.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
                    let img = SDWebImageSource(url: URL(string:photoStr)!, placeholder:UIImage(named: "nearByUserPlaceholderImg"))
                    sdWebSourceImageArr.append(img)
                }
                cell?.userImgSlideShow.setImageInputs(sdWebSourceImageArr)


            }else{
                cell?.userImgSlideShow.isHidden = true
                cell?.userImgView.image = UIImage(named:"nearByUserPlaceholderImg")
            }
            cell?.notInterestedView.isHidden = false
            //            cell?.userImgView?.roundCorners([.topRight,.topLeft], radius: 17)
            cell?.userNameAgeLbl.text = "\(obj["name"] as? String ?? "")" + ", \(obj["age"] as? String ?? ""), wants to meet!"

        }else{
            cell?.chanceItBtn.setImage(UIImage(named: "chancItABtnImg"), for: .normal)
            sdWebSourceImageArr.removeAll()

            if imgArr.count > 0{
                cell?.userImgSlideShow.isHidden = false
                if imgArr.count > 1{
                    cell?.userImgSlideShow.pageIndicator = pageIndicator
                }
                for obj in imgArr{
                    let image = obj["userProfileImage"] as? String ?? ""
                    var photoStr = image
                    photoStr = photoStr.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
            
                    let img = SDWebImageSource(url: URL(string:photoStr)!, placeholder:UIImage(named: "nearByUserPlaceholderImg"))
                    sdWebSourceImageArr.append(img)
                }
                cell?.userImgSlideShow.setImageInputs(sdWebSourceImageArr)
            }else{
                cell?.userImgSlideShow.isHidden = true
                cell?.userImgView.image = UIImage(named:"nearByUserPlaceholderImg")
            }
            cell?.notInterestedView.isHidden = true
            let userNameAge = "\(obj["name"] as? String ?? "")" + ", \(obj["age"] as? String ?? "")"
            cell?.userNameAgeLbl.text = userNameAge
            cell?.distanceLbl.text = "\(obj["distance_in_miles"] as? String ?? "")" + " | \(availableStatus)"

        }
        if interestArr.count == 1{
             
            cell?.skiingLbl.text = (interestArr[0]["interests"] as? String ?? "").trimWhitespacesAndNewlines()
            cell?.taranTinoLbl.text = ""
            cell?.readingLbl.text = ""
            cell?.writingLbl.text = ""
            cell?.gymLbl.text = ""
            cell?.taranTinoLbl.isHidden = true
            cell?.readingLbl.isHidden = true
            cell?.writingLbl.isHidden = true
            cell?.gymLbl.isHidden = true

        }else if interestArr.count == 2{
            cell?.skiingLbl.text = (interestArr[0]["interests"] as? String ?? "").trimWhitespacesAndNewlines()
            cell?.taranTinoLbl.text = (interestArr[1]["interests"] as? String ?? "").trimWhitespacesAndNewlines()
            cell?.readingLbl.text = ""
            cell?.writingLbl.text = ""
            cell?.gymLbl.text = ""
            cell?.readingLbl.isHidden = true
            cell?.writingLbl.isHidden = true
            cell?.gymLbl.isHidden = true
        }else if interestArr.count == 3{
            cell?.skiingLbl.text = (interestArr[0]["interests"] as? String ?? "").trimWhitespacesAndNewlines()
            cell?.taranTinoLbl.text = (interestArr[1]["interests"] as? String ?? "").trimWhitespacesAndNewlines()
            cell?.readingLbl.text = (interestArr[2]["interests"] as? String ?? "").trimWhitespacesAndNewlines()
            cell?.writingLbl.text = ""
            cell?.gymLbl.text = ""
            cell?.writingLbl.isHidden = true
            cell?.gymLbl.isHidden = true
        }else if interestArr.count == 4{
            cell?.skiingLbl.text = (interestArr[0]["interests"] as? String ?? "").trimWhitespacesAndNewlines()
            cell?.taranTinoLbl.text = (interestArr[1]["interests"] as? String ?? "").trimWhitespacesAndNewlines()
            cell?.readingLbl.text = (interestArr[2]["interests"] as? String ?? "").trimWhitespacesAndNewlines()
            cell?.writingLbl.text = (interestArr[3]["interests"] as? String ?? "").trimWhitespacesAndNewlines()
            cell?.gymLbl.text = ""
            cell?.gymLbl.isHidden = true
        }else if interestArr.count == 5{
            cell?.skiingLbl.text = (interestArr[0]["interests"] as? String ?? "").trimWhitespacesAndNewlines()
            cell?.taranTinoLbl.text = (interestArr[1]["interests"] as? String ?? "").trimWhitespacesAndNewlines()
            cell?.readingLbl.text = (interestArr[2]["interests"] as? String ?? "").trimWhitespacesAndNewlines()
            cell?.writingLbl.text = (interestArr[3]["interests"] as? String ?? "").trimWhitespacesAndNewlines()
            cell?.gymLbl.text = (interestArr[4]["interests"] as? String ?? "").trimWhitespacesAndNewlines()
        }
        
        cell?.chanceItBtn?.addTarget(self, action: #selector(chanceItBtnAction(_:)), for: .touchUpInside)
        cell?.disLikeBtn?.addTarget(self, action: #selector(disLikeUserBtnAction(_:)), for: .touchUpInside)

        cell?.rectCardImgView.addShadow()
        
        cell?.skiingLbl.layer.cornerRadius = 7
        cell?.skiingLbl.layer.masksToBounds = true
        cell?.skiingLbl.layer.borderColor = UIColor.systemPink.cgColor
        cell?.skiingLbl.layer.borderWidth = 1.0
        
        cell?.taranTinoLbl.layer.cornerRadius = 7
        cell?.taranTinoLbl.layer.masksToBounds = true
        cell?.taranTinoLbl.layer.borderColor = UIColor.systemPink.cgColor
        cell?.taranTinoLbl.layer.borderWidth = 1.0
        
        cell?.readingLbl.layer.cornerRadius = 7
        cell?.readingLbl.layer.masksToBounds = true
        cell?.readingLbl.layer.borderColor = UIColor.systemPink.cgColor
        cell?.readingLbl.layer.borderWidth = 1.0
        
        cell?.writingLbl.layer.cornerRadius = 7
        cell?.writingLbl.layer.masksToBounds = true
        cell?.writingLbl.layer.borderColor = UIColor.systemPink.cgColor
        cell?.writingLbl.layer.borderWidth = 1.0
        
        cell?.gymLbl.layer.cornerRadius = 7
        cell?.gymLbl.layer.masksToBounds = true
        cell?.gymLbl.layer.borderColor = UIColor.systemPink.cgColor
        cell?.gymLbl.layer.borderWidth = 1.0
        return cell!
    }
    
    
}
// MARK:- UICollectionViewDelegate method(s)

extension NearByPeopleVC:UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 16)
        
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        return CGSize(width: UIScreen.main.bounds.size.width * 0.83, height: UIScreen.main.bounds.size.height * 0.57)
        
    }
    
}

extension UIView {
    
    func addShadow() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowOpacity = 0.5
        layer.shadowRadius = 5
        clipsToBounds = false
    }
}
extension NearByPeopleVC: ImageSlideshowDelegate {
    func imageSlideshow(_ imageSlideshow: ImageSlideshow, didChangeCurrentPageTo page: Int) {
        print("current page:", page)
    }
}
extension NearByPeopleVC:GMSMapViewDelegate{

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
