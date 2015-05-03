//
//  ViewController.swift
//  ImageViewer
//
//  Created by Tan Nghia La on 24.04.15.
//  Copyright (c) 2015 Tan Nghia La. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.setupForImageViewer(highQualityImageUrl: NSURL(string: "https://developer.apple.com/swift/images/swift-og.png")!)
        
    }
}

