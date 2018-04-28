//
//  TableViewCellReport.swift
//  BossUp
//
//  Created by Trong Triet Le on 27/04/2018.
//  Copyright © 2018 Trong Triet Le. All rights reserved.
//

import UIKit

class TableViewCellReport: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBOutlet weak var removeButton: UIButton!
    @IBOutlet weak var staffName: UILabel!

}
