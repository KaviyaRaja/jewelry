//
//  ProductListCell.swift
//  ECommerce
//
//  Created by Apple on 19/06/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
class ProductListCell: UICollectionViewCell {

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
    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
        
//        self.mListView.layer.cornerRadius = 5.0
//        self.mListView.layer.borderColor  =  UIColor.clear.cgColor
//        self.mListView.layer.borderWidth = 5.0
//        self.mListView.layer.shadowOpacity = 0.5
//        self.mListView.layer.shadowColor =  UIColor.lightGray.cgColor
//        self.mListView.layer.shadowRadius = 5.0
//        self.mListView.layer.shadowOffset = CGSize(width:5, height: 5)
//        self.mListView.layer.masksToBounds = true
        
    }
    
}


