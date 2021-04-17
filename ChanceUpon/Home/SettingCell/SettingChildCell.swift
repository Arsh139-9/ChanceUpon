//
//  SettingChildCell.swift
//  ChanceUpon
//
//  Created by Dharmani Apps mini on 8/26/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import RangeSeekSlider

class SettingChildCell: UITableViewCell {

    @IBOutlet weak var initiateLbl: UILabel!
    
    @IBOutlet weak var resultLbl: UILabel!
    
    
    @IBOutlet weak var invisibleSwitchBtn: UIButton!
    
    
    @IBOutlet weak var rangeSliderView: UIView!
    
    @IBOutlet weak var centerSOLbl: UILabel!
    
    @IBOutlet weak var settingStatusSelectedView: UIView!
    
    @IBOutlet weak var lSSMLbl: UILabel!
    
    @IBOutlet weak var sliderObj: RangeSeekSlider!
    
    
//    @IBOutlet weak var sliderObj: MultiSlider!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
  
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}
