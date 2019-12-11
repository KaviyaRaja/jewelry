//
//  CategoryCollectionViewCell.swift
//  Jewelry
//
//  Created by Febin Puthalath on 03/10/19.
//  Copyright © 2019 Developer. All rights reserved.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var categoryImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.categoryImage.layer.cornerRadius = 52.5
        // Initialization code
    }

}
