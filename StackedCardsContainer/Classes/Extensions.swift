//
//  UIView + Additions.swift
//  CardsView
//
//  Created by Андрей Зубехин on 18/03/2019.
//  Copyright © 2019 Андрей Зубехин. All rights reserved.
//
import UIKit
import Foundation

extension UIView {

    public enum TypeOfCorner: Int {
        case straight = 0
        case rounded = 1
        case cutOff = 2
    }
    
    final func pin(to view: UIView, leftOffset: CGFloat = 0, rightOffset: CGFloat = 0, topOffset: CGFloat = 0, bottomOffset: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        let constraints = [leftAnchor.constraint(equalTo: view.leftAnchor, constant: leftOffset),
                           rightAnchor.constraint(equalTo: view.rightAnchor, constant: rightOffset),
                           topAnchor.constraint(equalTo: view.topAnchor, constant: topOffset),
                           bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: bottomOffset)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    func setShadow() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 5, height: 9)
        layer.shadowOpacity = 0.2
        layer.shadowRadius = 6
    }
    
    func drawView(by corners: CornersOfView, cornersSizes: CornersSizes) -> UIBezierPath {
        let path = UIBezierPath()
        
        if corners.topLeft == TypeOfCorner.straight.rawValue {
            path.move(to: CGPoint(x: bounds.origin.x, y: bounds.origin.y))
        } else if corners.topLeft == TypeOfCorner.rounded.rawValue {
            path.move(to: CGPoint(x: bounds.origin.x, y: bounds.origin.y + cornersSizes.offset))
            path.addArc(withCenter: CGPoint(x: bounds.origin.x + cornersSizes.offset, y: bounds.origin.y + cornersSizes.offset), radius: cornersSizes.radius, startAngle: CGFloat.pi/2.0, endAngle: 3.0 * CGFloat.pi/2.0, clockwise: true)
        } else if corners.topLeft == TypeOfCorner.cutOff.rawValue {
            path.move(to: CGPoint(x: bounds.origin.x + cornersSizes.topLeftSize, y: bounds.origin.y)) // topLeft
        }
        
        if corners.topRight == TypeOfCorner.straight.rawValue {
            path.addLine(to: CGPoint(x: bounds.origin.x + bounds.width, y: bounds.origin.y))
        } else if corners.topRight == TypeOfCorner.rounded.rawValue {
            path.addLine(to: CGPoint(x: bounds.origin.x + bounds.width - cornersSizes.offset, y: bounds.origin.y))
            path.addArc(withCenter: CGPoint(x: bounds.origin.x + bounds.width - cornersSizes.offset, y: bounds.origin.y + cornersSizes.offset), radius: cornersSizes.radius, startAngle: 3 * CGFloat.pi/2.0, endAngle: 0, clockwise: true)
        } else if corners.topRight == TypeOfCorner.cutOff.rawValue {
            path.addLine(to: CGPoint(x: bounds.origin.x + bounds.width - cornersSizes.topRightSize, y: bounds.origin.y))
            path.addLine(to: CGPoint(x: bounds.origin.x + bounds.width, y: bounds.origin.y + cornersSizes.topRightSize)) //topRight
        }
        
        if corners.bottomRight == TypeOfCorner.straight.rawValue {
            path.addLine(to: CGPoint(x: bounds.origin.x + bounds.width, y: bounds.origin.y + bounds.height))
        } else if corners.bottomRight == TypeOfCorner.rounded.rawValue {
            path.addLine(to: CGPoint(x: bounds.origin.x + bounds.width, y: bounds.origin.y + bounds.height - cornersSizes.offset))
            path.addArc(withCenter: CGPoint(x: bounds.origin.x + bounds.width - cornersSizes.offset, y: bounds.origin.y + bounds.height - cornersSizes.offset), radius: cornersSizes.radius, startAngle: 0, endAngle: CGFloat.pi/2.0, clockwise: true)
        } else if corners.bottomRight == TypeOfCorner.cutOff.rawValue {
            path.addLine(to: CGPoint(x: bounds.origin.x + bounds.width, y: bounds.origin.y + bounds.height - cornersSizes.bottomRightSize))
            path.addLine(to: CGPoint(x: bounds.origin.x + bounds.width - cornersSizes.bottomRightSize, y: bounds.origin.y + bounds.height)) // bottomRight
        }
        
        if corners.bottomLeft == TypeOfCorner.straight.rawValue {
            path.addLine(to: CGPoint(x: bounds.origin.x, y: bounds.origin.y + bounds.height))
            path.addLine(to: CGPoint(x: bounds.origin.x, y: bounds.origin.y))
        } else if corners.bottomLeft == TypeOfCorner.rounded.rawValue {
            path.addLine(to: CGPoint(x: bounds.origin.x + cornersSizes.offset, y: bounds.origin.y + bounds.height)) //bottom left corner
            path.addArc(withCenter: CGPoint(x: bounds.origin.x + cornersSizes.offset, y: bounds.origin.y + bounds.height - cornersSizes.offset), radius: cornersSizes.radius, startAngle: CGFloat.pi/2.0, endAngle: CGFloat.pi, clockwise: true)
            path.addLine(to: CGPoint(x: bounds.origin.x, y: bounds.origin.y + cornersSizes.offset))
        } else if corners.bottomLeft == TypeOfCorner.cutOff.rawValue {
            path.addLine(to: CGPoint(x: bounds.origin.x + cornersSizes.bottomLeftSize, y: bounds.origin.y + bounds.height))
            path.addLine(to: CGPoint(x: bounds.origin.x, y: bounds.origin.y + bounds.height - cornersSizes.bottomLeftSize)) //bottomLeft
            path.addLine(to: CGPoint(x: bounds.origin.x, y: bounds.origin.y + cornersSizes.topLeftSize)) //connect bottomTop left
        }
        
        path.close()
        return path
    }
}

//MARK: CGPoint+Additions
extension CGPoint {
    func normalizedDistanceForSize(_ size: CGSize) -> CGPoint {
        // multiplies by 2 because coordinate system is (-1,1)
        let x = 2 * (self.x / size.width)
        let y = 2 * (self.y / size.height)
        return CGPoint(x: x, y: y)
    }
    
    func distanceTo(_ point: CGPoint) -> CGFloat {
        return sqrt(pow(point.x - self.x, 2) + pow(point.y - self.y, 2))
    }
    
    func scalarProjectionPointWith(_ point: CGPoint) -> CGPoint {
        let r = scalarProjectionWith(point) / point.modulo
        return CGPoint(x: point.x * r, y: point.y * r)
    }
    
    func scalarProjectionWith(_ point: CGPoint) -> CGFloat {
        return dotProductWith(point) / point.modulo
    }
    
    func dotProductWith(_ point: CGPoint) -> CGFloat {
        return (self.x * point.x) + (self.y * point.y)
    }
    
    var modulo: CGFloat {
        return sqrt(self.x*self.x + self.y*self.y)
    }
    
    func screenPointForSize(_ screenSize: CGSize) -> CGPoint {
        let x = 0.5 * (1 + self.x) * screenSize.width
        let y = 0.5 * (1 + self.y) * screenSize.height
        return CGPoint(x: x, y: y)
    }
}


