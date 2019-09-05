//
//  MMParallaxViewDefine.swift
//  MMParallaxView
//
//  Created by Millman YANG on 2018/5/30.
//

import Foundation
public extension MMParallaxView {
     enum TopHeightType {
        case height(value: CGFloat)
        case percentHeight(value: CGFloat)
        case dependOnIntrinsicContent
    }
    
    enum ShiftStatus: Equatable {
        case hide
        case show
        case percent(value: CGFloat)
        public static func == (lhs: ShiftStatus, rhs: ShiftStatus) -> Bool {
            switch (lhs, rhs) {
            case (.show, .show), (.hide, .hide):
                return true
            case (.percent(let lValue), .percent(let  rValue)):
                return lValue == rValue
            default:
                return false
            }
        }
        
        var percent: CGFloat {
            get {
                switch self {
                case .hide:
                    return 1
                case .show:
                    return 0
                case .percent(let value):
                    return value
                }
            }
        }
        
    }
}

public class MMParallaxTopSegue: UIStoryboardSegue {
    override public func perform() {}
}

public class MMParallaxBottomSegue: UIStoryboardSegue {
    override public func perform() {}
}
