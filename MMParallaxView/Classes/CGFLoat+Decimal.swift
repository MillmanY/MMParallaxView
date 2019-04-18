//
//  CGFLoat+Decimal.swift
//  MMParallaxView
//
//  Created by Millman YANG on 2018/6/5.
//

import UIKit
public extension CGFloat {
    func decimalCount(count : Int) -> CGFloat {
        let format = String(format: "%%.%if", count)
        let value = String(format: format, self)
        return CGFloat(atof(value))
    }
}
