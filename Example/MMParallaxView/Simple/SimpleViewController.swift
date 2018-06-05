//
//  SimpleViewController.swift
//  MMParallaxView_Example
//
//  Created by Millman YANG on 2018/5/30.
//  Copyright © 2018年 CocoaPods. All rights reserved.
//

import UIKit
import MMParallaxView
private let listTitle = ["Hide top View",
                         "Show top view",
                         "Top view height 400",
                         "Top height 0.5 of parallax height",
                         "Set top margin 64",
                         "Set top margin 0",
                         "Set pauseLocation 0.5",
                         "Set PauseLocation 0",
                         "Top View Shift Rate 1.0",
                         "Top View Shift Rate 2.0",
                          "Demo Parallax View ContextDemo Parallax View ContextDemo Parallax View ContextDemo Parallax View ContextDemo Parallax View ContextDemo Parallax View ContextDemo Parallax View ContextDemo Parallax View ContextDemo Parallax View ContextDemo Parallax View ContextDemo Parallax View ContextDemo Parallax View ContextDemo Parallax View ContextDemo Parallax View ContextDemo Parallax View ContextDemo Parallax View ContextDemo Parallax View ContextDemo Parallax View ContextDemo Parallax View ContextDemo Parallax View ContextDemo Parallax View ContextDemo Parallax View ContextDemo Parallax View ContextDemo Parallax View ContextDemo Parallax View ContextDemo Parallax View ContextDemo Parallax View ContextDemo Parallax View ContextDemo Parallax View ContextDemo Parallax View ContextDemo Parallax View ContextDemo Parallax View ContextDemo Parallax View ContextDemo Parallax View ContextDemo Parallax View ContextDemo Parallax View ContextDemo Parallax View ContextDemo Parallax View ContextDemo Parallax View Context"]
private let listSection2 = [("demo1", #imageLiteral(resourceName: "demo1")), ("demo2", #imageLiteral(resourceName: "demo2")),("demo3", #imageLiteral(resourceName: "demo3")) ,("demo4", #imageLiteral(resourceName: "demo4"))]

class SimpleViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var parallaxView: MMParallaxView!
    @IBOutlet weak var imgView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Demo1"

        tableView.register(UINib.init(nibName: "ImageCell", bundle: nil), forCellReuseIdentifier: "ImageCell")
        tableView.register(UINib.init(nibName: "TitleCell", bundle: nil), forCellReuseIdentifier: "TitleCell")
        parallaxView.heightType = .height(value: 300)
        parallaxView.shiftStatus = { [weak self] (status) in
            switch status {
            case .hide:
                break
//                print("upper")
            case .show:
                break
//                print("lower")
            case .percent(let value):
                self?.parallaxView.maskAlpha = value*0.5
            }
        }
    }
}

extension SimpleViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section != 0 {
            return
        }
        switch indexPath.row {
        case 0:
            parallaxView.hideTopView()
        case 1:
            parallaxView.showTopView()
        case 2:
            parallaxView.heightType = .height(value: 400)
        case 3:
            parallaxView.heightType = .percentHeight(value: 0.5)
        case 4:
            parallaxView.topMargin = 64
        case 5:
            parallaxView.topMargin = 0
        case 6:
            parallaxView.pauseLocation = 0.5
        case 7:
            parallaxView.pauseLocation = nil
        case 8:
            parallaxView.parallaxTopShiftRate = 1.0
        case 9:
            parallaxView.parallaxTopShiftRate = 2.0
        default:
            break
        }
    }
}

extension SimpleViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? listTitle.count : listSection2.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TitleCell", for: indexPath) as! TitleCell
            cell.set(title: listTitle[indexPath.row])
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ImageCell", for: indexPath) as! ImageCell
            cell.set(title: listSection2[indexPath.row].0, img: listSection2[indexPath.row].1)
            return cell
        }
    }
}
