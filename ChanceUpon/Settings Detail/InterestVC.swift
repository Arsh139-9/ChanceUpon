//
//  InterestVC.swift
//  ChanceUpon
//
//  Created by Dharmani Apps mini on 9/15/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class InterestVC: UIViewController,UITextFieldDelegate{
    
    lazy var listArrr  = [String]()
    var newItemStr = String()
    
    @IBOutlet weak var interestTB: UITableView!
    @IBOutlet weak var userProfileImgView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let userProfileImg = getSAppDefault(key: "UserProfileImage") as? String ?? ""
           var photoStr = userProfileImg
           photoStr = photoStr.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
               userProfileImgView.sd_setImage(with: URL(string: photoStr), placeholderImage:UIImage(named: "userProfilePlaceholderImg"))
           
        //      listArrr = ["Skiing","Tarantino","Reading","Writing","Gym"]
        self.interestTB.tableFooterView = UIView(frame: .zero)
        if listArrr.count < 6{
            listArrr.insert("Add interest...", at: listArrr.count)
        }
        //        UserDefaults.standard.removeObject(forKey: "AddedInterest")
        // Do any additional setup after loading the view.
        addSwipe(view: view)
    }
    
    @IBAction func doneBtnAction(_ sender: Any) {
        if listArrr.count == 1 && listArrr[0] == "Add interest..."{
            Alert.present(
                title: AppAlertTitle.appName.rawValue,
                message: AppInterestAlertMessage.addInterestValidation,
                actions: .ok(handler: {
                }),
                from: self
            )
        }else{
            setAppDefaults(self.listArrr, key: "AddedInterest")
            navigationController?.popViewController(animated: true)
        }
       
    }
    
    @objc func addNewInterest(sender:UIButton){
        if listArrr.count < 6{
            if newItemStr != ""{
                listArrr.insert(newItemStr, at: listArrr.count - 1)
                interestTB.reloadData()
            }
        }
    }
    @objc func textFieldDidChange(_ theTextField: UITextField?) {
        newItemStr = theTextField?.text?.trimWhitespacesAndNewlines() ?? ""
    
    
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
    
    @IBAction func profileBtnAction(_ sender: UIButton) {
        Navigation.init().pushCallBack(ViewControllerIdentifier.ProfileVC,StoryboardName.Settings,InterestVC(),self.storyboard!, self.navigationController!)

        
    }
    
}
extension InterestVC:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if listArrr.count == 6{
        return 5
        }else{
            return listArrr.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let str = listArrr[indexPath.row]
        if str == "Add interest..." && listArrr.count < 6{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ACell") as? AddInterestCell
            cell?.addInterestBtn?.addTarget(self, action: #selector(addNewInterest(sender:)), for: .touchUpInside)
            cell?.addInterestTF.text = ""
            cell?.addInterestTF?.delegate = self
            cell?.addInterestTF?.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
            return cell!
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
            
            cell?.textLabel?.text = listArrr[indexPath.row].trimWhitespacesAndNewlines()
            cell?.textLabel?.font = UIFont(name:"Barlow-Medium", size: 15.0)
            return cell!
        }
        
       
    }
    
    
}
extension InterestVC:UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
        //        return UIScreen.main.bounds.size.height * 0.179
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
            
        
        
        
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
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.row == listArrr.count - 1{
            return false
        }else{
            return true
        }
    }
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        // Write action code for the trash
        let TrashAction = UIContextualAction(style: .normal, title:  "Delete", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            print("Update action ...")
            self.listArrr.remove(at: indexPath.row)
            tableView.reloadData()
            
            
            
            
            success(true)
        })
        TrashAction.backgroundColor = .systemPink
        
        
        
        
        return UISwipeActionsConfiguration(actions: [TrashAction])
    }
}
