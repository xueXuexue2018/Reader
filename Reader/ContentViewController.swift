//
//  ContentViewController.swift
//  Reader
//
//  Created by juntuo on 2018/11/13.
//  Copyright © 2018 juntuo. All rights reserved.
//

import UIKit

class ContentViewController: UIViewController {

    var content: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        let contentLb = UILabel(frame: self.view.frame)
        contentLb.textAlignment = NSTextAlignment.center
        contentLb.numberOfLines = 0
        contentLb.text = content
        self.view.addSubview(contentLb)

        let swap = UISwipeGestureRecognizer(target: self, action: #selector(swapAction))
        swap.direction = UISwipeGestureRecognizer.Direction.right
        contentLb.addGestureRecognizer(swap)
    }
    @objc private func swapAction(){
        print("轻轻的滑动")
    }
}
