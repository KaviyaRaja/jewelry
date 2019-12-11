//
//  ProductDetailRatingTableViewCell.swift
//  Jewelry
//
//  Created by Apple on 04/10/19.
//  Copyright © 2019 Developer. All rights reserved.
//

import UIKit

class ProductDetailRatingTableViewCell: UITableViewCell {

    @IBOutlet weak var mRatingTitleLabel: CustomFontLabel!
    @IBOutlet weak var mRatingLbl: CustomFontLabel!
    @IBOutlet weak var mRatingDateLbl: CustomFontLabel!
   
    @IBOutlet weak var image1HtConst: NSLayoutConstraint!
    @IBOutlet weak var image4: UIImageView!
    @IBOutlet weak var image3: UIImageView!
    @IBOutlet weak var image2: UIImageView!
    @IBOutlet weak var image1: UIImageView!
    @IBOutlet weak var mRatingDesLbl: CustomFontLabel!
    @IBOutlet weak var mRatingNameLbl: CustomFontLabel!
    @IBOutlet weak var mRatinglikes: CustomFontLabel!
    @IBOutlet weak var mRatingDislikes: CustomFontLabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
