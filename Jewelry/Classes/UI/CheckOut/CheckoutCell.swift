//
//  CheckoutCell.swift
//  Jewelry
//
//  Created by Apple on 21/10/19.
//  Copyright © 2019 Developer. All rights reserved.
//

import UIKit

class CheckoutCell: UITableViewCell {
   
    @IBOutlet weak var mpriceTitleLabel: CustomFontLabel!
    @IBOutlet weak var mpriceAmountLabel: CustomFontLabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
