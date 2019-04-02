//
//  MADView.swift
//  CardsView
//
//  Created by Андрей Зубехин on 18/03/2019.
//  Copyright © 2019 Андрей Зубехин. All rights reserved.
//

import UIKit
import pop

@objc public protocol BaseViewDelegate {
    @objc func didTap(view: BaseView)
    @objc func didBeginSwipe(onView view: BaseView)
    @objc func didEndSwipe(onView view: BaseView)
}

@objcMembers
open class BaseView: UIView {
    
    fileprivate struct Constants {
        // MARK: - Drag Animation Settings
        static var animationDirectionY: CGFloat = 1.0
        static var swipePercentageMargin: CGFloat = 0.6
        // MARK: - Card Finalize Swipe Animation
        static var finalizeSwipeActionAnimationDuration: TimeInterval = 0.8
        // MARK: - Card Reset Animation
        static var cardViewResetAnimationSpringBounciness: CGFloat = 10.0
        static var cardViewResetAnimationSpringSpeed: CGFloat = 20.0
        static var cardViewResetAnimationDuration: TimeInterval = 0.2
    }
    
    weak var delegate: BaseViewDelegate?
    
    // MARK: - Gesture Recognizer
    open var panGestureRecognizer: UIPanGestureRecognizer?
    open var panGestureTranslation: CGPoint = .zero
    open var tapGestureRecognizer: UITapGestureRecognizer?
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    deinit {
        if let panGestureRecognizer = panGestureRecognizer {
            removeGestureRecognizer(panGestureRecognizer)
        }
        if let tapGestureRecognizer = tapGestureRecognizer {
            removeGestureRecognizer(tapGestureRecognizer)
        }
    }
    
    open func setupGestureRecognizers() {
        // Pan Gesture Recognizer
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognized(_:)))
        self.panGestureRecognizer = panGestureRecognizer
        addGestureRecognizer(panGestureRecognizer)
        
        // Tap Gesture Recognizer
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapRecognized(_:)))
        self.tapGestureRecognizer = tapGestureRecognizer
        addGestureRecognizer(tapGestureRecognizer)
    }
    
    // MARK: - Pan Gesture Recognizer
    @objc private func panGestureRecognized(_ gestureRecognizer: UIPanGestureRecognizer) {
        panGestureTranslation = gestureRecognizer.translation(in: self)
        
        switch gestureRecognizer.state {
        case .began:
            let initialTouchPoint = gestureRecognizer.location(in: self)
            let newAnchorPoint = CGPoint(x: initialTouchPoint.x / bounds.width, y: initialTouchPoint.y / bounds.height)
            let oldPosition = CGPoint(x: bounds.size.width * layer.anchorPoint.x, y: bounds.size.height * layer.anchorPoint.y)
            let newPosition = CGPoint(x: bounds.size.width * newAnchorPoint.x, y: bounds.size.height * newAnchorPoint.y)
            layer.anchorPoint = newAnchorPoint
            layer.position = CGPoint(x: layer.position.x - oldPosition.x + newPosition.x, y: layer.position.y - oldPosition.y + newPosition.y)
            layer.rasterizationScale = UIScreen.main.scale
            layer.shouldRasterize = true
            delegate?.didBeginSwipe(onView: self)
        case .changed:
            var transform = CATransform3DIdentity
            transform = CATransform3DTranslate(transform, panGestureTranslation.x, panGestureTranslation.y, 0)
            layer.transform = transform
        case .ended:
            if let velocity = panGestureRecognizer?.velocity(in: self), velocity.x < 0 {
                let translationAnimation = POPBasicAnimation(propertyNamed: kPOPLayerTranslationXY)
                translationAnimation?.duration = Constants.finalizeSwipeActionAnimationDuration
                translationAnimation?.fromValue = NSValue(cgPoint: POPLayerGetTranslationXY(layer))
                layer.pop_add(translationAnimation, forKey: "swipeTranslationAnimation")
                self.delegate?.didEndSwipe(onView: self)
            } else {
                resetCardViewPosition()
            }
            layer.shouldRasterize = false
        default:
            resetCardViewPosition()
            layer.shouldRasterize = false
        }
    }
    
    public func resetCardViewPosition() {
        removeAnimations()
        
        // Reset Translation
        let resetPositionAnimation = POPSpringAnimation(propertyNamed: kPOPLayerTranslationXY)
        resetPositionAnimation?.fromValue = NSValue(cgPoint:POPLayerGetTranslationXY(layer))
        resetPositionAnimation?.toValue = NSValue(cgPoint: CGPoint.zero)
        resetPositionAnimation?.springBounciness = Constants.cardViewResetAnimationSpringBounciness
        resetPositionAnimation?.springSpeed = Constants.cardViewResetAnimationSpringSpeed
        resetPositionAnimation?.completionBlock = { _, _ in
            self.layer.transform = CATransform3DIdentity
        }
        layer.pop_add(resetPositionAnimation, forKey: "resetPositionAnimation")
        
        // Reset Rotation
        let resetRotationAnimation = POPBasicAnimation(propertyNamed: kPOPLayerRotation)
        resetRotationAnimation?.fromValue = POPLayerGetRotationZ(layer)
        resetRotationAnimation?.toValue = CGFloat(0.0)
        resetRotationAnimation?.duration = Constants.cardViewResetAnimationDuration
        layer.pop_add(resetRotationAnimation, forKey: "resetRotationAnimation")
    }
    
    public func removeAnimations() {
        pop_removeAllAnimations()
        layer.pop_removeAllAnimations()
    }
    
    // MARK: - Tap Gesture Recognizer
    @objc open func tapRecognized(_ recognizer: UITapGestureRecognizer) {
        delegate?.didTap(view: self)
    }
}
