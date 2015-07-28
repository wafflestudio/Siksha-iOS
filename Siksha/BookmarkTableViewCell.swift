//
//  BookmarkTableViewCell.swift
//  Siksha
//
//  Created by 강규 on 2015. 7. 23..
//  Copyright (c) 2015년 WaffleStudio. All rights reserved.
//

import UIKit

class BookmarkTableViewCell: UITableViewCell {

    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    let pastelPink = UIColor(red: 0.998, green: 0.872, blue: 0.851, alpha: 1)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        setPriceLabelAttributes()
    }
    
    override func setHighlighted(highlighted: Bool, animated: Bool) {
        setPriceLabelAttributes()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
        
        setPriceLabelAttributes()
    }
    
    private func setPriceLabelAttributes() {
        priceLabel!.layer.cornerRadius = 5
        priceLabel!.layer.borderWidth = 1
        priceLabel!.layer.borderColor = pastelPink.CGColor
        priceLabel!.layer.backgroundColor = pastelPink.CGColor
    }

}
