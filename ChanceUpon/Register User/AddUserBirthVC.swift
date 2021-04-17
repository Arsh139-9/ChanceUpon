//
//  AddUserBirthVC.swift
//  ChanceUpon
//
//  Created by Dharmani Apps mini on 8/20/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class AddUserBirthVC: UIViewController {
    lazy var datePicker = UIDatePicker()

    @IBOutlet weak var birthdayTF: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
      setDatePicker()
        let fStr = "dd/mm"
        let stringToColor = "/"
       let range = (fStr as NSString).range(of: stringToColor)

       let fMutableAttributedString = NSMutableAttributedString.init(string: fStr)
       fMutableAttributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.systemPink, range: range)
        let sStr = "/yyyy"
               let sStringToColor = "/"
              let sRange = (sStr as NSString).range(of: sStringToColor)

              let sMutableAttributedString = NSMutableAttributedString.init(string: sStr)
              sMutableAttributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.systemPink, range: sRange)
        let combination = NSMutableAttributedString()
        
        combination.append(fMutableAttributedString)
        combination.append(sMutableAttributedString)
    
        birthdayTF.attributedPlaceholder =  combination
        
        // Do any additional setup after loading the view.
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
    
    func setDatePicker() {
        datePicker.datePickerMode = .date
        datePicker.maximumDate = Date()
        if #available(iOS 14.0, *) {
            datePicker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        birthdayTF.inputView = datePicker

        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 44))
        toolBar.tintColor = UIColor.gray
        let doneBtn = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(showSelectedDate))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.items = [space, doneBtn]
        birthdayTF.inputAccessoryView = toolBar
    }
    @objc func showSelectedDate() {
            let formatter = DateFormatter()
            //   [formatter setDateFormat:@"dd MMMM yyyy"];
            formatter.dateFormat = "dd/MM/yyyy"
            birthdayTF.text = "\(formatter.string(from: datePicker.date))"
            birthdayTF.resignFirstResponder()
        
    }

   @IBAction func nextBtnAction(_ sender: Any) {
    if birthdayTF.text == ""{
        
        Alert.present(
            title: AppAlertTitle.appName.rawValue,
            message: AppSignInForgotSignUpAlertNessage.enterDOB,
            actions: .ok(handler: {
            }),
            from: self
        )
      
    }else{
        setAppDefaults(birthdayTF.text ?? "", key: "DOB")
        Navigation.init().pushCallBack(ViewControllerIdentifier.AddUserNameVC,StoryboardName.SignUp,AddUserBirthVC(),self.storyboard!, self.navigationController!)

        
       
        }
    }
    
    

}

extension String {

    func highlightWordsIn(highlightedWords: String, attributes: [[NSAttributedString.Key: Any]]) -> NSMutableAttributedString {
     let range = (self as NSString).range(of: highlightedWords)
     let result = NSMutableAttributedString(string: self)

     for attribute in attributes {
         result.addAttributes(attribute, range: range)
     }

     return result
    }
}
