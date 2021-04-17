//
//  LeftMessageTableViewCell.swift
//  Mom to Market
//
//  Created by Vivek Dharmani on 30/07/20.
//  Copyright © 2020 Dharmani Apps. All rights reserved.
//

import UIKit

class LeftMessageTableViewCell: UITableViewCell {

     @IBOutlet var messageLBL: UITextView!
        @IBOutlet var backView: UIView!
   
        
        override func awakeFromNib() {
            super.awakeFromNib()
            // Initialization code
            backView.layer.cornerRadius = 11.0
            backView.clipsToBounds = true
            //    _senderTxtProfileImageView.layer.cornerRadius = 7.0;

        }

        override func setSelected(_ selected: Bool, animated: Bool) {
            super.setSelected(selected, animated: animated)

            // Configure the view for the selected state
        }

    }
