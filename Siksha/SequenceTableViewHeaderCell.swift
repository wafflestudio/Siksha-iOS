//
//  SequenceTableViewHeaderCell.swift
//  Siksha-iOS
//
//  Created by 강규 on 2015. 8. 7..
//  Copyright (c) 2015년 WaffleStudio. All rights reserved.
//

import UIKit

class SequenceTableViewHeaderCell: UITableViewCell {
  
  @IBOutlet weak var messageLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
}
