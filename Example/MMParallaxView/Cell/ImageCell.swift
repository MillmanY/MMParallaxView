//
//  ImageCell.swift
//  MMParallaxView_Example
//
//  Created by Millman YANG on 2018/6/2.
//  Copyright © 2018年 CocoaPods. All rights reserved.
//

import UIKit

class ImageCell: UITableViewCell {

    @IBOutlet weak var labTitle: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func set(title: String, img: UIImage) {
        self.labTitle.text = title
        self.imgView.image = img
    }
    
    
}
