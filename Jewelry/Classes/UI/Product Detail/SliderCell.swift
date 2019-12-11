//
//  SliderCell.swift
//  Jewelry
//
//  Created by Apple on 07/10/19.
//  Copyright © 2019 Developer. All rights reserved.
//

import UIKit

class SliderCell: UICollectionViewCell {

    @IBOutlet weak var mSliderImageView: UIImageView!
    @IBOutlet weak var slideofferLbl: CustomFontLabel!
    @IBOutlet weak var likebtn: CustomFontButton!
    @IBOutlet weak var Sharebtn: CustomFontButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.slideofferLbl.isHidden = false
        self.slideofferLbl.layer.masksToBounds = true
        self.slideofferLbl.layer.cornerRadius = self.slideofferLbl.bounds.width / 2
//        offerLbl.layer.cornerRadius = 1
//        offerLbl.layer.masksToBounds = true
//        offerLbl.layer.borderWidth = 2
//
        
        // Initialization code
    }

}
