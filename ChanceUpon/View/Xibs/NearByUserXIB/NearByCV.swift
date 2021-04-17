//
//  NearByCV.swift
//  ChanceUpon
//
//  Created by Dharmani Apps mini on 8/24/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import ImageSlideshow

class NearByCV: UICollectionViewCell {

    @IBOutlet weak var skiingLbl: UILabel!
    
    @IBOutlet weak var taranTinoLbl: UILabel!
    
    @IBOutlet weak var readingLbl: UILabel!
    
    @IBOutlet weak var writingLbl: UILabel!
    
    @IBOutlet weak var gymLbl: UILabel!
    @IBOutlet weak var chanceItBtn: UIButton!
    
    @IBOutlet weak var disLikeBtn: UIButton!
    
    @IBOutlet weak var userNameAgeLbl: UILabel!

    
    @IBOutlet weak var rectCardImgView: UIImageView!
    
    @IBOutlet weak var userImgSlideShow: ImageSlideshow!
    
      @IBOutlet weak var userImgView: UIImageView!
    
    @IBOutlet weak var notInterestedView: UIView!
    
    @IBOutlet weak var distanceLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

}

