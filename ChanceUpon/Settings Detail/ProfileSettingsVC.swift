//
//  ProfileSettingsVC.swift
//  ChanceUpon
//
//  Created by Dharmani Apps mini on 9/14/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import SDWebImage
import Alamofire
import SVProgressHUD

class ProfileSettingsVC: UIViewController,UINavigationControllerDelegate,UIImagePickerControllerDelegate{
    let rest = RestManager()
    lazy var globalTag = Int()
    var interestArr = [String]()
    @IBOutlet weak var firstAddImgBtn: UIButton!
    
    @IBOutlet weak var secondAddImgBtn: UIButton!
    
    @IBOutlet weak var thirdAddImgBtn: UIButton!
    
    @IBOutlet weak var fourthAddImgBtn: UIButton!
    
    @IBOutlet weak var fifthAddImgBtn: UIButton!
    
    @IBOutlet weak var firstImgRemoveBtn: UIButton!
    @IBOutlet weak var secImgRemoveBtn: UIButton!
    @IBOutlet weak var thirdImgRemoveBtn: UIButton!
    @IBOutlet weak var fourthImgRemoveBtn: UIButton!
    @IBOutlet weak var fifthImgRemoveBtn: UIButton!
    
    @IBOutlet weak var userNameTF: UITextField!
    
    @IBOutlet weak var dobTF: UITextField!
    
    @IBOutlet weak var genderTF: UITextField!
    
    @IBOutlet weak var sexTF: UITextField!
    
    @IBOutlet weak var showMeTF: UITextField!
    
    @IBOutlet weak var userInterestsTF: UITextField!
    
    @IBOutlet weak var occupationTF: UITextField!
    
    var userInterestStr = String()
    var userProfileDetail = UserProfileDetailData<AnyHashable>(dict:[:])
    var imgArray = [Data]()
    var genderArray = [String]()
    var sexArray = [String]()
    var showMeArray = [String]()
    var sexStatus = String()
    var showMStatus = String()
    var genderIStatus = String()
    var fullUserName = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        genderArray = ["Male","Female","Other"]
        sexArray = ["Straight","Gay","Lesbian","Bisexual","Asexual","Demisexual","Pansexual","Queer","Questioning"]
        showMeArray = ["Men","Women","Both"]
        removeAppDefaults(key:"AddedInterest")
        removeAppDefaults(key:"D.O.B")
        removeAppDefaults(key:"Name")
        removeAppDefaults(key:"Gender")
        removeAppDefaults(key:"GenderCategory")
        removeAppDefaults(key:"ShowMe")
        removeAppDefaults(key:"OccupationPS")

        
        fullUserName = "\(userProfileDetail?.userDetailEntity.name ?? "")"
        if let first = fullUserName.components(separatedBy: " ").first {
            // Do something with the first component.
            userNameTF.text = first
        }
        dobTF.text = "\(userProfileDetail?.userDetailEntity.DOB ?? "")"
        let genderStatus = "\(userProfileDetail?.userDetailEntity.gender ?? "")"
        if genderStatus == "0"{
            genderTF.text = "Other"
        }else if genderStatus == "1"{
            genderTF.text = "Male"
        }else{
            genderTF.text = "Female"
        }
        let genderCatStatus = "\(userProfileDetail?.userDetailEntity.genderCat ?? "")"
        if genderCatStatus == "0"{
            sexTF.text = "Straight"
        }else if genderCatStatus == "1"{
            sexTF.text = "Gay"
        }else if genderCatStatus == "2"{
            sexTF.text = "Lesbian"
        }else if genderCatStatus == "3"{
            sexTF.text = "Bisexual"
        }else if genderCatStatus == "4"{
            sexTF.text = "Asexual"
        }else if genderCatStatus == "5"{
            sexTF.text = "Demisexual"
        }else if genderCatStatus == "6"{
            sexTF.text = "Pansexual"
        }else if genderCatStatus == "7"{
            sexTF.text = "Queer"
        }else{
            sexTF.text = "Questioning"
        }
        let showMeStatus = "\(userProfileDetail?.userDetailEntity.showMe ?? "")"
        if showMeStatus == "0"{
            showMeTF.text = "Both"
        }else if showMeStatus == "1"{
            showMeTF.text = "Men"
        }else{
            showMeTF.text = "Women"
        }
        
        occupationTF.text = "\(userProfileDetail?.userDetailEntity.occupation ?? "")"

