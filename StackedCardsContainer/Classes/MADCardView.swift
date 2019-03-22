//
//  MADCardView.swift
//  CardsView
//
//  Created by Андрей Зубехин on 18/03/2019.
//  Copyright © 2019 Андрей Зубехин. All rights reserved.
//

import UIKit

public class MADCardView: MADView {
    
    var customView: UIView!
    var color: UIColor!

    public init(frame: CGRect, color: UIColor, customView: UIView) {
        self.color = color
        self.customView = customView
        super.init(frame: frame)
        setUp()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUp()
    }
    
    open override func draw(_ rect: CGRect) {
        let path = UIBezierPath()
        let newWidth = bounds.size.width
        let newHeight = bounds.size.height
        let newBounds = CGRect(x: 0, y: 0, width: newWidth, height: newHeight)
        path.move(to: CGPoint(x: newBounds.origin.x, y: newBounds.origin.y + 10))
        path.addArc(withCenter: CGPoint(x: newBounds.origin.x + 10, y: newBounds.origin.y + 10), radius: 10, startAngle: CGFloat.pi/2.0, endAngle: 3.0 * CGFloat.pi/2.0, clockwise: true)
        path.addLine(to: CGPoint(x: newBounds.origin.x + newWidth - 50, y: newBounds.origin.y))
        path.addLine(to: CGPoint(x: newBounds.origin.x + newWidth, y: newBounds.origin.y + 50)) // top right corner
        path.addLine(to: CGPoint(x: newBounds.origin.x + newWidth, y: newBounds.origin.y + newHeight - 50))
        path.addLine(to: CGPoint(x: newBounds.origin.x + newWidth - 50, y: newBounds.origin.y + newHeight)) // bottom right corner
        path.addLine(to: CGPoint(x: newBounds.origin.x + 10, y: newBounds.origin.y + newHeight)) //bottom left corner
        path.addArc(withCenter: CGPoint(x: newBounds.origin.x + 10, y: newBounds.origin.y + newHeight - 10), radius: 10, startAngle: CGFloat.pi/2.0, endAngle: CGFloat.pi, clockwise: true)
        path.addLine(to: CGPoint(x: newBounds.origin.x, y: newBounds.origin.y + 10))
        path.close()
        
        // fill the path
        color.set()
        path.fill()
    }
    
    private func setUp() {
        addSubview(customView)
        customView.pin(to: self, leftOffset: 10, rightOffset: -50, topOffset: 10, bottomOffset: -10)
        backgroundColor = .clear
    }
}

