//
//  Corners.swift
//  StackedCardsContainer
//
//  Created by Андрей Зубехин on 28/03/2019.
//

import Foundation

public struct CornersOfView {
    public var topLeft: Int = 0
    public var topRight: Int = 0
    public var bottomLeft: Int = 0
    public var bottomRight: Int = 0
    
    public init() { }
}

public struct CornersSizes {
    public var topLeftSize: CGFloat = 0.0
    public var topRightSize: CGFloat = 0.0
    public var bottomLeftSize: CGFloat = 0.0
    public var bottomRightSize: CGFloat = 0.0
    
    //property for acr
    public var offset: CGFloat = 0.0
    public var radius: CGFloat = 0.0
    
    public init() { }
}
