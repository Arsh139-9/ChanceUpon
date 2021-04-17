//
//  AddUserInterestVC.swift
//  ChanceUpon
//
//  Created by Dharmani Apps mini on 8/20/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class AddUserInterestVC: UIViewController {

    @IBOutlet weak var addInterestBtn: UIButton!
    
    @IBOutlet weak var interestTF: UITextField!
    
    @IBOutlet weak var addInterestTBObj: UITableView!
    
    @IBOutlet weak var interestTBViewHeightConstraint: NSLayoutConstraint!
    lazy var interestArr = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        addInterestTBObj.isHidden = true
        interestTBViewHeightConstraint.constant = 0
        addInterestBtn.isHidden = true
        // Do any additional setup after loading the view.
        interestTF.delegate = self
        interestTF.addTarget(self, action: #selector(textFieldDidChange(theTextField:)), for: .editingChanged)
        addSwipe(view: view)
    }
    @objc func textFieldDidChange(theTextField:UITextField){
        if theTextField.text!.count > 0 {
            addInterestBtn.isHidden = false
        }
      }
    
    @IBAction func addInterestBtnAction(_ sender: Any) {
        let trimmedString = interestTF.text?.trimmingCharacters(
        in: CharacterSet.whitespacesAndNewlines)
        if trimmedString?.count == 0{
            Alert.present(
                title: AppAlertTitle.appName.rawValue,
                message:AppSignInForgotSignUpAlertNessage.enterText,
                actions: .ok(handler: {
                }),
                from: self
            )
            
    
        }else if interestArr.count < 5{
            interestArr.append(interestTF.text ?? "")
                  addInterestTBObj.isHidden = false
                  interestTBViewHeightConstraint.constant = 263
                  addInterestTBObj.reloadData()
                  interestTF.text = ""
        }
        
      else{
        
        Alert.present(
            title: AppAlertTitle.appName.rawValue,
            message: AppSignInForgotSignUpAlertNessage.maxLimitInterest,
            actions: .ok(handler: {
                self.interestTF.text = ""
            }),
            from: self
        )
        
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

   @IBAction func nextBtnAction(_ sender: Any) {
    if interestArr.count <= 5 && interestArr.count > 0{
        setAppDefaults(interestArr, key: "AddedInterest")
        Navigation.init().pushCallBack(ViewControllerIdentifier.AddUserOccupationVC,StoryboardName.SignUp,AddUserInterestVC(),self.storyboard!, self.navigationController!)
      
                 
    }else{
    
        Alert.present(
            title: AppAlertTitle.appName.rawValue,
            message: AppSignInForgotSignUpAlertNessage.addInterest,
            actions: .ok(handler: {
            }), 
            from: self
        )
        

    }
    
    }
   

}
// MARK: TextField Delegates
extension AddUserInterestVC:UITextFieldDelegate{
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return true
    }
        
}
extension AddUserInterestVC:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return interestArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        cell?.textLabel?.text = interestArr[indexPath.row]

        
        return cell!
    }
    
    
}
extension AddUserInterestVC:UITableViewDelegate{
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
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        // Write action code for the trash
        let TrashAction = UIContextualAction(style: .normal, title:  "Delete", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            print("Update action ...")
            self.interestArr.remove(at: indexPath.row)
            tableView.reloadData()
            success(true)
        })
        TrashAction.backgroundColor = .systemPink

      


        return UISwipeActionsConfiguration(actions: [TrashAction])
    }
}
