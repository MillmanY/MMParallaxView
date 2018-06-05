//
//  ChildBottomViewController.swift
//  MMParallaxView_Example
//
//  Created by Millman YANG on 2018/6/2.
//  Copyright © 2018年 CocoaPods. All rights reserved.
//

import UIKit
let list = [("demo1", #imageLiteral(resourceName: "demo1")), ("demo2", #imageLiteral(resourceName: "demo2")),("demo3", #imageLiteral(resourceName: "demo3")) ,("demo4", #imageLiteral(resourceName: "demo4"))]
class ChildBottomViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.clear
        self.tableView.radius(r: 10)
        self.view.shadow(radius: 10, opacity: 0.1, offset: CGSize.init(width: 0, height: -10))
        tableView.register(UINib.init(nibName: "ImageCell", bundle: nil), forCellReuseIdentifier: "ImageCell")
    }
}

extension ChildBottomViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        DispatchQueue.main.async { [weak self] in
            tableView.deselectRow(at: indexPath, animated: true)
            let child = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ChildPresentViewController") as! ChildPresentViewController
            child.info = list[indexPath.row].0
            child.img = list[indexPath.row].1
            child.modalPresentationStyle = .overCurrentContext
            self?.present(child, animated: true, completion: nil)
        }
    }
}

extension ChildBottomViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ImageCell", for: indexPath) as! ImageCell
        let data = list[indexPath.row]
        cell.set(title: data.0, img: data.1)
//        cell.selectionStyle = .none
        return cell
    }
}

extension UIView {
    func shadow(radius: Float, opacity: Float = 0.5, offset: CGSize = CGSize(width: 0, height: 1)) {
        self.layer.shadowOffset  = offset
        self.layer.shadowColor   = UIColor.black.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowRadius  = CGFloat(radius)
        self.clipsToBounds = false
    }
    
    func radius(r: CGFloat) {
        self.layer.cornerRadius = r
        self.clipsToBounds = true
    }
}

