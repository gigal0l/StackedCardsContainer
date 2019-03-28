//
//  MADCardView.swift
//  CardsView
//
//  Created by Андрей Зубехин on 18/03/2019.
//  Copyright © 2019 Андрей Зубехин. All rights reserved.
//

import UIKit

public class CardView: BaseView {
    
    open var customView: UIView!
    open var color: UIColor!
    open var image: UIImage?
    //help
    open var corners: Corners!
    open var cornersSize: CornersSizes!
    
    public init(frame: CGRect, color: UIColor, customView: UIView, image: UIImage? = nil, corners: Corners, cornersSize: CornersSizes) {
        self.color = color
        self.customView = customView
        self.image = image
        self.corners = corners
        self.cornersSize = cornersSize
        super.init(frame: frame)
        setUp()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUp()
    }
    
    open override func draw(_ rect: CGRect) {
        
        let path = drawView(by: corners, cornersSizes: cornersSize)
        
        // fill the path
        if let image = image {
            let fill = UIColor(patternImage: image.resizeImage(CGSize(width: bounds.width, height: bounds.height)))
            fill.set()
        } else {
            color.set()
        }
        path.fill()
    }
    
    private func setUp() {
        addSubview(customView)
        customView.pin(to: self, leftOffset: 10, rightOffset: -50, topOffset: 10, bottomOffset: -10)
        backgroundColor = .clear
    }
    
    private func drawView(by corners: Corners, cornersSizes: CornersSizes) -> UIBezierPath {
        let path = UIBezierPath()
        
        if corners.topLeft == CornerType.straight {
            path.move(to: CGPoint(x: bounds.origin.x, y: bounds.origin.y))
        } else if corners.topLeft == CornerType.rounded {
            path.move(to: CGPoint(x: bounds.origin.x, y: bounds.origin.y + cornersSizes.offset))
            path.addArc(withCenter: CGPoint(x: bounds.origin.x + cornersSizes.offset, y: bounds.origin.y + cornersSizes.offset), radius: cornersSizes.radius, startAngle: CGFloat.pi/2.0, endAngle: 3.0 * CGFloat.pi/2.0, clockwise: true)
        } else if corners.topLeft == CornerType.cutOff {
            path.move(to: CGPoint(x: bounds.origin.x + cornersSizes.topLeftCutOff, y: bounds.origin.y)) // topLeft
        }
        
        if corners.topRight == CornerType.straight {
            path.addLine(to: CGPoint(x: bounds.origin.x + bounds.width, y: bounds.origin.y))
        } else if corners.topRight == CornerType.rounded {
            path.addLine(to: CGPoint(x: bounds.origin.x + bounds.width - cornersSizes.offset, y: bounds.origin.y))
            path.addArc(withCenter: CGPoint(x: bounds.origin.x + bounds.width - cornersSizes.offset, y: bounds.origin.y + cornersSizes.offset), radius: cornersSizes.radius, startAngle: 3 * CGFloat.pi/2.0, endAngle: 0, clockwise: true)
        } else if corners.topRight == CornerType.cutOff {
            path.addLine(to: CGPoint(x: bounds.origin.x + bounds.width - cornersSizes.topRightCutOff, y: bounds.origin.y))
            path.addLine(to: CGPoint(x: bounds.origin.x + bounds.width, y: bounds.origin.y + cornersSizes.topRightCutOff)) //topRight
        }
        
        if corners.bottomRight == CornerType.straight {
            path.addLine(to: CGPoint(x: bounds.origin.x + bounds.width, y: bounds.origin.y + bounds.height))
        } else if corners.bottomRight == CornerType.rounded {
            path.addLine(to: CGPoint(x: bounds.origin.x + bounds.width, y: bounds.origin.y + bounds.height - cornersSizes.offset))
            path.addArc(withCenter: CGPoint(x: bounds.origin.x + bounds.width - cornersSizes.offset, y: bounds.origin.y + bounds.height - cornersSizes.offset), radius: cornersSizes.radius, startAngle: 0, endAngle: CGFloat.pi/2.0, clockwise: true)
        } else if corners.bottomRight == CornerType.cutOff {
            path.addLine(to: CGPoint(x: bounds.origin.x + bounds.width, y: bounds.origin.y + bounds.height - cornersSizes.bottomRightCutOff))
            path.addLine(to: CGPoint(x: bounds.origin.x + bounds.width - cornersSizes.bottomRightCutOff, y: bounds.origin.y + bounds.height)) // bottomRight
        }
        
        if corners.bottomLeft == CornerType.straight {
            path.addLine(to: CGPoint(x: bounds.origin.x, y: bounds.origin.y + bounds.height))
            path.addLine(to: CGPoint(x: bounds.origin.x, y: bounds.origin.y))
        } else if corners.bottomLeft == CornerType.rounded {
            path.addLine(to: CGPoint(x: bounds.origin.x + cornersSizes.offset, y: bounds.origin.y + bounds.height)) //bottom left corner
            path.addArc(withCenter: CGPoint(x: bounds.origin.x + cornersSizes.offset, y: bounds.origin.y + bounds.height - cornersSizes.offset), radius: cornersSizes.radius, startAngle: CGFloat.pi/2.0, endAngle: CGFloat.pi, clockwise: true)
            path.addLine(to: CGPoint(x: bounds.origin.x, y: bounds.origin.y + cornersSizes.offset))
        } else if corners.bottomLeft == CornerType.cutOff {
            path.addLine(to: CGPoint(x: bounds.origin.x + cornersSizes.bottomLeftCutOff, y: bounds.origin.y + bounds.height))
            path.addLine(to: CGPoint(x: bounds.origin.x, y: bounds.origin.y + bounds.height - cornersSizes.bottomLeftCutOff)) //bottomLeft
            path.addLine(to: CGPoint(x: bounds.origin.x, y: bounds.origin.y + cornersSizes.topLeftCutOff)) //connect bottomTop left
        }
        
        path.close()
        return path
    }
}

extension UIImage {
    final func resizeImage(_ size: CGSize) -> UIImage {
        var scaledImageRect = CGRect.zero
        
        let aspectWidth:CGFloat = size.width / self.size.width
        let aspectHeight:CGFloat = size.height / self.size.height
        
        //max - scaleAspectFill | min - scaleAspectFit
        let aspectRatio:CGFloat = max(aspectWidth, aspectHeight)
        
        scaledImageRect.size.width = self.size.width * aspectRatio
        scaledImageRect.size.height = self.size.height * aspectRatio
        scaledImageRect.origin.x = (size.width - scaledImageRect.size.width) / 2.0
        scaledImageRect.origin.y = (size.height - scaledImageRect.size.height) / 2.0
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        
        self.draw(in: scaledImageRect)
        
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return scaledImage!
    }
}
