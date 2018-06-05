//
//  SecondViewController.swift
//  MMParallaxView_Example
//
//  Created by Millman YANG on 2018/6/1.
//  Copyright © 2018年 CocoaPods. All rights reserved.
//

import UIKit
import MMParallaxView
class SecondViewController: MMParallaxViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Demo2"
        self.performSegue(withIdentifier: "MMParallaxTop", sender: nil)
        self.performSegue(withIdentifier: "MMParallaxBottom", sender: nil)

        parallaxView.pauseLocation = 0.5
        parallaxView.parallaxTopShiftRate = 1.0
        parallaxView.topMargin = 100
        parallaxView.heightType = .percentHeight(value: 0.8)
        parallaxView.shiftStatus = { [weak self] (status) in
            switch status {
            case .hide:
                print("upper")
            case .show:
                print("lower")
            case .percent(let value):
                if value < 0.5 {
                    self?.parallaxView.maskAlpha = 0.0
                } else {
                    print(value*0.5)
                    self?.parallaxView.maskAlpha = (value-0.5)*0.5
                }
            }
        }
        parallaxView.parallaxBottomOffsetTop = -10
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

