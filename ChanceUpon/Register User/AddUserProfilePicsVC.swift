//
//  AddUserProfilePicsVC.swift
//  ChanceUpon
//
//  Created by Dharmani Apps mini on 8/20/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class AddUserProfilePicsVC: UIViewController,UINavigationControllerDelegate,UIImagePickerControllerDelegate{
   
    lazy var globalTag = Int()
    var imgArray = [Data]()
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        firstImgRemoveBtn.isHidden = true
        secImgRemoveBtn.isHidden = true
        thirdImgRemoveBtn.isHidden = true
        fourthImgRemoveBtn.isHidden = true
        fifthImgRemoveBtn.isHidden = true

    }
    
    
    @IBAction func removeSelectedImageBtnAction(_ sender: UIButton) {
        imgArray.remove(at: imgArray.count - 1)
        
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
    
    
    @IBAction func nextBtnAction(_ sender: Any) {
        let firstBtnImage = firstAddImgBtn.image(for: .normal)
        let secondBtnImage = secondAddImgBtn.image(for: .normal)
        let thirdBtnImage = thirdAddImgBtn.image(for: .normal)
        let fourthBtnImage = fourthAddImgBtn.image(for: .normal)
        let fifthBtnImage = fifthAddImgBtn.image(for: .normal)
        let defaultImage = UIImage(named: "addBtnImage.png")

        if firstBtnImage?.pngData() == defaultImage?.pngData() && secondBtnImage?.pngData() == defaultImage?.pngData() && thirdBtnImage?.pngData() == defaultImage?.pngData() &&
    fourthBtnImage?.pngData() == defaultImage?.pngData() &&
            fifthBtnImage?.pngData() == defaultImage?.pngData(){
            
            Alert.present(
                title: AppAlertTitle.appName.rawValue,
                message: AppCameraPicAlertMessage.uploadImage,
                actions: .ok(handler: {
                }),
                from: self
            )
   
           
        }else{
            
            
            setAppDefaults(imgArray, key: "ImageArray")

            Navigation.init().pushCallBack(ViewControllerIdentifier.AddUserBirthVC,StoryboardName.SignUp,AddUserProfilePicsVC(),self.storyboard!, self.navigationController!)

            
        }
            
        
    }
      @IBAction func addImageBtnAction(_ sender: UIButton) {
        globalTag = sender.tag
            let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        actionSheet.addAction(UIAlertAction(title: AppCameraPicAlertMessage.cancel, style: .cancel, handler: { action in

                // Cancel button tappped do nothing.
                actionSheet.dismiss(animated: true)

            }))

            actionSheet.addAction(UIAlertAction(title: AppCameraPicAlertMessage.camera, style: .default, handler: { action in

                // take photo button tapped.
                self.takePhoto()

            }))

            actionSheet.addAction(UIAlertAction(title: AppCameraPicAlertMessage.gallery, style: .default, handler: { action in

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
                Alert.present(
                    title: AppAlertTitle.appName.rawValue,
                    message: AppCameraPicAlertMessage.noCamera,
                    actions: .ok(handler: {
                    }),
                    from: self
                )
                         
                
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
            let data:Data = chosenImage!.jpegData(compressionQuality: 0.3)!
            imgArray.append(data)
            
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
