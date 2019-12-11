//
//  ProductQuestionTableViewCell.swift
//  Jewelry
//
//  Created by Apple on 04/10/19.
//  Copyright © 2019 Developer. All rights reserved.
//

import UIKit

class ProductQuestionTableViewCell: UITableViewCell {

   
    @IBOutlet weak var unlikeLabel: UILabel!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var answerLabel: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
