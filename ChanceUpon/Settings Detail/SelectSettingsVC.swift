//
//  SelectSettingsVC.swift
//  ChanceUpon
//
//  Created by Dharmani Apps mini on 9/14/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import CoreLocation
import SVProgressHUD

class SelectSettingsVC: UIViewController,UITextFieldDelegate{
    
    @IBOutlet weak var dynamicSelectSettingLbl: UILabel!
    
    @IBOutlet weak var userProfileImgView: UIImageView!
    
    @IBOutlet weak var dynamicSettingTF: UITextField!
    @IBOutlet weak var dynamicSettingBtn: UIButton!
    
    lazy var dynamicTFStr = String()
    lazy var dynamicBtnStr = String()
    lazy var dynamicLblStr = String()
    lazy var isFromLocationSettings = Bool()
    lazy var isFromEmailSettings = Bool()
    lazy var isFromPushSettings = Bool()
    lazy var isFromPhoneSettings = Bool()
    lazy var datePicker = UIDatePicker()
    lazy var pickerView = UIPickerView()
    let rest = RestManager()
    var pushStatus = String()
    var pickerArray = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.isHidden = true
        let userProfileImg = getSAppDefault(key: "UserProfileImage") as? String ?? ""
        var photoStr = userProfileImg
        photoStr = photoStr.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
            userProfileImgView.sd_setImage(with: URL(string: photoStr), placeholderImage:UIImage(named: "userProfilePlaceholderImg"))
        
        dynamicSettingTF.delegate = self
        
