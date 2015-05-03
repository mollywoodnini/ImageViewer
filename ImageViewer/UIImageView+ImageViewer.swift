//
//  UIImageView+ImageViewer.swift
//  ImageViewer
//
//  Created by Tan Nghia La on 03.05.15.
//  Copyright (c) 2015 Tan Nghia La. All rights reserved.
//

import Foundation
import UIKit

public extension UIImageView {
    
    public func setupForImageViewer(highQualityImageUrl: NSURL? = nil, backgroundColor: UIColor = UIColor.whiteColor()) {
        userInteractionEnabled = true
        let gestureRecognizer = ImageViewerTapGestureRecognizer(target: self, action: "didTap:", highQualityImageUrl: highQualityImageUrl, backgroundColor: backgroundColor)
        addGestureRecognizer(gestureRecognizer)
    }
    
    internal func didTap(recognizer: ImageViewerTapGestureRecognizer) {        
        let imageViewer = ImageViewer(senderView: self, highQualityImageUrl: recognizer.highQualityImageUrl, backgroundColor: recognizer.backgroundColor)
        imageViewer.presentFromRootViewController()
    }
}

class ImageViewerTapGestureRecognizer: UITapGestureRecognizer {
    var highQualityImageUrl: NSURL?
    var backgroundColor: UIColor!
    
    init(target: AnyObject, action: Selector, highQualityImageUrl: NSURL?, backgroundColor: UIColor) {
        self.highQualityImageUrl = highQualityImageUrl
        self.backgroundColor = backgroundColor
        super.init(target: target, action: action)
    }
}