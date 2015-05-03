//
//  UIImageView+ImageViewer.swift
//  ImageViewer
//
//  Created by Tan Nghia La on 30.04.15.
//  Copyright (c) 2015 Tan Nghia La. All rights reserved.
//

import Foundation
import UIKit

private var AssociatedImageViewerSourceObjectHandle: UInt8 = 0

extension UIImageView {
    internal var imageViewer: ImageViewer {
        get {
            return objc_getAssociatedObject(self, &AssociatedImageViewerSourceObjectHandle) as! ImageViewer
        }
        set {
            objc_setAssociatedObject(self, &AssociatedImageViewerSourceObjectHandle, newValue, objc_AssociationPolicy(OBJC_ASSOCIATION_RETAIN_NONATOMIC))
        }
    }
    
    func setupForImageViewer(highQualityImageUrl: NSURL? = nil, backgroundColor: UIColor = UIColor.whiteColor()) {
        userInteractionEnabled = true
        let gestureRecognizer = ImageViewerTapGestureRecognizer(target: self, action: "didTap:", highQualityImageUrl: highQualityImageUrl, backgroundColor: backgroundColor)
        addGestureRecognizer(gestureRecognizer)
    }
    
    func didTap(recognizer: ImageViewerTapGestureRecognizer) {
        imageViewer = ImageViewer(senderView: self, highQualityImageUrl: recognizer.highQualityImageUrl, backgroundColor: recognizer.backgroundColor)
        imageViewer.presentFromRootViewController()
    }
}