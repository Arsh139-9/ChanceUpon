//
//  ProfileVC.swift
//  ChanceUpon
//
//  Created by Dharmani Apps mini on 10/3/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import SDWebImage
import SVProgressHUD

class ProfileVC: UIViewController {
    let rest = RestManager()
    @IBOutlet weak var profileCV: UICollectionView!
    @IBOutlet weak var skiingLbl: UILabel!
    
    @IBOutlet weak var taranTinoLbl: UILabel!
    
    @IBOutlet weak var readingLbl: UILabel!
    
    @IBOutlet weak var writingLbl: UILabel!
    
    @IBOutlet weak var gymLbl: UILabel!
    
    @IBOutlet weak var userNameLbl: UILabel!
    
    @IBOutlet weak var availableNowLbl: UILabel!
    var onlineStatus = ""
    var closeAccount = ""

    var lastTimeOnline = ""
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var editInfoStackView: UIStackView!
    
    lazy var collectionViewFlowLayout = UICollectionViewFlowLayout()
    var currentPage = 0
    var interestArr = [String]()
    var userProfileDetail = UserProfileDetailData<AnyHashable>(dict:[:])
    var otherUserId = String()
    var appDel = AppDelegate()
    var availableStatus = String()

    override func viewDidLoad() {
        super.viewDidLoad()
//        skiingLbl.layer.borderColor = UIColor.white.cgColor
//        taranTinoLbl.layer.borderColor = UIColor.white.cgColor
//        readingLbl.layer.borderColor = UIColor.white.cgColor
//        writingLbl.layer.borderColor = UIColor.white.cgColor
//        gymLbl.layer.borderColor = UIColor.white.cgColor
        collectionViewFlowLayout.scrollDirection = .horizontal
        profileCV.collectionViewLayout = collectionViewFlowLayout
        profileCV.isPagingEnabled = false
        addSwipe(view: view)
   
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if otherUserId == ""{
            editInfoStackView.isHidden = false
        }else{
            editInfoStackView.isHidden = true
        }
        getUserDetailApi()
    }
    
