//
//  ImageViewer.swift
//  ImageViewer
//
//  Created by Tan Nghia La on 30.04.15.
//  Copyright (c) 2015 Tan Nghia La. All rights reserved.
//

import UIKit

final class ImageViewer: UIViewController {
    // MARK: - Properties
    private let kMinMaskViewAlpha: CGFloat = 0.3
    private let kMaxImageScale: CGFloat = 2.5
    private let kMinImageScale: CGFloat = 1.0
    
    private let senderView: UIImageView
    private var originalFrameRelativeToScreen: CGRect!
    private var rootViewController: UIViewController!
    private let imageView = UIImageView()
    private var panGesture: UIPanGestureRecognizer!
    private var panOrigin: CGPoint!
    
    private var isAnimating = false
    private var isLoaded = false
    
    private var closeButton = UIButton()
    private let windowBounds = UIScreen.mainScreen().bounds
    private let scrollView = UIScrollView()
    private let maskView = UIView()
    
    // MARK: - Lifecycle methods
    init(senderView: UIImageView, backgroundColor: UIColor) {
        self.senderView = senderView
        
        rootViewController = UIApplication.sharedApplication().keyWindow!.rootViewController!
        maskView.backgroundColor = backgroundColor
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        configureMaskView()
        configureScrollView()
        configureCloseButton()
        configureImageView()
        configureConstraints()
    }
    
    // MARK: - View configuration
    private func configureScrollView() {
        scrollView.frame = windowBounds
        scrollView.delegate = self
        scrollView.minimumZoomScale = kMinImageScale
        scrollView.maximumZoomScale = kMaxImageScale
        scrollView.zoomScale = 1
        
        view.addSubview(scrollView)
    }
    
    private func configureMaskView() {
        maskView.frame = windowBounds
        maskView.alpha = 0.0
        
        view.insertSubview(maskView, atIndex: 0)
    }
    
    private func configureCloseButton() {
        closeButton.alpha = 0.0
        
        let image = UIImage(named: "Close", inBundle: NSBundle(forClass: ImageViewer.self), compatibleWithTraitCollection: nil)
        
        closeButton.setImage(image, forState: .Normal)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.addTarget(self, action: "closeButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
        view.addSubview(closeButton)
        
        view.setNeedsUpdateConstraints()
    }
    
    private func configureView() {
        var originalFrame = senderView.convertRect(windowBounds, toView: nil)
        originalFrame.origin = CGPoint(x: originalFrame.origin.x, y: originalFrame.origin.y)
        originalFrame.size = senderView.frame.size
        
        originalFrameRelativeToScreen = originalFrame
        
        UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: UIStatusBarAnimation.Slide)
    }
    
    private func configureImageView() {
        senderView.alpha = 0.0
        
        imageView.frame = originalFrameRelativeToScreen
        imageView.userInteractionEnabled = true
        imageView.contentMode = UIViewContentMode.ScaleAspectFit
        
        imageView.image = senderView.image
        
        scrollView.addSubview(imageView)
        
        animateEntry()
        addPanGestureToView()
        addGestures()
        
        centerScrollViewContents()
    }
    
