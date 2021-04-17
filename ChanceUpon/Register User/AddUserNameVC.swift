//
//  AddUserNameVC.swift
//  ChanceUpon
//
//  Created by Dharmani Apps mini on 8/20/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class AddUserNameVC: UIViewController {

    @IBOutlet weak var nameTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true

        addSwipe(view: view)
        // Do any additional setup after loading the view.
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
        if nameTF.text == ""{
            Alert.present(
                title: AppAlertTitle.appName.rawValue,
                message: AppSignInForgotSignUpAlertNessage.enterName,
                actions: .ok(handler: {
                }),
                from: self
            )
            
        }else{
            setAppDefaults(nameTF.text ?? "", key: "name")
            Navigation.init().pushCallBack(ViewControllerIdentifier.AddUserGenderVC,StoryboardName.SignUp,AddUserNameVC(),self.storyboard!, self.navigationController!)
  
        }
        
    }

}
