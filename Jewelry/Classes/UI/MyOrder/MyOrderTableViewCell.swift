//
//  MyOrderTableViewCell.swift
//  ECommerce
//
//  Created by Apple on 24/06/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class MyOrderTableViewCell: UITableViewCell {

    @IBOutlet weak var OrderNumberlabel: CustomFontLabel!
    @IBOutlet weak var OrderDatelabel: CustomFontLabel!
    @IBOutlet weak var OrderStatuslabel: CustomFontLabel!
    @IBOutlet weak var mBgView : UIView!
    @IBOutlet weak var mCancelBtn : CustomFontButton!
    @IBOutlet weak var mDetailsBtn : CustomFontButton!
    @IBOutlet weak var mCancel2Btn : CustomFontButton!
    //@IBOutlet weak var mReorderBtn : CustomFontButton!
   //  @IBOutlet weak var mPayNowBtn : CustomFontButton!
    @IBOutlet weak var mReorderBtn: UIButton!
   @IBOutlet weak var trackBtn: CustomFontButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.trackBtn.layer.cornerRadius = 5
        self.mCancelBtn.layer.cornerRadius = 5
        self.mReorderBtn.layer.cornerRadius = 5
        //self.trackBtn.layer.borderWidth = 1
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
