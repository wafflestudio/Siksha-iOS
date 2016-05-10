//
//  MenuTableViewCell.swift
//  Siksha
//
//  Created by 강규 on 2015. 7. 18..
//  Copyright (c) 2015년 WaffleStudio. All rights reserved.
//

import UIKit

class MenuTableViewCell: UITableViewCell {
  
  @IBOutlet weak var priceLabel: UILabel!
  @IBOutlet weak var nameLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
    
    self.setPriceLabelAttributes()
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
    let orange = UIColor(red: 0.96, green: 0.55, blue: 0.36, alpha: 0.55)
    
    priceLabel!.layer.cornerRadius = 5
    priceLabel!.layer.backgroundColor = orange.CGColor
  }
}
