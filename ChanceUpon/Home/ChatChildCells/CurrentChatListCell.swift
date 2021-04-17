//
//  CurrentChatListCell.swift
//  ChanceUpon
//
//  Created by Dharmani Apps mini on 8/19/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class CurrentChatListCell: UITableViewCell {

    @IBOutlet weak var nameAgeLbl: UILabel!
    
    @IBOutlet weak var userProfileImgView: UIImageView!
    
    @IBOutlet weak var userLastMessage: UILabel!
    
    @IBOutlet weak var lineLbl: UILabel!
    
    @IBOutlet weak var chatNotificationBadgeLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
