//
//  transactionCell.swift
//  BossUp
//
//  Created by Trong Triet Le on 28/04/2018.
//  Copyright © 2018 Trong Triet Le. All rights reserved.
//

import UIKit

class transactionCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var seller: UILabel!
    @IBOutlet weak var quantity: UILabel!
    @IBOutlet weak var price: UILabel!
    
}
