//
//  MMParallaxViewController.swift
//  Pods
//
//  Created by Millman YANG on 2018/6/1.
//

import UIKit
let topIdentifier = "MMParallaxTop"
let bottomIdentifier = "MMParallaxBottom"

open class MMParallaxViewController: UIViewController {
    public let parallaxView = MMParallaxView()
    override open func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(parallaxView)
    }

    open override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue {
        case _ as MMParallaxTopSegue:
            parallaxView.parallaxTopView = segue.destination.view
            self.addChildViewController(segue.destination)
            segue.destination.didMove(toParentViewController: self)
        case _ as MMParallaxBottomSegue:
            segue.destination.definesPresentationContext = true
            self.addChildViewController(segue.destination)
            parallaxView.parallaxBottomView = segue.destination.view
            segue.destination.didMove(toParentViewController: self)
        default:
            break
        }
    }
    
    override open func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        parallaxView.frame = self.view.bounds
    }
}