        let imgArr = userProfileDetail?.userDetailEntity.userImagesArr
        if imgArr?.count == 1{
            var photoStr = userProfileDetail?.userDetailEntity.userImagesArr[0].image ?? ""
            photoStr = photoStr.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
            if photoStr != ""{
                firstAddImgBtn.sd_setImage(with: URL(string: photoStr), for: .normal, placeholderImage:nil)
            }
            self.firstImgRemoveBtn.isHidden = false
            self.secImgRemoveBtn.isHidden = true
            self.thirdImgRemoveBtn.isHidden = true
            self.fourthImgRemoveBtn.isHidden = true
            self.fifthImgRemoveBtn.isHidden = true
            
        }else if imgArr?.count == 2{
            var photoStr = userProfileDetail?.userDetailEntity.userImagesArr[0].image ?? ""
            photoStr = photoStr.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
            if photoStr != ""{
                firstAddImgBtn.sd_setImage(with: URL(string: photoStr), for: .normal, placeholderImage:nil)
            }
            var sPhotoStr = userProfileDetail?.userDetailEntity.userImagesArr[1].image ?? ""
            sPhotoStr = sPhotoStr.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
            if sPhotoStr != ""{
                secondAddImgBtn.sd_setImage(with: URL(string: sPhotoStr), for: .normal, placeholderImage:nil)
            }
            self.firstImgRemoveBtn.isHidden = false
            self.secImgRemoveBtn.isHidden = false
            self.thirdImgRemoveBtn.isHidden = true
            self.fourthImgRemoveBtn.isHidden = true
            self.fifthImgRemoveBtn.isHidden = true
            
            
        }else if imgArr?.count == 3{
            var photoStr = userProfileDetail?.userDetailEntity.userImagesArr[0].image ?? ""
            photoStr = photoStr.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
            if photoStr != ""{
                firstAddImgBtn.sd_setImage(with: URL(string: photoStr), for: .normal, placeholderImage:nil)
            }
            var sPhotoStr = userProfileDetail?.userDetailEntity.userImagesArr[1].image ?? ""
            sPhotoStr = sPhotoStr.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
            if sPhotoStr != ""{
                secondAddImgBtn.sd_setImage(with: URL(string: sPhotoStr), for: .normal, placeholderImage:nil)
            }
            var thirdPhotoStr = userProfileDetail?.userDetailEntity.userImagesArr[2].image ?? ""
            thirdPhotoStr = thirdPhotoStr.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
            if thirdPhotoStr != ""{
                thirdAddImgBtn.sd_setImage(with: URL(string: thirdPhotoStr), for: .normal, placeholderImage:nil)
            }
            
            self.firstImgRemoveBtn.isHidden = false
            self.secImgRemoveBtn.isHidden = false
            self.thirdImgRemoveBtn.isHidden = false
            self.fourthImgRemoveBtn.isHidden = true
            self.fifthImgRemoveBtn.isHidden = true
            
        }else if imgArr?.count == 4{
            var photoStr = userProfileDetail?.userDetailEntity.userImagesArr[0].image ?? ""
            photoStr = photoStr.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
            if photoStr != ""{
                firstAddImgBtn.sd_setImage(with: URL(string: photoStr), for: .normal, placeholderImage:nil)
            }
            var sPhotoStr = userProfileDetail?.userDetailEntity.userImagesArr[1].image ?? ""
            sPhotoStr = sPhotoStr.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
            if sPhotoStr != ""{
                secondAddImgBtn.sd_setImage(with: URL(string: sPhotoStr), for: .normal, placeholderImage:nil)
            }
            var thirdPhotoStr = userProfileDetail?.userDetailEntity.userImagesArr[2].image ?? ""
            thirdPhotoStr = thirdPhotoStr.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
            if thirdPhotoStr != ""{
                thirdAddImgBtn.sd_setImage(with: URL(string: thirdPhotoStr), for: .normal, placeholderImage:nil)
            }
            var fourthPhotoStr = userProfileDetail?.userDetailEntity.userImagesArr[3].image ?? ""
            fourthPhotoStr = fourthPhotoStr.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
            if fourthPhotoStr != ""{
                fourthAddImgBtn.sd_setImage(with: URL(string: fourthPhotoStr), for: .normal, placeholderImage:nil)
            }
            self.firstImgRemoveBtn.isHidden = false
            self.secImgRemoveBtn.isHidden = false
            self.thirdImgRemoveBtn.isHidden = false
            self.fourthImgRemoveBtn.isHidden = false
            self.fifthImgRemoveBtn.isHidden = true
            
            
        }else if imgArr?.count == 5{
            var photoStr = userProfileDetail?.userDetailEntity.userImagesArr[0].image ?? ""
            photoStr = photoStr.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
            if photoStr != ""{
                firstAddImgBtn.sd_setImage(with: URL(string: photoStr), for: .normal, placeholderImage:nil)
            }
            var sPhotoStr = userProfileDetail?.userDetailEntity.userImagesArr[1].image ?? ""
            sPhotoStr = sPhotoStr.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
            if sPhotoStr != ""{
                secondAddImgBtn.sd_setImage(with: URL(string: sPhotoStr), for: .normal, placeholderImage:nil)
            }
            var thirdPhotoStr = userProfileDetail?.userDetailEntity.userImagesArr[2].image ?? ""
            thirdPhotoStr = thirdPhotoStr.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
            if thirdPhotoStr != ""{
                thirdAddImgBtn.sd_setImage(with: URL(string: thirdPhotoStr), for: .normal, placeholderImage:nil)
            }
            var fourthPhotoStr = userProfileDetail?.userDetailEntity.userImagesArr[3].image ?? ""
            fourthPhotoStr = fourthPhotoStr.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
            if fourthPhotoStr != ""{
                fourthAddImgBtn.sd_setImage(with: URL(string: fourthPhotoStr), for: .normal, placeholderImage:nil)
            }
            var fifthPhotoStr = userProfileDetail?.userDetailEntity.userImagesArr[4].image ?? ""
            fifthPhotoStr = fifthPhotoStr.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
            if fifthPhotoStr != ""{
                fifthAddImgBtn.sd_setImage(with: URL(string: fifthPhotoStr), for: .normal, placeholderImage:nil)
            }
            self.firstImgRemoveBtn.isHidden = false
            self.secImgRemoveBtn.isHidden = false
            self.thirdImgRemoveBtn.isHidden = false
            self.fourthImgRemoveBtn.isHidden = false
            self.fifthImgRemoveBtn.isHidden = false
            
        }else{
            self.firstImgRemoveBtn.isHidden = true
            self.secImgRemoveBtn.isHidden = true
            self.thirdImgRemoveBtn.isHidden = true
            self.fourthImgRemoveBtn.isHidden = true
            self.fifthImgRemoveBtn.isHidden = true
        }
        
        
        // Do any additional setup after loading the view.
        addSwipe(view: view)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        fullUserName = getSAppDefault(key: "Name") as? String ?? ""
        if fullUserName != ""{
            if let first = fullUserName.components(separatedBy: " ").first {
                // Do something with the first component.
                userNameTF.text = first
            }
        }
        let dateOfBirth = getSAppDefault(key: "D.O.B") as? String ?? ""
        if dateOfBirth != ""{
            dobTF.text = dateOfBirth
        }
        let gender = getSAppDefault(key: "Gender") as? String ?? ""
        if gender != ""{
            genderTF.text = gender
        }
        let genderCategory = getSAppDefault(key: "GenderCategory") as? String ?? ""
        if genderCategory != ""{
            sexTF.text = genderCategory
        }
        let showMe = getSAppDefault(key: "ShowMe") as? String ?? ""
        if showMe != ""{
            showMeTF.text = showMe
        }
        let occupationPS = getSAppDefault(key: "OccupationPS") as? String ?? ""
        if occupationPS != ""{
            occupationTF.text = occupationPS
        }
        
