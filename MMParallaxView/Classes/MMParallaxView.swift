//
//  MMParallaxView.swift
//  MMParallaxView
//
//  Created by Millman YANG on 2018/5/30.
//

import Foundation
import UIKit

public class MMParallaxView: UIView {
    fileprivate lazy var maskTopView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.black
        v.alpha = 0.0
        return v
    }()
    @IBOutlet weak public var parallaxTopView: UIView? {
        didSet {
            self.topView = parallaxTopView
        }
    }
    @IBOutlet weak public var parallaxBottomView: UIView? {
        didSet {
            
            guard let bot = parallaxBottomView else {
                return
            }
            bot.removeFromSuperview()
            bot.translatesAutoresizingMaskIntoConstraints = true
            bottomBaseView.addSubview(bot)
        }
    }
    public var autoScrollWhenHide = false
    public var maskAlpha: CGFloat = 0.0 {
        didSet {
            self.maskTopView.alpha = maskAlpha
        }
    }
    public var topMargin: CGFloat = 0.0 {
        didSet {
            self.setNeedsLayout()
            self.layoutIfNeeded()
        }
    }
    public var shiftStatus: ((ShiftStatus)->Void)? {
        didSet {
            self.shiftStatus?(status)
        }
    }
    public var heightType: TopHeightType = .height(value: 300) {
        didSet {
            switch heightType {
            case .height(let value):
                self.height = value
            case .percentHeight(let value):
                self.height = self.frame.height*value
            case .dependOnIntrinsicContent:
                self.height = self.topView?.intrinsicContentSize.height ?? .zero
            }
            self.superview?.layoutIfNeeded()
            self.reload()
        }
    }
    public var parallaxBottomOffsetTop: CGFloat = 0.0 {
        didSet {
            self.setNeedsLayout()
            self.layoutIfNeeded()
        }
    }
    public var parallaxTopShiftRate: CGFloat = 2.0
    fileprivate var displayTimer: Timer?
    private(set) var height: CGFloat = 300
    fileprivate var baseGesture: UIPanGestureRecognizer?
    fileprivate var bottomOffsetObserver: NSKeyValueObservation?
    fileprivate var offsetObserver: NSKeyValueObservation?
    fileprivate var topFrameObserver: NSKeyValueObservation?
    fileprivate var bottomObserver: NSKeyValueObservation?
    fileprivate var prePoint: CGPoint = .zero
    fileprivate let scrollView = UIScrollView()
    fileprivate var realTopHeight: CGFloat {
        get {
            return (self.topView?.frame.height ?? 0) - topMargin + parallaxBottomOffsetTop
        }
    }
    fileprivate var topView: UIView? {
        didSet {
            guard let t = topView else {
                return
            }
            t.addSubview(maskTopView)

            topFrameObserver =  t.observe(\.bounds, options: [.new], changeHandler: { [weak self] (view, value) in
                self?.maskTopView.frame = value.newValue ?? .zero
            })
            t.translatesAutoresizingMaskIntoConstraints = true
            self.clearConstraint(view: t)
            
            scrollView.addSubview(t)
        }
    }
    fileprivate var bottomGestureView: UIScrollView? {
        didSet {
            
            guard let bot = bottomGestureView else {
                bottomObserver?.invalidate()
                oldValue?.panGestureRecognizer.removeTarget(self, action: #selector(pan(gesture:)))
                return
            }
            
            if oldValue != bot {
                bottomObserver = bot.observe(\.contentOffset, options: [.new, .old]) { [weak self] (scroll, value) in
                    guard let status = self?.status, let offset = value.newValue, let old = value.oldValue, self?.displayTimer == nil else {
                        return
                    }
                 
                    switch status {
                    case .hide:
                        if offset.y < 0, old.y > 0 , !scroll.isTracking {
                            self?.startAnimate(isUp: false)
                        }
                    case .percent(_):
                        let edgeTop = bot.contentInset.top ?? 0.0

                        if offset.y != -edgeTop, self?.displayTimer == nil {
                            bot.contentOffset.y = -edgeTop
                        }
                    default : break
                    }
                }
            }
        }
    }
    lazy var bottomBaseView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.clear
        return v
    }()
        
    // 0 ~ 1
    public var pauseLocation: CGFloat?
    public var status: ShiftStatus = .show {
        didSet {
            if oldValue == status {
                return
            }
            switch status {
            case .hide:
                self.maskTopView.alpha = maskAlpha
                self.shiftStatus?(.hide)
            case .show:
                self.maskTopView.alpha = 0.0
                self.shiftStatus?(.show)
            case .percent(let value):
                self.maskTopView.alpha = maskAlpha * value
                self.shiftStatus?(.percent(value: value))
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    func setup() {
        if #available(iOS 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        }
        baseGesture = UIPanGestureRecognizer(target: self, action: #selector(pan(gesture:)))
        baseGesture?.delegate = self
        bottomBaseView.addGestureRecognizer(baseGesture!)
        scrollView.bounces = false
        scrollView.backgroundColor = UIColor.clear
        self.addSubview(scrollView)
        scrollView.addSubview(bottomBaseView)
        offsetObserver = scrollView.observe(\.contentOffset, options: [.new, .old]) { [weak self] (scroll, value) in
            guard let new = value.newValue, let width = self?.frame.width, let height = self?.height, let shiftRate = self?.parallaxTopShiftRate, let convert = self?.realTopHeight else {
                return
            }
            switch Int(new.y) {
            case ...0:
                self?.parallaxTopView?.frame = CGRect(x: 0, y: 0, width: width, height: height)
                if self?.displayTimer == nil {
                    self?.status = .show
                }
            case Int(convert)...:
                self?.parallaxTopView?.frame = CGRect(x: 0, y: convert/shiftRate, width: width, height: height)
                if self?.displayTimer == nil {
                    self?.status = .hide
                }
            case 0..<Int(convert):
                let percent = new.y/convert
                self?.parallaxTopView?.frame = CGRect.init(x: 0, y: new.y/shiftRate, width: width, height: height)
                if self?.displayTimer == nil {
                    self?.status = .percent(value: percent)
                }
            default:
                break
            }
        }
        self.superview?.layoutIfNeeded()
    }
    
 
    public func showTopView() {
        self.startAnimate(isUp: false)
    }
    
    public func hideTopView() {
        self.startAnimate(isUp: true)
    }
    
    public func set(topView: UIView, bottomView: UIView, topHeight: TopHeightType) {
        self.heightType = topHeight
        self.parallaxTopView = topView
        self.parallaxBottomView = bottomView
    }
    
 
    override public func layoutSubviews() {
        super.layoutSubviews()
        self.reload()
    }
    
    public func reload() {
        switch heightType {
        case .height(let value):
            self.height = value
        case .percentHeight(let value):
            self.height = self.bounds.height*value
        case .dependOnIntrinsicContent:
            self.height = self.topView?.intrinsicContentSize.height ?? .zero
        }
        
        if let top = topView {
            self.scrollView.sendSubviewToBack(top)
        }
        
        scrollView.contentSize = CGSize(width: self.bounds.width, height: self.bounds.height+height+parallaxBottomOffsetTop)
        scrollView.contentOffset = .zero
        scrollView.frame = self.bounds
        topView?.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: height)
        bottomBaseView.frame = CGRect(x: 0, y: height+parallaxBottomOffsetTop, width: self.frame.width, height: self.frame.height-topMargin)
        bottomBaseView.subviews.forEach { $0.frame = bottomBaseView.bounds }
        maskTopView.frame = topView?.frame ?? .zero
        scrollView.bringSubviewToFront(maskTopView)
        scrollView.isScrollEnabled = false
    }
    
    fileprivate func startAnimate(isUp: Bool) {
        if displayTimer != nil {
            return
        }
        
        displayTimer = Timer(timeInterval: 0.01, repeats: true) { [weak self] (_) in
            self?.displayLoop()
        }
        bottomGestureView?.decelerationRate = UIScrollView.DecelerationRate.init(rawValue: CGFloat.leastNormalMagnitude)
        RunLoop.current.add(displayTimer!, forMode: RunLoop.Mode.common)
        let currentPercent = self.status.percent
        let durationPercent = isUp ? 1-currentPercent : currentPercent
        var duration = TimeInterval(0.1/130 * (self.height * durationPercent))
        if duration > 0.3 { duration = 0.3 }
        self.bottomGestureView?.isScrollEnabled = false
        if !autoScrollWhenHide {
            bottomGestureView?.setContentOffset(.zero, animated: false)
        }
        UIView.animate(withDuration: duration, delay: 0.0, options: UIView.AnimationOptions.curveEaseOut, animations: {
            if let pause = self.pauseLocation, isUp && currentPercent < pause || !isUp && currentPercent > pause {
                self.scrollView.contentOffset.y = self.realTopHeight * pause
            } else {
                self.scrollView.contentOffset.y = isUp ? self.realTopHeight : 0
            }
        }, completion: { [weak self] (_) in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05, execute: {
                self?.stop()
            })
        })
    }
    
    fileprivate func stop() {
        self.bottomGestureView?.isScrollEnabled = true
        self.bottomGestureView = nil
        displayTimer?.invalidate()
        displayTimer = nil
    }
    
    @objc func displayLoop() {
        guard let y = scrollView.layer.presentation()?.bounds.origin.y else {
            return
        }
        let convert = self.realTopHeight
        switch Int(y) {
        case ...0:
            self.status = .show
        case Int(convert)...:
            self.status = .hide
        case 0..<Int(convert):
            let percent = (y/convert).decimalCount(count: 3)
            if percent >= 0.99 {
                self.status = .hide
            } else if percent <= 0.01 {
                self.status = .show
            } else {
                self.status = .percent(value: percent)
            }
        default:
            break
        }
    }
    
    deinit {
        topFrameObserver?.invalidate()
        topFrameObserver = nil
        bottomObserver?.invalidate()
        bottomObserver = nil
        offsetObserver?.invalidate()
        offsetObserver = nil
    }
}

extension MMParallaxView {

    @objc func pan(gesture: UIPanGestureRecognizer) {
        if let b = bottomGestureView, gesture.view != b {
            return
        }
        let vel = gesture.velocity(in: self)
        let point = gesture.location(in: self)
        switch gesture.state {
        case .began:
            self.prePoint = point
        case .ended:
            switch status {
            case .hide:
                if let bot = gesture.view as? UIScrollView, bot.contentOffset.y > 0 {
                    self.prePoint = point
                    return
                }
            case .percent(_):
                self.startAnimate(isUp: vel.y < 0)
            case .show:
                if vel.y <= 0 {
                    self.startAnimate(isUp: vel.y < 0)
                }
            }
            self.prePoint = .zero
        case .changed:
            if gesture.numberOfTouches != 1 { return }
            // - is UP + is Down
            let shift = point.y-self.prePoint.y
            if shift == 0 {
                break
            }

            let will = self.scrollView.contentOffset.y-shift
            self.shift(position: will, isUp: shift < 0)
        default:
            break
        }
        self.prePoint = point
    }
    
    fileprivate func shift(position: CGFloat, isUp: Bool) {
        let topHeight = self.realTopHeight
        if let scroll = bottomGestureView {
            if position > topHeight {
                self.scrollView.contentOffset.y = topHeight
                return
            }
            let edgeTop = bottomGestureView?.contentInset.top ?? 0.0
            if isUp, position < topHeight, scroll.contentOffset.y+edgeTop >= 0 || scroll.contentSize.height == 0 {
                self.scrollView.contentOffset.y = position
            } else if !isUp, position >= 0, (scroll.contentOffset.y <= 10 || !scroll.isTracking)  {
                self.scrollView.contentOffset.y = position
            } else if position <= 0 {
                self.scrollView.contentOffset = .zero
            }
        } else {
            switch position {
            case topHeight...:
                self.scrollView.contentOffset.y = topHeight
            case 0...topHeight:
                self.scrollView.contentOffset.y = position
            case ...0:
                self.scrollView.contentOffset.y = 0
            default:
                break
            }
        }
    }
    
    fileprivate func clearConstraint(view: UIView) {
        view.removeFromSuperview()
        view.constraints.forEach {
            if let first = $0.firstItem as? UIView, $0.secondItem == nil, first == view {
                view.removeConstraint($0)
            } else if let second = $0.secondItem as? UIView, $0.firstItem == nil, second == view {
                view.removeConstraint($0)
            }
        }
    }
}

extension MMParallaxView: UIGestureRecognizerDelegate {
    public override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if displayTimer == nil {
            bottomGestureView = nil
            return super.gestureRecognizerShouldBegin(gestureRecognizer)
        } else {
            return false
        }
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if let other = otherGestureRecognizer.view as? UIScrollView, other != scrollView, bottomGestureView == nil {
            bottomGestureView = other
            bottomGestureView?.panGestureRecognizer.addTarget(self, action: #selector(pan(gesture:)))
            bottomGestureView?.decelerationRate = UIScrollView.DecelerationRate.normal

        }
        return true
    }
}

// Offset return 0

