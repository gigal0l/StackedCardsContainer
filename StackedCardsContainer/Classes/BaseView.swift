//
//  MADView.swift
//  CardsView
//
//  Created by Андрей Зубехин on 18/03/2019.
//  Copyright © 2019 Андрей Зубехин. All rights reserved.
//

import UIKit

@objc public protocol BaseViewDelegate {
    @objc func didTap(view: BaseView)
    @objc func didEndSwipe(onView view: BaseView)
}

@objcMembers
open class BaseView: UIView {
    
    weak var delegate: BaseViewDelegate?
    
    // MARK: - Gesture Recognizer
    open var tapGestureRecognizer: UITapGestureRecognizer?
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    deinit {
        if let tapGestureRecognizer = tapGestureRecognizer {
            removeGestureRecognizer(tapGestureRecognizer)
        }
    }
    
    open func setupGestureRecognizers() {
        
        // Tap Gesture Recognizer
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapRecognized(_:)))
        self.tapGestureRecognizer = tapGestureRecognizer
        addGestureRecognizer(tapGestureRecognizer)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(swipeGestureRecognized(_:)))
        swipeLeft.direction = .left
        addGestureRecognizer(swipeLeft)
    }
    
    @objc private func swipeGestureRecognized(_ swipeRecognizer: UISwipeGestureRecognizer) {
        if swipeRecognizer.direction == .left {
            UIView.animate(withDuration: 0.15) {
                self.layer.frame = CGRect(x: 0, y: self.layer.frame.origin.y, width: self.layer.frame.width, height: self.layer.frame.height)
                self.layoutIfNeeded()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                if self.layer.frame.origin.x == 0 {
                    self.delegate?.didEndSwipe(onView: self)
                }
            }
        }
    }
    
    // MARK: - Tap Gesture Recognizer
    @objc open func tapRecognized(_ recognizer: UITapGestureRecognizer) {
        delegate?.didTap(view: self)
    }
}