        let arr  = getSAppDefault(key: "AddedInterest") as? [String] ?? []
        if arr.count != 0{
            interestArr = arr
            for i in 0..<self.interestArr.count {
                if self.interestArr[i] == "Add interest..."{
                    self.interestArr.remove(at: i)
                }
            }
        }
        
        
        
        if interestArr.count == 0{
            userInterestStr = ""
        }
        else if interestArr.count == 1{
            userInterestStr = "\(interestArr[0].trimWhitespacesAndNewlines())"
        }else if interestArr.count == 2{
            userInterestStr = "\(interestArr[0].trimWhitespacesAndNewlines()),\(interestArr[1].trimWhitespacesAndNewlines())"
        }else if interestArr.count == 3{
            userInterestStr =  "\(interestArr[0].trimWhitespacesAndNewlines()),\(interestArr[1].trimWhitespacesAndNewlines()),\(interestArr[2].trimWhitespacesAndNewlines())"
        }else if interestArr.count == 4{
            userInterestStr = "\(interestArr[0].trimWhitespacesAndNewlines()),\(interestArr[1].trimWhitespacesAndNewlines()),\(interestArr[2].trimWhitespacesAndNewlines()),\(interestArr[3].trimWhitespacesAndNewlines())"
        }else if interestArr.count == 5{
            userInterestStr = "\(interestArr[0].trimWhitespacesAndNewlines()),\(interestArr[1].trimWhitespacesAndNewlines()),\(interestArr[2].trimWhitespacesAndNewlines()),\(interestArr[3].trimWhitespacesAndNewlines()),\(interestArr[4].trimWhitespacesAndNewlines())"
        }
        let userFInterestStr = userInterestStr.trimWhitespacesAndNewlines()
        userInterestsTF.text = userFInterestStr
    }
    
    @IBAction func backBtnAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    open func editProfileApi() {
        
        let urlStr = kBASEURL + WSMethods.editProfile
        let userId  = getSAppDefault(key: "UserId") as? String ?? ""
       
        if genderTF.text == "Other"{
            genderIStatus = "0"
        }else if genderTF.text == "Male"{
            genderIStatus = "1"
        }else{
            genderIStatus = "2"
        }
        
        
        if sexTF.text == "Straight"{
            sexStatus = "0"
            
        }else if sexTF.text == "Gay"{
            sexStatus = "1"

        }else if sexTF.text == "Lesbian"{
            sexStatus = "2"
        }else if sexTF.text == "Bisexual"{
            sexStatus = "3"
        }else if sexTF.text == "Asexual"{
            sexStatus = "4"
        }else if sexTF.text == "Demisexual"{
            sexStatus = "5"
        }else if sexTF.text == "Pansexual"{
            sexStatus = "6"
        }else if sexTF.text == "Queer"{
            sexStatus = "7"
        }else{
            sexStatus = "8"
        }
       
        if showMeTF.text == "Both"{
            showMStatus = "0"
        }else if showMeTF.text == "Men"{
            showMStatus = "1"
        }else{
            showMStatus = "2"

        }
        
        
        
        var param: [AnyHashable : Any]?
        param = ["DOB":dobTF.text ?? "",
                 "interest":interestArr,"userID":userId,"name": userNameTF.text ?? "" ,"gender":genderIStatus,"genderCategory":sexStatus,"showMe":showMStatus,"occupation":occupationTF.text ?? ""]
    
        let firstBtnImage = firstAddImgBtn.image(for: .normal)
        let secondBtnImage = secondAddImgBtn.image(for: .normal)
        let thirdBtnImage = thirdAddImgBtn.image(for: .normal)
        let fourthBtnImage = fourthAddImgBtn.image(for: .normal)
        let fifthBtnImage = fifthAddImgBtn.image(for: .normal)
        let btnImgArr = [firstBtnImage,secondBtnImage,thirdBtnImage,fourthBtnImage,fifthBtnImage]
        let defaultImage = UIImage(named: "addBtnImage.png")
        imgArray.removeAll()
        for obj in btnImgArr{
            if obj != nil{
            if obj?.pngData() != defaultImage?.pngData(){
                let data:Data = obj!.jpegData(compressionQuality: 0.3)!
                imgArray.append(data)
            }
            }
        }
    
        
        self.requestWith(endUrl: urlStr , parameters: param!)
      
        
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
          
            
            for i in 0..<self.imgArray.count{
                let imageData1 = self.imgArray[i]
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
                let signUpStepData =  LogOutData(dict: respDict)
                if signUpStepData?.status == "1"{
                    self.navigationController?.popViewController(animated: true)
                }else{
                    
                }
            }else{
                
            }
            
            
        }
        
        
        
    }
    
    
    
    
    
    @IBAction func saveEditProfileChangesBtnAction(_ sender: Any) {
        editProfileApi()
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
    
    @IBAction func dateOfBirthBtnAction(_ sender: UIButton) {
        if sender.tag == 1{
            let storyBoard = UIStoryboard(name: StoryboardName.Settings, bundle: nil)
            let CMDVC = storyBoard.instantiateViewController(withIdentifier: ViewControllerIdentifier.SelectSettingsVC) as? SelectSettingsVC
            
            CMDVC?.dynamicLblStr = "Name"
            CMDVC?.dynamicBtnStr = ""
            CMDVC?.dynamicTFStr = userProfileDetail?.userDetailEntity.name ?? ""
            
            if let CMDVC = CMDVC {
                navigationController?.pushViewController(CMDVC, animated: true)
            }
        }else if sender.tag == 2{
            let storyBoard = UIStoryboard(name: StoryboardName.Settings, bundle: nil)
            let CMDVC = storyBoard.instantiateViewController(withIdentifier: ViewControllerIdentifier.SelectSettingsVC) as? SelectSettingsVC
            
            CMDVC?.dynamicLblStr = "Date of birth"
            CMDVC?.dynamicBtnStr = "Edit date of birth"
            CMDVC?.dynamicTFStr = userProfileDetail?.userDetailEntity.DOB ?? ""
            
            if let CMDVC = CMDVC {
                navigationController?.pushViewController(CMDVC, animated: true)
            }
        }else if sender.tag == 3{
            let storyBoard = UIStoryboard(name: StoryboardName.Settings, bundle: nil)
            let CMDVC = storyBoard.instantiateViewController(withIdentifier: ViewControllerIdentifier.SelectSettingsVC) as? SelectSettingsVC
            
            CMDVC?.dynamicLblStr = "Gender"
            CMDVC?.dynamicBtnStr = ""
            CMDVC?.dynamicTFStr = genderTF.text ?? ""
            CMDVC?.pickerArray = genderArray
            
            if let CMDVC = CMDVC {
                navigationController?.pushViewController(CMDVC, animated: true)
            }
        }else if sender.tag == 4{
            let storyBoard = UIStoryboard(name: StoryboardName.Settings, bundle: nil)
            let CMDVC = storyBoard.instantiateViewController(withIdentifier: ViewControllerIdentifier.SelectSettingsVC) as? SelectSettingsVC
            
            CMDVC?.dynamicLblStr = "Gender Category"
            CMDVC?.dynamicBtnStr = ""
            CMDVC?.dynamicTFStr = sexTF.text ?? ""
            CMDVC?.pickerArray = sexArray
            
            if let CMDVC = CMDVC {
                navigationController?.pushViewController(CMDVC, animated: true)
            }
        }else if sender.tag == 5{
            let storyBoard = UIStoryboard(name: StoryboardName.Settings, bundle: nil)
            let CMDVC = storyBoard.instantiateViewController(withIdentifier: ViewControllerIdentifier.SelectSettingsVC) as? SelectSettingsVC
            
            CMDVC?.dynamicLblStr = "Show Me"
            CMDVC?.dynamicBtnStr = ""
            CMDVC?.dynamicTFStr = showMeTF.text ?? ""
            CMDVC?.pickerArray = showMeArray
            
            if let CMDVC = CMDVC {
                navigationController?.pushViewController(CMDVC, animated: true)
            }
        }else{
            let storyBoard = UIStoryboard(name: StoryboardName.Settings, bundle: nil)
            let CMDVC = storyBoard.instantiateViewController(withIdentifier: ViewControllerIdentifier.SelectSettingsVC) as? SelectSettingsVC
            
            CMDVC?.dynamicLblStr = "Occupation"
            CMDVC?.dynamicBtnStr = ""
            CMDVC?.dynamicTFStr = occupationTF.text ?? ""
            
            if let CMDVC = CMDVC {
                navigationController?.pushViewController(CMDVC, animated: true)
            }
        }
     
    }
    
    @IBAction func interestBtnAction(_ sender: UIButton) {
        let storyBoard = UIStoryboard(name: StoryboardName.Settings, bundle: nil)
        
        let CMDVC = storyBoard.instantiateViewController(withIdentifier: ViewControllerIdentifier.InterestVC) as? InterestVC
        CMDVC?.listArrr = interestArr
        if let CMDVC = CMDVC {
            navigationController?.pushViewController(CMDVC, animated: true)
        }
        
    }
    @IBAction func removeSelectedImageBtnAction(_ sender: UIButton) {
        if sender.tag == 0{
            firstAddImgBtn.setImage(UIImage(named: "addBtnImage"), for: .normal)
            firstImgRemoveBtn.isHidden = true
            
        }else if sender.tag == 1{
            secondAddImgBtn.setImage(UIImage(named: "addBtnImage"), for: .normal)
            secImgRemoveBtn.isHidden = true
            
        }else if sender.tag == 2{
            thirdAddImgBtn.setImage(UIImage(named: "addBtnImage"), for: .normal)
            thirdImgRemoveBtn.isHidden = true
            
        }else if sender.tag == 3{
            fourthAddImgBtn.setImage(UIImage(named: "addBtnImage"), for: .normal)
            fourthImgRemoveBtn.isHidden = true
            
        }else if sender.tag == 4{
            fifthAddImgBtn.setImage(UIImage(named: "addBtnImage"), for: .normal)
            fifthImgRemoveBtn.isHidden = true
            
        }
    }
    
    
    
    @IBAction func addImageBtnAction(_ sender: UIButton) {
        globalTag = sender.tag
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            
            // Cancel button tappped do nothing.
            actionSheet.dismiss(animated: true)
            
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { action in
            
            // take photo button tapped.
            self.takePhoto()
            
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { action in
            
            // choose photo button tapped.
            self.choosePhoto()
            
        }))
        
        
        if UI_USER_INTERFACE_IDIOM() == .pad {
            actionSheet.modalPresentationStyle = .popover
            let popPresenter = actionSheet.popoverPresentationController
            let directions = UIPopoverArrowDirection(rawValue: 0)
            actionSheet.popoverPresentationController?.permittedArrowDirections = directions
            
            popPresenter?.sourceView = view
            popPresenter?.sourceRect = CGRect(x: view.bounds.size.width / 2.0, y: view.bounds.size.height / 2.0, width: 1.0, height: 1.0) // You can set position of popover
            present(actionSheet, animated: true)
        } else {
            present(actionSheet, animated: true)
        }
        
    }
    open func takePhoto() {
        if !UIImagePickerController.isSourceTypeAvailable(.camera) {
            let alert = UIAlertController(
                title: "Error",
                message: "Device has no camera",
                preferredStyle: .alert)
            
            let cancel = UIAlertAction(
                title: "OK",
                style: .default,
                handler: { action in
                    alert.dismiss(animated: true)
                })
            alert.addAction(cancel)
            present(alert, animated: true)
        } else {
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.allowsEditing = true
            picker.sourceType = .camera
            present(picker, animated: true)
        }
    }
    open func choosePhoto() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        present(picker, animated: true)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let chosenImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
    
        if globalTag == 0{
            firstAddImgBtn.setImage(chosenImage, for: .normal)
            let firstBtnImage = firstAddImgBtn.image(for: .normal)
            let defaultImage = UIImage(named: "addBtnImage.png")
            if firstBtnImage?.pngData() != defaultImage?.pngData(){
                firstImgRemoveBtn.isHidden = false
            }else{
                firstImgRemoveBtn.isHidden = true
            }
        }else if globalTag == 1{
            secondAddImgBtn.setImage(chosenImage, for: .normal)
            let firstBtnImage = secondAddImgBtn.image(for: .normal)
            let defaultImage = UIImage(named: "addBtnImage.png")
            if firstBtnImage?.pngData() != defaultImage?.pngData(){
                secImgRemoveBtn.isHidden = false
            }else{
                secImgRemoveBtn.isHidden = true
            }
        }else if globalTag == 2{
            thirdAddImgBtn.setImage(chosenImage, for: .normal)
            let firstBtnImage = thirdAddImgBtn.image(for: .normal)
            let defaultImage = UIImage(named: "addBtnImage.png")
            if firstBtnImage?.pngData() != defaultImage?.pngData(){
                thirdImgRemoveBtn.isHidden = false
            }else{
                thirdImgRemoveBtn.isHidden = true
            }
        }else if globalTag == 3{
            fourthAddImgBtn.setImage(chosenImage, for: .normal)
            let firstBtnImage = fourthAddImgBtn.image(for: .normal)
            let defaultImage = UIImage(named: "addBtnImage.png")
            if firstBtnImage?.pngData() != defaultImage?.pngData(){
                fourthImgRemoveBtn.isHidden = false
            }else{
                fourthImgRemoveBtn.isHidden = true
            }
        }else if globalTag == 4{
            fifthAddImgBtn.setImage(chosenImage, for: .normal)
            let firstBtnImage = fifthAddImgBtn.image(for: .normal)
            let defaultImage = UIImage(named: "addBtnImage.png")
            if firstBtnImage?.pngData() != defaultImage?.pngData(){
                fifthImgRemoveBtn.isHidden = false
            }else{
                fifthImgRemoveBtn.isHidden = true
            }
            
        }
        
        
        
        picker.dismiss(animated: true)
        
    }
    
    
    
    
}