    open func getUserDetailApi(){
        guard let url = URL(string: kBASEURL + WSMethods.getUserDetail) else { return }
        
        rest.requestHttpHeaders.add(value: "application/json", forKey: "Content-Type")
        rest.httpBodyParameters.add(value: getSAppDefault(key: "AuthToken") as? String ?? "", forKey: "authToken")

        if otherUserId == ""{
        rest.httpBodyParameters.add(value: getSAppDefault(key: "UserId") as? String ?? "", forKey: "userID")
        }else{
            rest.httpBodyParameters.add(value:otherUserId, forKey: "userID")
        }
        
        
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
                self.userProfileDetail =   UserProfileDetailData.init(dict: jsonResult ?? [:])
                if self.userProfileDetail?.status == "1"{
                    let userImageArr = self.userProfileDetail?.userDetailEntity.userImagesArr
                    if self.otherUserId == ""{

                    if userImageArr!.count > 0
                    {
                let photoStr =  self.userProfileDetail?.userDetailEntity.userImagesArr[0].image ?? ""
                   setAppDefaults(photoStr, key: "UserProfileImage")
                    }else{
                        setAppDefaults("", key: "UserProfileImage")
                    }
                    }
                    DispatchQueue.main.async {
                        self.interestArrayUpdateFunc()
                        self.profileCV.reloadData()
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
    
    
    func getMinutesDifferenceFromTwoDates(start: Date, end: Date) -> Int
       {

           let diff = Int(end.timeIntervalSince1970 - start.timeIntervalSince1970)

           let hours = diff / 3600
           let minutes = (diff - hours * 3600) / 60
           return minutes
       }
    
    open func interestArrayUpdateFunc(){
        self.userNameLbl.text = "\(self.userProfileDetail?.userDetailEntity.name ?? ""), \(self.userProfileDetail?.userDetailEntity.age ?? "")"
        closeAccount = self.userProfileDetail?.userDetailEntity.closeAccount ?? ""
        onlineStatus = self.userProfileDetail?.userDetailEntity.online ?? ""
        lastTimeOnline = self.userProfileDetail?.userDetailEntity.lastTime ?? ""

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
        
        self.availableNowLbl.text = availableStatus
        let userInterestArr = userProfileDetail?.userDetailEntity.userInterestsArr as [AnyObject]?
        self.interestArr.removeAll()
        for i in 0..<userInterestArr!.count {
            let interest = self.userProfileDetail?.userDetailEntity.userInterestsArr[i].interests ?? ""
            self.interestArr.append(interest)
            
        }
       
       if interestArr.count == 1{
       skiingLbl.text = interestArr[0].trimWhitespacesAndNewlines()
            taranTinoLbl.text = ""
            readingLbl.text = ""
            writingLbl.text = ""
            gymLbl.text = ""
        skiingLbl.layer.borderColor = UIColor.systemPink.cgColor
        taranTinoLbl.layer.borderColor = UIColor.white.cgColor
        readingLbl.layer.borderColor = UIColor.white.cgColor
        writingLbl.layer.borderColor = UIColor.white.cgColor
        gymLbl.layer.borderColor = UIColor.white.cgColor

        }else if interestArr.count == 2{
            skiingLbl.text = interestArr[0].trimWhitespacesAndNewlines()
            taranTinoLbl.text = interestArr[1].trimWhitespacesAndNewlines()
            readingLbl.text = ""
            writingLbl.text = ""
            gymLbl.text = ""
            skiingLbl.layer.borderColor = UIColor.systemPink.cgColor
            taranTinoLbl.layer.borderColor = UIColor.systemPink.cgColor
            readingLbl.layer.borderColor = UIColor.white.cgColor
            writingLbl.layer.borderColor = UIColor.white.cgColor
            gymLbl.layer.borderColor = UIColor.white.cgColor
        }else if interestArr.count == 3{
            skiingLbl.text = interestArr[0].trimWhitespacesAndNewlines()
            taranTinoLbl.text = interestArr[1].trimWhitespacesAndNewlines()
            readingLbl.text = interestArr[2].trimWhitespacesAndNewlines()
            writingLbl.text = ""
            gymLbl.text = ""
            skiingLbl.layer.borderColor = UIColor.systemPink.cgColor
            taranTinoLbl.layer.borderColor = UIColor.systemPink.cgColor
            readingLbl.layer.borderColor = UIColor.systemPink.cgColor
            writingLbl.layer.borderColor = UIColor.white.cgColor
            gymLbl.layer.borderColor = UIColor.white.cgColor
        }else if interestArr.count == 4{
            skiingLbl.text = interestArr[0].trimWhitespacesAndNewlines()
            taranTinoLbl.text = interestArr[1].trimWhitespacesAndNewlines()
            readingLbl.text = interestArr[2].trimWhitespacesAndNewlines()
            writingLbl.text = interestArr[3].trimWhitespacesAndNewlines()
            gymLbl.text = ""
            skiingLbl.layer.borderColor = UIColor.systemPink.cgColor
            taranTinoLbl.layer.borderColor = UIColor.systemPink.cgColor
            readingLbl.layer.borderColor = UIColor.systemPink.cgColor
            writingLbl.layer.borderColor = UIColor.systemPink.cgColor
            gymLbl.layer.borderColor = UIColor.white.cgColor
        }else if interestArr.count == 5{
            skiingLbl.text = interestArr[0].trimWhitespacesAndNewlines()
            taranTinoLbl.text = interestArr[1].trimWhitespacesAndNewlines()
            readingLbl.text = interestArr[2].trimWhitespacesAndNewlines()
            writingLbl.text = interestArr[3].trimWhitespacesAndNewlines()
            gymLbl.text = interestArr[4].trimWhitespacesAndNewlines()
            skiingLbl.layer.borderColor = UIColor.systemPink.cgColor
            taranTinoLbl.layer.borderColor = UIColor.systemPink.cgColor
            readingLbl.layer.borderColor = UIColor.systemPink.cgColor
            writingLbl.layer.borderColor = UIColor.systemPink.cgColor
            gymLbl.layer.borderColor = UIColor.systemPink.cgColor
        }
//        if skiingLbl.text != ""{
//            skiingLbl.isHidden = false
//
//        }else{
//            skiingLbl.isHidden = true
//        }
//
//        if taranTinoLbl.text != ""{
//            taranTinoLbl.isHidden = false
//
//
//        }else{
//            taranTinoLbl.isHidden = true
//
//        }
//        if readingLbl.text != ""{
//            readingLbl.isHidden = false
//
//
//        }else{
//            readingLbl.isHidden = true
//
//        }
//        if writingLbl.text != ""{
//            writingLbl.isHidden = false
//
//
//        }else{
//            writingLbl.isHidden = true
//
//        }
//        if gymLbl.text != ""{
//            gymLbl.isHidden = false
//
//
//        }else{
//            gymLbl.isHidden = true
//
//        }
    }
    
    @IBAction func backBtnAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    
    //Set timer to for horizontal scrolling
    func startTimer() {
        
        _ =  Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.scrollToNextCell), userInfo: nil, repeats: true)
    }
    //Page Control Action Over Collection View
    @IBAction func pageControlAction(_ sender: Any) {
        scrollToNextCell()
        
        
    }
    //Horizontal Scrolling
    @objc func scrollToNextCell(){
        
        //get cell size
        let cellSize = view.frame.size
        
        //get current content Offset of the Collection view
        if profileCV != nil{
            let contentOffset = profileCV.contentOffset
            
            if profileCV.contentSize.width <= profileCV.contentOffset.x + cellSize.width
            {
                let r = CGRect(x: 0, y: contentOffset.y, width: cellSize.width, height: cellSize.height)
                profileCV.scrollRectToVisible(r, animated: true)
                
            } else {
                let r = CGRect(x: contentOffset.x + cellSize.width, y: contentOffset.y, width: cellSize.width, height: cellSize.height)
                profileCV.scrollRectToVisible(r, animated: true);
            }
        }
        
    }
    @IBAction func editInfoBtnAction(_ sender: Any) {
        if otherUserId == ""{
        let storyBoard = UIStoryboard(name: StoryboardName.Settings, bundle: nil)
        
        let CMDVC = storyBoard.instantiateViewController(withIdentifier: ViewControllerIdentifier.ProfileSettingsVC) as? ProfileSettingsVC
        CMDVC?.userProfileDetail = userProfileDetail
        CMDVC?.interestArr = interestArr
        if let CMDVC = CMDVC {
            navigationController?.pushViewController(CMDVC, animated: true)
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
    
    
    
}
extension ProfileVC:UICollectionViewDataSource,UICollectionViewDelegate{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        pageControl.numberOfPages = userProfileDetail?.userDetailEntity.userImagesArr.count ?? 0
        pageControl.isHidden = !(userProfileDetail?.userDetailEntity.userImagesArr.count ?? 0 > 1)
        if userProfileDetail?.userDetailEntity.userImagesArr.count ?? 0 == 0{
            return 1
        }else{
            return userProfileDetail?.userDetailEntity.userImagesArr.count ?? 0

        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = profileCV.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? ProfileCVCell
        if userProfileDetail?.userDetailEntity.userImagesArr.count ?? 0 != 0{
        var photoStr = userProfileDetail?.userDetailEntity.userImagesArr[indexPath.item].image ?? ""

        photoStr = photoStr.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
      
            cell?.userProfilePicImgView.sd_setImage(with: URL(string: photoStr), placeholderImage:UIImage(named: "nearByUserPlaceholderImg"))
        }else{
            cell?.userProfilePicImgView.image = UIImage(named:"nearByUserPlaceholderImg")
        }
       
           
        
        
        return cell!
    }
    
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        pageControl?.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        
        pageControl?.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageWidth = scrollView.frame.width
        self.currentPage = Int((scrollView.contentOffset.x + pageWidth / 2) / pageWidth)
        self.pageControl.currentPage = self.currentPage
    }
}
// MARK:- UICollectionViewDelegate method(s)

extension ProfileVC:UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
    }
 
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        return CGSize(width: UIScreen.main.bounds.size.width * 0.99, height: UIScreen.main.bounds.size.height * 0.53)
        
    }
    
}