        if isFromPhoneSettings == false{
            if isFromLocationSettings == true{
                let status = getSAppDefault(key:"LocationStatus") as? String ?? ""
                if status == "Off"{
                    dynamicSettingTF.text = "Your Location: Disabled"
                    dynamicSettingBtn.setTitle("Turn on location settings", for: .normal)
                    dynamicSelectSettingLbl.text = dynamicLblStr
                }else{
                    let latitudeStr  = getSAppDefault(key: "Latitude") as? String ?? ""
                    let longitudeStr  = getSAppDefault(key: "Longitude") as? String ?? ""
                    let location = CLLocation(latitude:latitudeStr.doubleValue, longitude: longitudeStr.doubleValue)
                    CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
                        
                        guard let placemark = placemarks?.first else {
                            let errorString = error?.localizedDescription ?? "Unexpected Error"
                            print("Unable to reverse geocode the given location. Error: \(errorString)")
                            return
                        }
                        
                        let reversedGeoLocation = ReversedGeoLocation(with: placemark)
                        self.dynamicSettingTF.text = "Your Location: \(reversedGeoLocation.city), \(reversedGeoLocation.country)"
                        
                        // Apple Inc.,
                        // 1 Infinite Loop,
                        // Cupertino, CA 95014
                        // United States
                    }
                    

                    
                    dynamicSettingBtn.setTitle("Turn off location settings", for: .normal)
                    dynamicSelectSettingLbl.text = dynamicLblStr
                }
                
            }
            else if isFromPushSettings == true{
                if pushStatus == "0"{
                    dynamicSettingTF.text = "Push notifications: Allow"
                    dynamicSettingBtn.setTitle("Turn off push notifications", for: .normal)
                    dynamicSelectSettingLbl.text = dynamicLblStr
                }else{
                    dynamicSettingTF.text = "Push notifications: Off"
                    dynamicSettingBtn.setTitle("Turn on push notifications", for: .normal)
                    dynamicSelectSettingLbl.text = dynamicLblStr
                }
                
            }
            else{
                dynamicSettingTF.keyboardType = .default
                dynamicSettingTF.text = dynamicTFStr
                dynamicSettingBtn.setTitle(dynamicBtnStr, for: .normal)
                dynamicSelectSettingLbl.text = dynamicLblStr
            }
        }else{
            dynamicSettingTF.keyboardType = .phonePad
            if dynamicTFStr == "Please enter Phone Number"{
                dynamicSettingTF.placeholder = dynamicTFStr
            }else{
                dynamicSettingTF.text = dynamicTFStr
            }

        }
        if  isFromPushSettings == true || isFromLocationSettings == true{
            dynamicSettingTF.isUserInteractionEnabled = false
        }else{
            dynamicSettingTF.isUserInteractionEnabled = true
        }
        
        
        
        
        // Do any additional setup after loading the view.
        addSwipe(view: view)
        if dynamicLblStr == "Date of birth"{
            setDatePicker()
        }else if dynamicLblStr == "Gender" || dynamicLblStr == "Gender Category" || dynamicLblStr == "Show Me"{
            setPickerView()
        }else{
            
        }
    }
    open func setPickerView(){
        pickerView.translatesAutoresizingMaskIntoConstraints = false
      
        view.addSubview(pickerView)

        pickerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        pickerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        pickerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        if let char = string.cString(using: String.Encoding.utf8) {
//            let isBackSpace = strcmp(char, "\\b")
//            if (isBackSpace == -92) {
//                print("Backspace was pressed")
//                textField.text = ""
//            }
//        }
//        return true
//    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        //highlights all text
        //            textField.selectedTextRange = textField.textRange(from: textField.beginningOfDocument, to: textField.endOfDocument)
        textField.textColor = UIColor(red:230.0/255.0 , green:43.0/255.0 , blue:78.0/255.0 , alpha:1 )
        if dynamicLblStr == "Gender" || dynamicLblStr == "Gender Category" || dynamicLblStr == "Show Me"{
            textField.resignFirstResponder()
        pickerView.isHidden = false
        }else{
            pickerView.isHidden = true

        }

    }
    func setDatePicker() {
        datePicker.datePickerMode = .date
        datePicker.maximumDate = Date()
        if #available(iOS 14.0, *) {
            datePicker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        
        dynamicSettingTF.inputView = datePicker
        
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 44))
        toolBar.tintColor = UIColor.gray
        let doneBtn = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(showSelectedDate))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.items = [space, doneBtn]
        dynamicSettingTF.inputAccessoryView = toolBar
        
    }
    @objc func showSelectedDate() {
        let formatter = DateFormatter()
        //   [formatter setDateFormat:@"dd MMMM yyyy"];
        formatter.dateFormat = "dd/MM/yyyy"
        dynamicSettingTF.text = "\(formatter.string(from: datePicker.date))"
        dynamicSettingTF.resignFirstResponder()
        
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
    
    @IBAction func saveDataTUserDefBtnAction(_ sender: Any) {
        if isFromPhoneSettings == true{
            saveChangesApi(type:"4" , settingMode: dynamicSettingTF.text ?? "",settingModeParamName:"phoneNo")
        }
        else if isFromEmailSettings == true{
            saveChangesApi(type:"5" , settingMode: dynamicSettingTF.text ?? "",settingModeParamName:"email")
        }else if isFromPushSettings == true{
            saveChangesApi(type:"6" , settingMode: pushStatus,settingModeParamName: "pushNotification")
        }
        else if  dynamicLblStr == "Name"{
            setAppDefaults(dynamicSettingTF.text ?? "", key: "Name")
            self.navigationController?.popViewController(animated: true)

        }
        else if  dynamicLblStr == "Date of birth"{
            setAppDefaults(dynamicSettingTF.text ?? "", key: "D.O.B")
            self.navigationController?.popViewController(animated: true)

        }
        else if  dynamicLblStr == "Gender"{
            setAppDefaults(dynamicSettingTF.text ?? "", key: "Gender")
            self.navigationController?.popViewController(animated: true)

        }
        else if  dynamicLblStr == "Gender Category"{
            setAppDefaults(dynamicSettingTF.text ?? "", key: "GenderCategory")
            self.navigationController?.popViewController(animated: true)
        }else if dynamicLblStr == "Show Me"{
            setAppDefaults(dynamicSettingTF.text ?? "", key: "ShowMe")
            self.navigationController?.popViewController(animated: true)
        }
        else if dynamicLblStr == "Occupation"{
            setAppDefaults(dynamicSettingTF.text ?? "", key: "OccupationPS")
            self.navigationController?.popViewController(animated: true)
        }
        
        else{
            Alert.present(
                title: AppAlertTitle.appName.rawValue,
                message:"Location settings updated successfully",
                actions: .ok(handler: {
                    
                    self.navigationController?.popViewController(animated: true)
                    
                }),
                from: self
            )
        }
    }
    
    
    @IBAction func backBtnAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
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
    
    
    @IBAction func dynamicSelectBtnSettingsAction(_ sender: UIButton) {
        if sender.tag == 1{
            sender.tag = 0

            let latitudeStr  = getSAppDefault(key: "Latitude") as? String ?? ""
            let longitudeStr  = getSAppDefault(key: "Longitude") as? String ?? ""
            let location = CLLocation(latitude:latitudeStr.doubleValue, longitude: longitudeStr.doubleValue)
            
            if isFromLocationSettings == true{
                CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
                    
                    guard let placemark = placemarks?.first else {
                        let errorString = error?.localizedDescription ?? "Unexpected Error"
                        print("Unable to reverse geocode the given location. Error: \(errorString)")
                        return
                    }
                    
                    let reversedGeoLocation = ReversedGeoLocation(with: placemark)
                    self.dynamicSettingTF.text = "Your Location: \(reversedGeoLocation.city), \(reversedGeoLocation.country)"
                    
                    // Apple Inc.,
                    // 1 Infinite Loop,
                    // Cupertino, CA 95014
                    // United States
                }
                
                setAppDefaults("On", key: "LocationStatus")

                
                dynamicSettingBtn.setTitle("Turn off location settings", for: .normal)
                dynamicSelectSettingLbl.text = dynamicLblStr
                
            }  else if isFromPushSettings == true{
                pushStatus = "0"
                dynamicSettingTF.text = "Push notifications: Allow"
                dynamicSettingBtn.setTitle("Turn off push notifications", for: .normal)
                dynamicSelectSettingLbl.text = dynamicLblStr
            }
            
            
        }else{
            sender.tag = 1
            if isFromLocationSettings == true{
                setAppDefaults("Off", key: "LocationStatus")

                dynamicSettingTF.text = "Your Location: Disabled"
                dynamicSettingBtn.setTitle("Turn on location settings", for: .normal)
                dynamicSelectSettingLbl.text = dynamicLblStr
            }
            else if isFromPushSettings == true{
                pushStatus = "1"
                dynamicSettingTF.text = "Push notifications: Off"
                dynamicSettingBtn.setTitle("Turn on push notifications", for: .normal)
                dynamicSelectSettingLbl.text = dynamicLblStr
            }
            
            
        }
        
        
        
        //        navigationController?.popViewController(animated: true)
    }
    @IBAction func profileBtnAction(_ sender: UIButton) {
        Navigation.init().pushCallBack(ViewControllerIdentifier.ProfileVC,StoryboardName.Settings,SelectSettingsVC(),self.storyboard!, self.navigationController!)
        
        
    }
    
    
    
}
extension SelectSettingsVC:UIPickerViewDataSource{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerArray.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerArray[row]
    }
}
// MARK: UIPickerView Delegates
extension SelectSettingsVC:UIPickerViewDelegate{
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        dynamicSettingTF.text = pickerArray[row]
        pickerView.isHidden = true

    }
}
