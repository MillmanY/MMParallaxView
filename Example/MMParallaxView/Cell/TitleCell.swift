//
//  TitleCell.swift
//  MMParallaxView_Example
//
//  Created by Millman YANG on 2018/5/30.
//  Copyright © 2018年 CocoaPods. All rights reserved.
//

import UIKit

class TitleCell: UITableViewCell {
    @IBOutlet weak var labTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func set(title: String) {
        self.labTitle.text = title
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
