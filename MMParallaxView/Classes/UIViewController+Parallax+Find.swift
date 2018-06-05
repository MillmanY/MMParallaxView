//
//  UIViewController+Parallax+Find.swift
//  Pods
//
//  Created by Millman YANG on 2018/6/5.
//

import Foundation
extension UIViewController {
    
    public var parallax: MMParallaxView? {
        get {
            return UIViewController.findFrom(vc: self)
        }
    }
    
    
    static func findFrom(vc: UIViewController?) -> MMParallaxView? {
        guard let p = vc?.parent else {
            return nil
        }
        
        if let parallx = p as? MMParallaxViewController {
            return parallx.parallaxView
        } else {
            return UIViewController.findFrom(vc: p)
        }
    }
}
