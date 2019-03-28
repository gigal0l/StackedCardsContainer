//
//  Corners.swift
//  StackedCardsContainer
//
//  Created by Андрей Зубехин on 28/03/2019.
//

import Foundation

/**
This struct has properties of each corner which declarate by type.
 * 0 – straight corner
 * 1 - rounded corner
 * 2 - cutOff corner
*/
public class CornersOfView {
    public var topLeft: Int = 0
    public var topRight: Int = 0
    public var bottomLeft: Int = 0
    public var bottomRight: Int = 0
    
    public init() { }
}
/**
 This struct has properties of corner's size
 */
public class CornersSizes {
    public var topLeftSize: CGFloat = 0.0
    public var topRightSize: CGFloat = 0.0
    public var bottomLeftSize: CGFloat = 0.0
    public var bottomRightSize: CGFloat = 0.0
    
    //property for acr
    public var offset: CGFloat = 0.0
    public var radius: CGFloat = 0.0
    
    public init() { }
}
