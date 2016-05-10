//
//  MenuTableViewHeaderCell.swift
//  Siksha
//
//  Created by 강규 on 2015. 7. 22..
//  Copyright (c) 2015년 WaffleStudio. All rights reserved.
//

import UIKit

class MenuTableViewHeaderCell: UITableViewCell {
  
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var bookmarkButton: UIButton!
  @IBOutlet weak var aboutButton: UIButton!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    // Configure the view for the selected state
  }
  
}
