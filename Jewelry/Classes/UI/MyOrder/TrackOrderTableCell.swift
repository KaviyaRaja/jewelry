//
//  TrackOrderTableCell.swift
//  Jewelry
//
//  Created by Febin Puthalath on 12/10/19.
//  Copyright © 2019 Developer. All rights reserved.
//

import UIKit

class TrackOrderTableCell: UITableViewCell {

    @IBOutlet weak var bgView: UIView!
   
    @IBOutlet weak var dayLabel: CustomFontLabel!
    
    @IBOutlet var orderLabelCollection: [UILabel]!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var orderIdLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var deiveryDateLabel: UILabel!
    @IBOutlet var trackTipView: [UIView]!
    @IBOutlet var trackView: [UIView]!
    @IBOutlet weak var deliveredLabel: UILabel!
    @IBOutlet weak var shippedLabel: UILabel!
    @IBOutlet weak var packedLabel: UILabel!
    @IBOutlet weak var orderLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        for item in trackTipView{
            item.layer.cornerRadius = 8
        }
        timeLabel.isHidden = true
        dayLabel.isHidden = true
        
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