    private func configureConstraints() {
        var constraints: [NSLayoutConstraint] = []
        
        let views: [String: UIView] = [
            "closeButton": closeButton
        ]
        
        constraints.append(NSLayoutConstraint(item: closeButton, attribute: .CenterX, relatedBy: .Equal, toItem: closeButton.superview, attribute: .CenterX, multiplier: 1.0, constant: 0))
        constraints.appendContentsOf(NSLayoutConstraint.constraintsWithVisualFormat("V:[closeButton(==64)]-40-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
        constraints.appendContentsOf(NSLayoutConstraint.constraintsWithVisualFormat("H:[closeButton(==64)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
        
        NSLayoutConstraint.activateConstraints(constraints)
    }
    
    // MARK: - Gestures
    private func addPanGestureToView() {
        panGesture = UIPanGestureRecognizer(target: self, action: "gestureRecognizerDidPan:")
        panGesture.cancelsTouchesInView = false
        panGesture.delegate = self
        
        imageView.addGestureRecognizer(panGesture)
    }
    
    private func addGestures() {
        let singleTapRecognizer = UITapGestureRecognizer(target: self, action: "didSingleTap:")
        singleTapRecognizer.numberOfTapsRequired = 1
        singleTapRecognizer.numberOfTouchesRequired = 1
        scrollView.addGestureRecognizer(singleTapRecognizer)
        
        let doubleTapRecognizer = UITapGestureRecognizer(target: self, action: "didDoubleTap:")
        doubleTapRecognizer.numberOfTapsRequired = 2
        doubleTapRecognizer.numberOfTouchesRequired = 1
        scrollView.addGestureRecognizer(doubleTapRecognizer)
        
        singleTapRecognizer.requireGestureRecognizerToFail(doubleTapRecognizer)
    }
    
    private func zoomInZoomOut(point: CGPoint) {
        let newZoomScale = scrollView.zoomScale > (scrollView.maximumZoomScale / 2) ? scrollView.minimumZoomScale : scrollView.maximumZoomScale
        
        let scrollViewSize = scrollView.bounds.size
        let w = scrollViewSize.width / newZoomScale
        let h = scrollViewSize.height / newZoomScale
        let x = point.x - (w / 2.0)
        let y = point.y - (h / 2.0)
        
        let rectToZoomTo = CGRect(x: x, y: y, width: w, height: h)
        
        scrollView.zoomToRect(rectToZoomTo, animated: true)
    }
    
    // MARK: - Animation
    private func animateEntry() {
        guard let image = imageView.image else {
            fatalError("no image provided")
        }
        
        UIView.animateWithDuration(0.8, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.6, options: [UIViewAnimationOptions.BeginFromCurrentState, UIViewAnimationOptions.CurveEaseInOut], animations: {() -> Void in
            self.imageView.frame = self.centerFrameFromImage(image)
        }, completion: nil)
        
        UIView.animateWithDuration(0.4, delay: 0.03, options: [UIViewAnimationOptions.BeginFromCurrentState, UIViewAnimationOptions.CurveEaseInOut], animations: {() -> Void in
            self.closeButton.alpha = 1.0
            self.maskView.alpha = 1.0
        }, completion: nil)
        
        UIView.animateWithDuration(0.4, delay: 0.1, options: [UIViewAnimationOptions.BeginFromCurrentState, UIViewAnimationOptions.CurveEaseInOut], animations: {() -> Void in
            self.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1)
            self.rootViewController.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.95, 0.95)
        }, completion: nil)
    }
    
    private func centerFrameFromImage(image: UIImage) -> CGRect {
        var newImageSize = imageResizeBaseOnWidth(windowBounds.size.width, oldWidth: image.size.width, oldHeight: image.size.height)
        newImageSize.height = min(windowBounds.size.height, newImageSize.height)
        
        return CGRect(x: 0, y: windowBounds.size.height / 2 - newImageSize.height / 2, width: newImageSize.width, height: newImageSize.height)
    }
    
    private func imageResizeBaseOnWidth(newWidth: CGFloat, oldWidth: CGFloat, oldHeight: CGFloat) -> CGSize {
        let scaleFactor = newWidth / oldWidth
        let newHeight = oldHeight * scaleFactor

        return CGSize(width: newWidth, height: newHeight)
    }
    
    // MARK: - Actions
    func gestureRecognizerDidPan(recognizer: UIPanGestureRecognizer) {
        if scrollView.zoomScale != 1.0 || isAnimating {
            return
        }
        
        senderView.alpha = 0.0
        
        scrollView.bounces = false
        let windowSize = maskView.bounds.size
        let currentPoint = panGesture.translationInView(scrollView)
        let y = currentPoint.y + panOrigin.y
        
        imageView.frame.origin = CGPoint(x: currentPoint.x + panOrigin.x, y: y)
        
        let yDiff = abs((y + imageView.frame.size.height / 2) - windowSize.height / 2)
        maskView.alpha = max(1 - yDiff / (windowSize.height / 0.95), kMinMaskViewAlpha)
        closeButton.alpha = max(1 - yDiff / (windowSize.height / 0.95), kMinMaskViewAlpha) / 2
        
        if (panGesture.state == UIGestureRecognizerState.Ended || panGesture.state == UIGestureRecognizerState.Cancelled)
            && scrollView.zoomScale == 1.0 {
            maskView.alpha < 0.85 ? dismissViewController() : rollbackViewController()
        }
    }
    
    func didSingleTap(recognizer: UITapGestureRecognizer) {
        scrollView.zoomScale == 1.0 ? dismissViewController() : scrollView.setZoomScale(1.0, animated: true)
    }
    
    func didDoubleTap(recognizer: UITapGestureRecognizer) {
        let pointInView = recognizer.locationInView(imageView)
        zoomInZoomOut(pointInView)
    }
    
    func closeButtonTapped(sender: UIButton) {
        if scrollView.zoomScale != 1.0 {
            scrollView.setZoomScale(1.0, animated: true)
        }
        dismissViewController()
    }
    
    // MARK: - Misc.
    private func centerScrollViewContents() {
        let boundsSize = rootViewController.view.bounds.size
        var contentsFrame = imageView.frame
        
        if contentsFrame.size.width < boundsSize.width {
            contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2.0
        } else {
            contentsFrame.origin.x = 0.0
        }
        
        if contentsFrame.size.height < boundsSize.height {
            contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2.0
        } else {
            contentsFrame.origin.y = 0.0
        }
        
        imageView.frame = contentsFrame
    }
    
    private func rollbackViewController() {
        guard let image = imageView.image else {
            fatalError("no image provided")
        }
        
        isAnimating = true
        UIView.animateWithDuration(0.8, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.6, options: [UIViewAnimationOptions.BeginFromCurrentState, UIViewAnimationOptions.CurveEaseInOut], animations: {() in
            self.imageView.frame = self.centerFrameFromImage(image)
            self.maskView.alpha = 1.0
            self.closeButton.alpha = 1.0
            }, completion: {(finished) in
                self.isAnimating = false
        })
    }
    
    private func dismissViewController() {
        isAnimating = true
        dispatch_async(dispatch_get_main_queue(), {
            self.imageView.clipsToBounds = true
            
            UIView.animateWithDuration(0.2, animations: {() in
                self.closeButton.alpha = 0.0
            })
            
            UIView.animateWithDuration(0.8, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.6, options: [UIViewAnimationOptions.BeginFromCurrentState, UIViewAnimationOptions.CurveEaseInOut], animations: {() in
                self.imageView.frame = self.originalFrameRelativeToScreen
                self.rootViewController.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0)
                self.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0)
                self.maskView.alpha = 0.0
                UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: UIStatusBarAnimation.None)
                }, completion: {(finished) in
                    self.willMoveToParentViewController(nil)
                    self.view.removeFromSuperview()
                    self.removeFromParentViewController()
                    self.senderView.alpha = 1.0
                    self.isAnimating = false
            })
        })
    }
    
    func presentFromRootViewController() {
        willMoveToParentViewController(rootViewController)
        rootViewController.view.addSubview(view)
        rootViewController.addChildViewController(self)
        didMoveToParentViewController(rootViewController)
    }
}

// MARK: - GestureRecognizer delegate
extension ImageViewer: UIGestureRecognizerDelegate {
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        panOrigin = imageView.frame.origin
        gestureRecognizer.enabled = true
        return !isAnimating
    }
}

// MARK: - ScrollView delegate
extension ImageViewer: UIScrollViewDelegate {
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidZoom(scrollView: UIScrollView) {
        isAnimating = true
        centerScrollViewContents()
    }
    
    func scrollViewDidEndZooming(scrollView: UIScrollView, withView view: UIView?, atScale scale: CGFloat) {
        isAnimating = false
    }
}