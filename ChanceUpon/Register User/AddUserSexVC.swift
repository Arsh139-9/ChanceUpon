//
//  AddUserSexVC.swift
//  ChanceUpon
//
//  Created by Dharmani Apps mini on 8/20/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class AddUserSexVC: UIViewController {
     
    
    @IBOutlet weak var straightSexLbl: UILabel!
    @IBOutlet weak var straightUnderLineLbl: UILabel!
    @IBOutlet weak var gaySexLbl: UILabel!
    @IBOutlet weak var gayUnderLineLbl: UILabel!
    @IBOutlet weak var lesbianSexLbl: UILabel!
    @IBOutlet weak var lesbianUnderLinelbl: UILabel!
    @IBOutlet weak var biSexLbl: UILabel!
    @IBOutlet weak var biUnderLinelbl: UILabel!
    
    @IBOutlet weak var aSexLbl: UILabel!
    @IBOutlet weak var aSUnderLinelbl: UILabel!
    @IBOutlet weak var demiSexLbl: UILabel!
    @IBOutlet weak var demiUnderLinelbl: UILabel!
    @IBOutlet weak var panSexLbl: UILabel!
    @IBOutlet weak var panUnderLinelbl: UILabel!
    @IBOutlet weak var queerSexLbl: UILabel!
     @IBOutlet weak var queerUnderLinelbl: UILabel!
    @IBOutlet weak var questioningSexLbl: UILabel!
        @IBOutlet weak var questioningUnderLinelbl: UILabel!
    lazy var isSelectable = Bool()
    var selectedIntStr = String()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true

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
    @IBAction func selectBtnAction(_ sender: UIButton) {
        isSelectable = true
        if sender.tag == 0{
            selectedIntStr = "0"
            straightSexLbl.textColor = UIColor(red:230.0/255.0 , green:43.0/255.0 , blue:78.0/255.0 , alpha:1 )
            straightUnderLineLbl.backgroundColor = UIColor(red:230.0/255.0 , green:43.0/255.0 , blue:78.0/255.0 , alpha:1 )
            gaySexLbl.textColor = UIColor(red:215.0/255.0 , green:215.0/255.0 , blue:215.0/255.0 , alpha:1 )
            gayUnderLineLbl.backgroundColor = UIColor(red:218.0/255.0 , green:218.0/255.0 , blue:218.0/255.0 , alpha:1 )
            lesbianSexLbl.textColor = UIColor(red:215.0/255.0 , green:215.0/255.0 , blue:215.0/255.0 , alpha:1 )
            lesbianUnderLinelbl.backgroundColor = UIColor(red:218.0/255.0 , green:218.0/255.0 , blue:218.0/255.0 , alpha:1 )
            biSexLbl.textColor = UIColor(red:215.0/255.0 , green:215.0/255.0 , blue:215.0/255.0 , alpha:1 )
            biUnderLinelbl.backgroundColor = UIColor(red:218.0/255.0 , green:218.0/255.0 , blue:218.0/255.0 , alpha:1 )
            aSexLbl.textColor = UIColor(red:215.0/255.0 , green:215.0/255.0 , blue:215.0/255.0 , alpha:1 )
            aSUnderLinelbl.backgroundColor = UIColor(red:218.0/255.0 , green:218.0/255.0 , blue:218.0/255.0 , alpha:1 )
            demiSexLbl.textColor = UIColor(red:215.0/255.0 , green:215.0/255.0 , blue:215.0/255.0 , alpha:1 )
            demiUnderLinelbl.backgroundColor = UIColor(red:218.0/255.0 , green:218.0/255.0 , blue:218.0/255.0 , alpha:1 )
            panSexLbl.textColor = UIColor(red:215.0/255.0 , green:215.0/255.0 , blue:215.0/255.0 , alpha:1 )
            panUnderLinelbl.backgroundColor = UIColor(red:218.0/255.0 , green:218.0/255.0 , blue:218.0/255.0 , alpha:1 )
            queerSexLbl.textColor = UIColor(red:215.0/255.0 , green:215.0/255.0 , blue:215.0/255.0 , alpha:1 )
            queerUnderLinelbl.backgroundColor = UIColor(red:218.0/255.0 , green:218.0/255.0 , blue:218.0/255.0 , alpha:1 )
            questioningSexLbl.textColor = UIColor(red:215.0/255.0 , green:215.0/255.0 , blue:215.0/255.0 , alpha:1 )
            questioningUnderLinelbl.backgroundColor = UIColor(red:218.0/255.0 , green:218.0/255.0 , blue:218.0/255.0 , alpha:1 )
        }
        else if sender.tag == 1{
            selectedIntStr = "1"
            straightSexLbl.textColor =  UIColor(red:215.0/255.0 , green:215.0/255.0 , blue:215.0/255.0 , alpha:1 )
                       straightUnderLineLbl.backgroundColor = UIColor(red:218.0/255.0 , green:218.0/255.0 , blue:218.0/255.0 , alpha:1 )
                       gaySexLbl.textColor = UIColor(red:230.0/255.0 , green:43.0/255.0 , blue:78.0/255.0 , alpha:1 )
                       gayUnderLineLbl.backgroundColor = UIColor(red:230.0/255.0 , green:43.0/255.0 , blue:78.0/255.0 , alpha:1 )
                       lesbianSexLbl.textColor = UIColor(red:215.0/255.0 , green:215.0/255.0 , blue:215.0/255.0 , alpha:1 )
                       lesbianUnderLinelbl.backgroundColor = UIColor(red:218.0/255.0 , green:218.0/255.0 , blue:218.0/255.0 , alpha:1 )
                       biSexLbl.textColor = UIColor(red:215.0/255.0 , green:215.0/255.0 , blue:215.0/255.0 , alpha:1 )
                       biUnderLinelbl.backgroundColor = UIColor(red:218.0/255.0 , green:218.0/255.0 , blue:218.0/255.0 , alpha:1 )
                       aSexLbl.textColor = UIColor(red:215.0/255.0 , green:215.0/255.0 , blue:215.0/255.0 , alpha:1 )
                       aSUnderLinelbl.backgroundColor = UIColor(red:218.0/255.0 , green:218.0/255.0 , blue:218.0/255.0 , alpha:1 )
                       demiSexLbl.textColor = UIColor(red:215.0/255.0 , green:215.0/255.0 , blue:215.0/255.0 , alpha:1 )
                       demiUnderLinelbl.backgroundColor = UIColor(red:218.0/255.0 , green:218.0/255.0 , blue:218.0/255.0 , alpha:1 )
                       panSexLbl.textColor = UIColor(red:215.0/255.0 , green:215.0/255.0 , blue:215.0/255.0 , alpha:1 )
                       panUnderLinelbl.backgroundColor = UIColor(red:218.0/255.0 , green:218.0/255.0 , blue:218.0/255.0 , alpha:1 )
                       queerSexLbl.textColor = UIColor(red:215.0/255.0 , green:215.0/255.0 , blue:215.0/255.0 , alpha:1 )
                       queerUnderLinelbl.backgroundColor = UIColor(red:218.0/255.0 , green:218.0/255.0 , blue:218.0/255.0 , alpha:1 )
                       questioningSexLbl.textColor = UIColor(red:215.0/255.0 , green:215.0/255.0 , blue:215.0/255.0 , alpha:1 )
                       questioningUnderLinelbl.backgroundColor = UIColor(red:218.0/255.0 , green:218.0/255.0 , blue:218.0/255.0 , alpha:1 )

        }else if sender.tag == 2{
            selectedIntStr = "2"
          straightSexLbl.textColor =  UIColor(red:215.0/255.0 , green:215.0/255.0 , blue:215.0/255.0 , alpha:1 )
           straightUnderLineLbl.backgroundColor = UIColor(red:218.0/255.0 , green:218.0/255.0 , blue:218.0/255.0 , alpha:1 )
           lesbianSexLbl.textColor = UIColor(red:230.0/255.0 , green:43.0/255.0 , blue:78.0/255.0 , alpha:1 )
           lesbianUnderLinelbl.backgroundColor = UIColor(red:230.0/255.0 , green:43.0/255.0 , blue:78.0/255.0 , alpha:1 )
           gaySexLbl.textColor = UIColor(red:215.0/255.0 , green:215.0/255.0 , blue:215.0/255.0 , alpha:1 )
           gayUnderLineLbl.backgroundColor = UIColor(red:218.0/255.0 , green:218.0/255.0 , blue:218.0/255.0 , alpha:1 )
           biSexLbl.textColor = UIColor(red:215.0/255.0 , green:215.0/255.0 , blue:215.0/255.0 , alpha:1 )
           biUnderLinelbl.backgroundColor = UIColor(red:218.0/255.0 , green:218.0/255.0 , blue:218.0/255.0 , alpha:1 )
           aSexLbl.textColor = UIColor(red:215.0/255.0 , green:215.0/255.0 , blue:215.0/255.0 , alpha:1 )
           aSUnderLinelbl.backgroundColor = UIColor(red:218.0/255.0 , green:218.0/255.0 , blue:218.0/255.0 , alpha:1 )
           demiSexLbl.textColor = UIColor(red:215.0/255.0 , green:215.0/255.0 , blue:215.0/255.0 , alpha:1 )
           demiUnderLinelbl.backgroundColor = UIColor(red:218.0/255.0 , green:218.0/255.0 , blue:218.0/255.0 , alpha:1 )
           panSexLbl.textColor = UIColor(red:215.0/255.0 , green:215.0/255.0 , blue:215.0/255.0 , alpha:1 )
           panUnderLinelbl.backgroundColor = UIColor(red:218.0/255.0 , green:218.0/255.0 , blue:218.0/255.0 , alpha:1 )
           queerSexLbl.textColor = UIColor(red:215.0/255.0 , green:215.0/255.0 , blue:215.0/255.0 , alpha:1 )
           queerUnderLinelbl.backgroundColor = UIColor(red:218.0/255.0 , green:218.0/255.0 , blue:218.0/255.0 , alpha:1 )
           questioningSexLbl.textColor = UIColor(red:215.0/255.0 , green:215.0/255.0 , blue:215.0/255.0 , alpha:1 )
           questioningUnderLinelbl.backgroundColor = UIColor(red:218.0/255.0 , green:218.0/255.0 , blue:218.0/255.0 , alpha:1 )

        }else if sender.tag == 3{
            selectedIntStr = "3"
            straightSexLbl.textColor =  UIColor(red:215.0/255.0 , green:215.0/255.0 , blue:215.0/255.0 , alpha:1 )
            straightUnderLineLbl.backgroundColor = UIColor(red:218.0/255.0 , green:218.0/255.0 , blue:218.0/255.0 , alpha:1 )
            biSexLbl.textColor = UIColor(red:230.0/255.0 , green:43.0/255.0 , blue:78.0/255.0 , alpha:1 )
            biUnderLinelbl.backgroundColor = UIColor(red:230.0/255.0 , green:43.0/255.0 , blue:78.0/255.0 , alpha:1 )
            gaySexLbl.textColor = UIColor(red:215.0/255.0 , green:215.0/255.0 , blue:215.0/255.0 , alpha:1 )
            gayUnderLineLbl.backgroundColor = UIColor(red:218.0/255.0 , green:218.0/255.0 , blue:218.0/255.0 , alpha:1 )
            lesbianSexLbl.textColor = UIColor(red:215.0/255.0 , green:215.0/255.0 , blue:215.0/255.0 , alpha:1 )
            lesbianUnderLinelbl.backgroundColor = UIColor(red:218.0/255.0 , green:218.0/255.0 , blue:218.0/255.0 , alpha:1 )
            aSexLbl.textColor = UIColor(red:215.0/255.0 , green:215.0/255.0 , blue:215.0/255.0 , alpha:1 )
            aSUnderLinelbl.backgroundColor = UIColor(red:218.0/255.0 , green:218.0/255.0 , blue:218.0/255.0 , alpha:1 )
            demiSexLbl.textColor = UIColor(red:215.0/255.0 , green:215.0/255.0 , blue:215.0/255.0 , alpha:1 )
            demiUnderLinelbl.backgroundColor = UIColor(red:218.0/255.0 , green:218.0/255.0 , blue:218.0/255.0 , alpha:1 )
            panSexLbl.textColor = UIColor(red:215.0/255.0 , green:215.0/255.0 , blue:215.0/255.0 , alpha:1 )
            panUnderLinelbl.backgroundColor = UIColor(red:218.0/255.0 , green:218.0/255.0 , blue:218.0/255.0 , alpha:1 )
            queerSexLbl.textColor = UIColor(red:215.0/255.0 , green:215.0/255.0 , blue:215.0/255.0 , alpha:1 )
            queerUnderLinelbl.backgroundColor = UIColor(red:218.0/255.0 , green:218.0/255.0 , blue:218.0/255.0 , alpha:1 )
            questioningSexLbl.textColor = UIColor(red:215.0/255.0 , green:215.0/255.0 , blue:215.0/255.0 , alpha:1 )
            questioningUnderLinelbl.backgroundColor = UIColor(red:218.0/255.0 , green:218.0/255.0 , blue:218.0/255.0 , alpha:1 )
        }else if sender.tag == 4{
            selectedIntStr = "4"
            straightSexLbl.textColor =  UIColor(red:215.0/255.0 , green:215.0/255.0 , blue:215.0/255.0 , alpha:1 )
                      straightUnderLineLbl.backgroundColor = UIColor(red:218.0/255.0 , green:218.0/255.0 , blue:218.0/255.0 , alpha:1 )
                      aSexLbl.textColor = UIColor(red:230.0/255.0 , green:43.0/255.0 , blue:78.0/255.0 , alpha:1 )
                      aSUnderLinelbl.backgroundColor = UIColor(red:230.0/255.0 , green:43.0/255.0 , blue:78.0/255.0 , alpha:1 )
                      gaySexLbl.textColor = UIColor(red:215.0/255.0 , green:215.0/255.0 , blue:215.0/255.0 , alpha:1 )
                      gayUnderLineLbl.backgroundColor = UIColor(red:218.0/255.0 , green:218.0/255.0 , blue:218.0/255.0 , alpha:1 )
                      lesbianSexLbl.textColor = UIColor(red:215.0/255.0 , green:215.0/255.0 , blue:215.0/255.0 , alpha:1 )
                      lesbianUnderLinelbl.backgroundColor = UIColor(red:218.0/255.0 , green:218.0/255.0 , blue:218.0/255.0 , alpha:1 )
                      biSexLbl.textColor = UIColor(red:215.0/255.0 , green:215.0/255.0 , blue:215.0/255.0 , alpha:1 )
                      biUnderLinelbl.backgroundColor = UIColor(red:218.0/255.0 , green:218.0/255.0 , blue:218.0/255.0 , alpha:1 )
                      demiSexLbl.textColor = UIColor(red:215.0/255.0 , green:215.0/255.0 , blue:215.0/255.0 , alpha:1 )
                      demiUnderLinelbl.backgroundColor = UIColor(red:218.0/255.0 , green:218.0/255.0 , blue:218.0/255.0 , alpha:1 )
                      panSexLbl.textColor = UIColor(red:215.0/255.0 , green:215.0/255.0 , blue:215.0/255.0 , alpha:1 )
                      panUnderLinelbl.backgroundColor = UIColor(red:218.0/255.0 , green:218.0/255.0 , blue:218.0/255.0 , alpha:1 )
                      queerSexLbl.textColor = UIColor(red:215.0/255.0 , green:215.0/255.0 , blue:215.0/255.0 , alpha:1 )
                      queerUnderLinelbl.backgroundColor = UIColor(red:218.0/255.0 , green:218.0/255.0 , blue:218.0/255.0 , alpha:1 )
                      questioningSexLbl.textColor = UIColor(red:215.0/255.0 , green:215.0/255.0 , blue:215.0/255.0 , alpha:1 )
                      questioningUnderLinelbl.backgroundColor = UIColor(red:218.0/255.0 , green:218.0/255.0 , blue:218.0/255.0 , alpha:1 )
        }else if sender.tag == 5{
            selectedIntStr = "5"
            straightSexLbl.textColor =  UIColor(red:215.0/255.0 , green:215.0/255.0 , blue:215.0/255.0 , alpha:1 )
            straightUnderLineLbl.backgroundColor = UIColor(red:218.0/255.0 , green:218.0/255.0 , blue:218.0/255.0 , alpha:1 )
            demiSexLbl.textColor = UIColor(red:230.0/255.0 , green:43.0/255.0 , blue:78.0/255.0 , alpha:1 )
            demiUnderLinelbl.backgroundColor = UIColor(red:230.0/255.0 , green:43.0/255.0 , blue:78.0/255.0 , alpha:1 )
            gaySexLbl.textColor = UIColor(red:215.0/255.0 , green:215.0/255.0 , blue:215.0/255.0 , alpha:1 )
            gayUnderLineLbl.backgroundColor = UIColor(red:218.0/255.0 , green:218.0/255.0 , blue:218.0/255.0 , alpha:1 )
            lesbianSexLbl.textColor = UIColor(red:215.0/255.0 , green:215.0/255.0 , blue:215.0/255.0 , alpha:1 )
            lesbianUnderLinelbl.backgroundColor = UIColor(red:218.0/255.0 , green:218.0/255.0 , blue:218.0/255.0 , alpha:1 )
            biSexLbl.textColor = UIColor(red:215.0/255.0 , green:215.0/255.0 , blue:215.0/255.0 , alpha:1 )
            biUnderLinelbl.backgroundColor = UIColor(red:218.0/255.0 , green:218.0/255.0 , blue:218.0/255.0 , alpha:1 )
            aSexLbl.textColor = UIColor(red:215.0/255.0 , green:215.0/255.0 , blue:215.0/255.0 , alpha:1 )
            aSUnderLinelbl.backgroundColor = UIColor(red:218.0/255.0 , green:218.0/255.0 , blue:218.0/255.0 , alpha:1 )
            panSexLbl.textColor = UIColor(red:215.0/255.0 , green:215.0/255.0 , blue:215.0/255.0 , alpha:1 )
            panUnderLinelbl.backgroundColor = UIColor(red:218.0/255.0 , green:218.0/255.0 , blue:218.0/255.0 , alpha:1 )
            queerSexLbl.textColor = UIColor(red:215.0/255.0 , green:215.0/255.0 , blue:215.0/255.0 , alpha:1 )
            queerUnderLinelbl.backgroundColor = UIColor(red:218.0/255.0 , green:218.0/255.0 , blue:218.0/255.0 , alpha:1 )
            questioningSexLbl.textColor = UIColor(red:215.0/255.0 , green:215.0/255.0 , blue:215.0/255.0 , alpha:1 )
            questioningUnderLinelbl.backgroundColor = UIColor(red:218.0/255.0 , green:218.0/255.0 , blue:218.0/255.0 , alpha:1 )
        }else if sender.tag == 6{
            selectedIntStr = "6"
            straightSexLbl.textColor =  UIColor(red:215.0/255.0 , green:215.0/255.0 , blue:215.0/255.0 , alpha:1 )
                       straightUnderLineLbl.backgroundColor = UIColor(red:218.0/255.0 , green:218.0/255.0 , blue:218.0/255.0 , alpha:1 )
                       panSexLbl.textColor = UIColor(red:230.0/255.0 , green:43.0/255.0 , blue:78.0/255.0 , alpha:1 )
                       panUnderLinelbl.backgroundColor = UIColor(red:230.0/255.0 , green:43.0/255.0 , blue:78.0/255.0 , alpha:1 )
                       gaySexLbl.textColor = UIColor(red:215.0/255.0 , green:215.0/255.0 , blue:215.0/255.0 , alpha:1 )
                       gayUnderLineLbl.backgroundColor = UIColor(red:218.0/255.0 , green:218.0/255.0 , blue:218.0/255.0 , alpha:1 )
                       lesbianSexLbl.textColor = UIColor(red:215.0/255.0 , green:215.0/255.0 , blue:215.0/255.0 , alpha:1 )
                       lesbianUnderLinelbl.backgroundColor = UIColor(red:218.0/255.0 , green:218.0/255.0 , blue:218.0/255.0 , alpha:1 )
                       biSexLbl.textColor = UIColor(red:215.0/255.0 , green:215.0/255.0 , blue:215.0/255.0 , alpha:1 )
                       biUnderLinelbl.backgroundColor = UIColor(red:218.0/255.0 , green:218.0/255.0 , blue:218.0/255.0 , alpha:1 )
                       aSexLbl.textColor = UIColor(red:215.0/255.0 , green:215.0/255.0 , blue:215.0/255.0 , alpha:1 )
                       aSUnderLinelbl.backgroundColor = UIColor(red:218.0/255.0 , green:218.0/255.0 , blue:218.0/255.0 , alpha:1 )
                       demiSexLbl.textColor = UIColor(red:215.0/255.0 , green:215.0/255.0 , blue:215.0/255.0 , alpha:1 )
                       demiUnderLinelbl.backgroundColor = UIColor(red:218.0/255.0 , green:218.0/255.0 , blue:218.0/255.0 , alpha:1 )
                       queerSexLbl.textColor = UIColor(red:215.0/255.0 , green:215.0/255.0 , blue:215.0/255.0 , alpha:1 )
                       queerUnderLinelbl.backgroundColor = UIColor(red:218.0/255.0 , green:218.0/255.0 , blue:218.0/255.0 , alpha:1 )
                       questioningSexLbl.textColor = UIColor(red:215.0/255.0 , green:215.0/255.0 , blue:215.0/255.0 , alpha:1 )
                       questioningUnderLinelbl.backgroundColor = UIColor(red:218.0/255.0 , green:218.0/255.0 , blue:218.0/255.0 , alpha:1 )
        }else if sender.tag == 7{
            selectedIntStr = "7"
            straightSexLbl.textColor =  UIColor(red:215.0/255.0 , green:215.0/255.0 , blue:215.0/255.0 , alpha:1 )
                       straightUnderLineLbl.backgroundColor = UIColor(red:218.0/255.0 , green:218.0/255.0 , blue:218.0/255.0 , alpha:1 )
                       queerSexLbl.textColor = UIColor(red:230.0/255.0 , green:43.0/255.0 , blue:78.0/255.0 , alpha:1 )
                       queerUnderLinelbl.backgroundColor = UIColor(red:230.0/255.0 , green:43.0/255.0 , blue:78.0/255.0 , alpha:1 )
                       gaySexLbl.textColor = UIColor(red:215.0/255.0 , green:215.0/255.0 , blue:215.0/255.0 , alpha:1 )
                       gayUnderLineLbl.backgroundColor = UIColor(red:218.0/255.0 , green:218.0/255.0 , blue:218.0/255.0 , alpha:1 )
                       lesbianSexLbl.textColor = UIColor(red:215.0/255.0 , green:215.0/255.0 , blue:215.0/255.0 , alpha:1 )
                       lesbianUnderLinelbl.backgroundColor = UIColor(red:218.0/255.0 , green:218.0/255.0 , blue:218.0/255.0 , alpha:1 )
                       biSexLbl.textColor = UIColor(red:215.0/255.0 , green:215.0/255.0 , blue:215.0/255.0 , alpha:1 )
                       biUnderLinelbl.backgroundColor = UIColor(red:218.0/255.0 , green:218.0/255.0 , blue:218.0/255.0 , alpha:1 )
                       aSexLbl.textColor = UIColor(red:215.0/255.0 , green:215.0/255.0 , blue:215.0/255.0 , alpha:1 )
                       aSUnderLinelbl.backgroundColor = UIColor(red:218.0/255.0 , green:218.0/255.0 , blue:218.0/255.0 , alpha:1 )
                       demiSexLbl.textColor = UIColor(red:215.0/255.0 , green:215.0/255.0 , blue:215.0/255.0 , alpha:1 )
                       demiUnderLinelbl.backgroundColor = UIColor(red:218.0/255.0 , green:218.0/255.0 , blue:218.0/255.0 , alpha:1 )
                       panSexLbl.textColor = UIColor(red:215.0/255.0 , green:215.0/255.0 , blue:215.0/255.0 , alpha:1 )
                       panUnderLinelbl.backgroundColor = UIColor(red:218.0/255.0 , green:218.0/255.0 , blue:218.0/255.0 , alpha:1 )
                       questioningSexLbl.textColor = UIColor(red:215.0/255.0 , green:215.0/255.0 , blue:215.0/255.0 , alpha:1 )
                       questioningUnderLinelbl.backgroundColor = UIColor(red:218.0/255.0 , green:218.0/255.0 , blue:218.0/255.0 , alpha:1 )
        }else if sender.tag == 8{
            selectedIntStr = "8"
            straightSexLbl.textColor =  UIColor(red:215.0/255.0 , green:215.0/255.0 , blue:215.0/255.0 , alpha:1 )
                       straightUnderLineLbl.backgroundColor = UIColor(red:218.0/255.0 , green:218.0/255.0 , blue:218.0/255.0 , alpha:1 )
                       questioningSexLbl.textColor = UIColor(red:230.0/255.0 , green:43.0/255.0 , blue:78.0/255.0 , alpha:1 )
                       questioningUnderLinelbl.backgroundColor = UIColor(red:230.0/255.0 , green:43.0/255.0 , blue:78.0/255.0 , alpha:1 )
                       gaySexLbl.textColor = UIColor(red:215.0/255.0 , green:215.0/255.0 , blue:215.0/255.0 , alpha:1 )
                       gayUnderLineLbl.backgroundColor = UIColor(red:218.0/255.0 , green:218.0/255.0 , blue:218.0/255.0 , alpha:1 )
                       lesbianSexLbl.textColor = UIColor(red:215.0/255.0 , green:215.0/255.0 , blue:215.0/255.0 , alpha:1 )
                       lesbianUnderLinelbl.backgroundColor = UIColor(red:218.0/255.0 , green:218.0/255.0 , blue:218.0/255.0 , alpha:1 )
                       biSexLbl.textColor = UIColor(red:215.0/255.0 , green:215.0/255.0 , blue:215.0/255.0 , alpha:1 )
                       biUnderLinelbl.backgroundColor = UIColor(red:218.0/255.0 , green:218.0/255.0 , blue:218.0/255.0 , alpha:1 )
                       aSexLbl.textColor = UIColor(red:215.0/255.0 , green:215.0/255.0 , blue:215.0/255.0 , alpha:1 )
                       aSUnderLinelbl.backgroundColor = UIColor(red:218.0/255.0 , green:218.0/255.0 , blue:218.0/255.0 , alpha:1 )
                       demiSexLbl.textColor = UIColor(red:215.0/255.0 , green:215.0/255.0 , blue:215.0/255.0 , alpha:1 )
                       demiUnderLinelbl.backgroundColor = UIColor(red:218.0/255.0 , green:218.0/255.0 , blue:218.0/255.0 , alpha:1 )
                       panSexLbl.textColor = UIColor(red:215.0/255.0 , green:215.0/255.0 , blue:215.0/255.0 , alpha:1 )
                       panUnderLinelbl.backgroundColor = UIColor(red:218.0/255.0 , green:218.0/255.0 , blue:218.0/255.0 , alpha:1 )
                       queerSexLbl.textColor = UIColor(red:215.0/255.0 , green:215.0/255.0 , blue:215.0/255.0 , alpha:1 )
                       queerUnderLinelbl.backgroundColor = UIColor(red:218.0/255.0 , green:218.0/255.0 , blue:218.0/255.0 , alpha:1 )
        }
        
        
    }
    
    @IBAction func nextBtnAction(_ sender: Any) {
        
        if isSelectable == true{
            setAppDefaults(selectedIntStr, key: "GenderCategory")

            let storyBoard = UIStoryboard(name: StoryboardName.SignUp, bundle: nil)
            let CMDVC = storyBoard.instantiateViewController(withIdentifier: ViewControllerIdentifier.AddUserGenderVC) as? AddUserGenderVC
                   CMDVC?.isFromShowMe = true

                                              
                                     if let CMDVC = CMDVC {
                                                  navigationController?.pushViewController(CMDVC, animated: true)
                                              }
        }else{
            
            Alert.present(
                title: AppAlertTitle.appName.rawValue,
                message: AppSignInForgotSignUpAlertNessage.selectCategory,
                actions: .ok(handler: {
                }),
                from: self
            )
       
          
        }
        
        
    
    }

}
