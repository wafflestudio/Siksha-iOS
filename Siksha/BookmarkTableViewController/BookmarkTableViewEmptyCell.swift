//
//  BookmarkTableViewEmptyCell.swift
//  Siksha
//
//  Created by 강규 on 2015. 7. 25..
//  Copyright (c) 2015년 WaffleStudio. All rights reserved.
//

import UIKit

class BookmarkTableViewEmptyCell: UITableViewCell {

    @IBOutlet weak var emptyMessageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
