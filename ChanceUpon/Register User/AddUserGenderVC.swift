//
//  AddUserGenderVC.swift
//  ChanceUpon
//
//  Created by Dharmani Apps mini on 8/20/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class AddUserGenderVC: UIViewController {
    
   lazy var isFromShowMe = Bool()
    
@IBOutlet weak var dynamicShowMeLbl: UILabel!
    @IBOutlet weak var otherDynamiclbl: UILabel!
    
    @IBOutlet weak var menLbl: UILabel!
    
    @IBOutlet weak var menUnderLineLbl: UILabel!
    @IBOutlet weak var womenLbl: UILabel!
    
    @IBOutlet weak var womenUnderLineLbl: UILabel!
    
    @IBOutlet weak var otherLbl: UILabel!
    
    @IBOutlet weak var otherUnderLineLbl: UILabel!
    
    lazy var isSelectable = Bool()
    var selectedIntStr = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if isFromShowMe == true{
        dynamicShowMeLbl.text = "Show me:"
        menLbl.text = "Men"
        womenLbl.text = "Women"
        otherDynamiclbl.text = "Both"
            isSelectable = false
        }
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
    @IBAction func selectBtnAction(_ sender: UIButton) {
        isSelectable = true
        if sender.tag == 0{
            selectedIntStr = "1"

            menLbl.textColor = UIColor(red:230.0/255.0 , green:43.0/255.0 , blue:78.0/255.0 , alpha:1 )
            menUnderLineLbl.backgroundColor = UIColor(red:230.0/255.0 , green:43.0/255.0 , blue:78.0/255.0 , alpha:1 )
            womenLbl.textColor = UIColor(red:215.0/255.0 , green:215.0/255.0 , blue:215.0/255.0 , alpha:1 )
            womenUnderLineLbl.backgroundColor = UIColor(red:218.0/255.0 , green:218.0/255.0 , blue:218.0/255.0 , alpha:1 )
            otherLbl.textColor = UIColor(red:215.0/255.0 , green:215.0/255.0 , blue:215.0/255.0 , alpha:1 )
            otherUnderLineLbl.backgroundColor = UIColor(red:218.0/255.0 , green:218.0/255.0 , blue:218.0/255.0 , alpha:1 )

        }
        else if sender.tag == 1{
            selectedIntStr = "2"

            menLbl.textColor = UIColor(red:215.0/255.0 , green:215.0/255.0 , blue:215.0/255.0 , alpha:1 )
            menUnderLineLbl.backgroundColor = UIColor(red:218.0/255.0 , green:218.0/255.0 , blue:218.0/255.0 , alpha:1 )
            womenLbl.textColor = UIColor(red:230.0/255.0 , green:43.0/255.0 , blue:78.0/255.0 , alpha:1 )
            womenUnderLineLbl.backgroundColor = UIColor(red:230.0/255.0 , green:43.0/255.0 , blue:78.0/255.0 , alpha:1 )
            otherLbl.textColor = UIColor(red:215.0/255.0 , green:215.0/255.0 , blue:215.0/255.0 , alpha:1 )
            otherUnderLineLbl.backgroundColor = UIColor(red:218.0/255.0 , green:218.0/255.0 , blue:218.0/255.0 , alpha:1 )

        }else if sender.tag == 2{
            selectedIntStr = "0"

            menLbl.textColor = UIColor(red:215.0/255.0 , green:215.0/255.0 , blue:215.0/255.0 , alpha:1 )
            menUnderLineLbl.backgroundColor = UIColor(red:218.0/255.0 , green:218.0/255.0 , blue:218.0/255.0 , alpha:1 )
            womenLbl.textColor = UIColor(red:215.0/255.0 , green:215.0/255.0 , blue:215.0/255.0 , alpha:1 )
            womenUnderLineLbl.backgroundColor = UIColor(red:218.0/255.0 , green:218.0/255.0 , blue:218.0/255.0 , alpha:1 )
            otherLbl.textColor = UIColor(red:230.0/255.0 , green:43.0/255.0 , blue:78.0/255.0 , alpha:1 )
            otherUnderLineLbl.backgroundColor = UIColor(red:230.0/255.0 , green:43.0/255.0 , blue:78.0/255.0 , alpha:1 )

        }
        
    }
    
    @IBAction func nextBtnAction(_ sender: Any) {

        if isFromShowMe == true{
            if isSelectable == true{
                setAppDefaults(selectedIntStr, key: "ShowMe")
                Navigation.init().pushCallBack(ViewControllerIdentifier.AddUserInterestVC,StoryboardName.SignUp,AddUserGenderVC(),self.storyboard!, self.navigationController!)

         
            }else{
                
                Alert.present(
                    title: AppAlertTitle.appName.rawValue,
                    message: AppSignInForgotSignUpAlertNessage.selectInterestedGender,
                    actions: .ok(handler: {
                    }),
                    from: self
                )
                
            }
        }else{
            if isSelectable == true{
                setAppDefaults(selectedIntStr, key: "Gender")

                Navigation.init().pushCallBack(ViewControllerIdentifier.AddUserSexVC,StoryboardName.SignUp,AddUserGenderVC(),self.storyboard!, self.navigationController!)
              
            }else{
                Alert.present(
                    title: AppAlertTitle.appName.rawValue,
                    message: AppSignInForgotSignUpAlertNessage.selectGender,
                    actions: .ok(handler: {
                    }), 
                    from: self
                )
                
            
              
            }
           
        }
        
        
        
       }

}
