//
//  FilterSliderCell.swift
//  Jewelry
//
//  Created by Febin Puthalath on 15/10/19.
//  Copyright © 2019 Developer. All rights reserved.
//

import UIKit
import WARangeSlider
class FilterSliderCell: UITableViewCell {

    @IBOutlet weak var rangeSlider: RangeSlider!
    @IBOutlet weak var minimumLabel: UILabel!
    @IBOutlet weak var maximumLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        rangeSlider.maximumValue = Double(500000)
        rangeSlider.upperValue = Double(500000)
        rangeSlider.minimumValue = Double(500)
        rangeSlider.lowerValue = Double(500)


        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func rangeSliderValueChanged(_ sender: RangeSlider) {
        
        let lowerInt = Int(sender.lowerValue.rounded())
        let upperInt = Int(sender.upperValue.rounded())
        
        if lowerInt == 500{
             minimumLabel.text = "Min 500"
        }
        else{
            minimumLabel.text = String(lowerInt)

        }
        if upperInt == 500000{
            maximumLabel.text = "Max 500000+"
        }
        else{
        maximumLabel.text = String(upperInt)
        }
        
    }
}
