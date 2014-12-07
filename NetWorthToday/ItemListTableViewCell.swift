//
//  ItemListTableViewCell.swift
//  NetWorthToday
//
//  Created by Johnathan Grayson on 7/12/14.
//  Copyright (c) 2014 Johnathan Grayson. All rights reserved.
//

import UIKit

class ItemListTableViewCell: UITableViewCell {

    @IBOutlet weak var nameTextField: UILabel!
    
    @IBOutlet weak var categoryTextField: UILabel!
    
    @IBOutlet weak var amountTextField: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
