//
//  ProductCollectionViewCell.swift
//  Jewelry
//
//  Created by Febin Puthalath on 03/10/19.
//  Copyright © 2019 Developer. All rights reserved.
//

import UIKit

class ProductCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var productContainerView: UIView!
    @IBOutlet weak var userRating: UILabel!
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var actualPriceText: UILabel!
    @IBOutlet weak var offerPriceText: UILabel!
    @IBOutlet weak var offerlbl: UILabel!
    @IBOutlet weak var productTitleLabel: UILabel!
    @IBOutlet weak var productImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.backgroundColor = UIColor.white
/*cell.mBGView.layer.shadowColor = UIColor.darkGray.cgColor
 cell.mBGView.layer.shadowOffset = CGSize(width: 1, height:3)
 cell.mBGView.layer.shadowOpacity = 0.6
 cell.mBGView.layer.shadowRadius = 3.0
 cell.mBGView.layer.cornerRadius = 5.0*/
        // Initialization code
    }

    
    func setCardView(view : UIView){
        
        self.layer.cornerRadius = 5.0
        self.layer.borderColor  =  UIColor.clear.cgColor
        self.layer.borderWidth = 5.0
        self.layer.shadowOpacity = 0.5
        self.layer.shadowColor =  UIColor.lightGray.cgColor
        self.layer.shadowRadius = 5.0
        self.layer.shadowOffset = CGSize(width:5, height: 5)
        self.layer.masksToBounds = true
        
    }
    
    
}
