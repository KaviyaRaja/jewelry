//
//  FilterSortCell.swift
//  Jewelry
//
//  Created by Febin Puthalath on 15/10/19.
//  Copyright © 2019 Developer. All rights reserved.
//

import UIKit

class FilterSortCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var checkBoxImage: UIImageView!
    
    @IBOutlet weak var lineView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
