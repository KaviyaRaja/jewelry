//
//  ListViewTableViewCell.swift
//  ECommerce
//
//  Created by Apple on 12/07/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class ListViewTableViewCell: UITableViewCell {

    @IBOutlet weak var listviewImage: UIImageView!
    @IBOutlet weak var listNameLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var userRating: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
     @IBOutlet weak var attributePriceLabel: UILabel!
     @IBOutlet weak var offerlabel: UILabel!
    @IBOutlet weak var wishListImage: UIImageView!
    @IBOutlet weak var  mWishListBtn : UIButton!
    
    @IBOutlet weak var mListView: UIView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.mListView.layer.cornerRadius = 5
        self.mListView.layer.borderColor = UIColor(red:0.20, green:0.47, blue:0.24, alpha:1.0).cgColor
        self.mListView.layer.borderWidth = 1
        
//        self.mListView.image = self.mPlusImageView.image!.withRenderingMode(.alwaysTemplate)
//        self.mMinusImageView.image = self.mMinusImageView.image!.withRenderingMode(.alwaysTemplate)
//
//        self.mPlusImageView.tintColor = UIColor.darkGray
//        self.mMinusImageView.tintColor = UIColor.darkGray
//
    }

    
    }
    

