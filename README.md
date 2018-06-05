# MMParallaxView

[![CI Status](https://img.shields.io/travis/millmanyang@gmail.com/MMParallaxView.svg?style=flat)](https://travis-ci.org/millmanyang@gmail.com/MMParallaxView)
[![Version](https://img.shields.io/cocoapods/v/MMParallaxView.svg?style=flat)](https://cocoapods.org/pods/MMParallaxView)
[![License](https://img.shields.io/cocoapods/l/MMParallaxView.svg?style=flat)](https://cocoapods.org/pods/MMParallaxView)
[![Platform](https://img.shields.io/cocoapods/p/MMParallaxView.svg?style=flat)](https://cocoapods.org/pods/MMParallaxView)


![demo1](https://github.com/MillmanY/MMParallaxView/blob/master/demoGIF/demo1.gif)
![demo2](https://github.com/MillmanY/MMParallaxView/blob/master/demoGIF/demo2.gif)


## MMParallaxViewController
    //Find your parallaxView in sub viewController
    public var parallax: MMParallaxView.MMParallaxView? { get }
    
## MMParallaxView
    //Set top view
    @IBOutlet weak public var parallaxTopView: UIView?
    //Set bottom view
    @IBOutlet weak public var parallaxBottomView: UIView?
    //mask on Top View
    public var maskAlpha: CGFloat
    //set parallaxBottomView margin with view top
    public var topMargin: CGFloat
    //scroll observer
    public var shiftStatus: ((MMParallaxView.MMParallaxView.ShiftStatus) -> Swift.Void)?
    //set parallaxTopView height
    public var heightType: MMParallaxView.MMParallaxView.TopHeightType
    public var parallaxBottomOffsetTop: CGFloat
    //set top view shift rate when you scroll bottom view (value need >= 1)
    public var parallaxTopShiftRate: CGFloat
    // value 0-1 to pause view when animate stop
    public var pauseLocation: CGFloat?
    public var status: MMParallaxView.MMParallaxView.ShiftStatus
    required public init?(coder aDecoder: NSCoder)
    public func showTopView()
    public func hideTopView()
    public func set(topView: UIView, bottomView: UIView, topHeight: MMParallaxView.MMParallaxView.TopHeightType)

## Requirements
    iOS 10.0+
    Xcode 8.0+
    Swift 3.0+, 4.0+
## Installation

MMParallaxView is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'MMParallaxView'
```

## Author

millmanyang@gmail.com

## License

MMParallaxView is available under the MIT license. See the LICENSE file for more info.
