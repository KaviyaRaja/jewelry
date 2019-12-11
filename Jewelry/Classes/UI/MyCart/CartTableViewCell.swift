//
//  CartTableViewCell.swift
//  ECommerce
//
//  Created by Apple on 22/07/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class CartTableViewCell: UITableViewCell {

    @IBOutlet weak var cartImageView: UIImageView!
    @IBOutlet weak var cartnameLabel: CustomFontLabel!
    @IBOutlet weak var cartprice: CustomFontLabel!
    @IBOutlet weak var cartAttributeLabel: CustomFontLabel!
    @IBOutlet weak var cartOfferLabel: CustomFontLabel!
    @IBOutlet weak var mPolishTF: CustomFontTextField!
     @IBOutlet weak var mQuantityTF: CustomFontTextField!
     @IBOutlet weak var mWeightTF: CustomFontTextField!
     @IBOutlet weak var msizeTF: CustomFontTextField!
     @IBOutlet weak var mAddView : UIView!
    @IBOutlet weak var mRemoveBtn : CustomFontButton!
    @IBOutlet weak var mMoveToCartBtn : CustomFontButton!
    
    @IBOutlet weak var mSaveForLaterLbl: CustomFontLabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

//        self.mAddView.layer.cornerRadius = 5
//        self.mAddView.layer.borderColor = UIColor(red:0.20, green:0.47, blue:0.24, alpha:1.0).cgColor
//        self.mAddView.layer.borderWidth = 1
        
        
    }
    
    @IBAction func cartsegmentControl(_ sender: UISegmentedControl) {
    }
}
