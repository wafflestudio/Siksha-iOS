//
//  TableViewCell.swift
//  Siksha
//
//  Created by 강규 on 2015. 7. 18..
//  Copyright (c) 2015년 WaffleStudio. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    let pastelPink = UIColor(red: 1.00, green: 0.82, blue: 0.83, alpha: 1.0)
    
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
