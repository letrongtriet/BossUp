//
//  TableViewCell.swift
//  BossUp
//
//  Created by Triet Le on 23/04/2018.
//  Copyright © 2018 Trong Triet Le. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    @IBOutlet weak var sizeLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var sellButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func didPressSellButton(_ sender: UIButton) {
        print("Sell button pressed in another class")
    }
    
}
