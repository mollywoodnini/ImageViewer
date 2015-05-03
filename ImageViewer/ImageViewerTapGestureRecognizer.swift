//
//  ImageViewerTapGestureRecognizer.swift
//  ImageViewer
//
//  Created by Tan Nghia La on 30.04.15.
//  Copyright (c) 2015 Tan Nghia La. All rights reserved.
//

import UIKit

class ImageViewerTapGestureRecognizer: UITapGestureRecognizer {
    var highQualityImageUrl: NSURL?
    var backgroundColor: UIColor!
    
    init(target: AnyObject, action: Selector, highQualityImageUrl: NSURL?, backgroundColor: UIColor) {
        self.highQualityImageUrl = highQualityImageUrl
        self.backgroundColor = backgroundColor
        super.init(target: target, action: action)
    }
}
