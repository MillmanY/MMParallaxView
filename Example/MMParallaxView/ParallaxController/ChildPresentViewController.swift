//
//  ChildPresentViewController.swift
//  MMParallaxView_Example
//
//  Created by Millman YANG on 2018/6/2.
//  Copyright © 2018年 CocoaPods. All rights reserved.
//

import UIKit

class ChildPresentViewController: UIViewController {
    @IBOutlet weak var labTitle: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    var info: String?
    var img: UIImage?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.labTitle.text = info
        self.imgView.image = img
        self.view.radius(r: 10)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func dismissAction() {
        self.dismiss(animated: true, completion: nil)
    }

}
