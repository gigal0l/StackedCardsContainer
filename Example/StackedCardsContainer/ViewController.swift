//
//  ViewController.swift
//  StackedCardsContainer
//
//  Created by vlz1996@mail.ru on 03/22/2019.
//  Copyright (c) 2019 vlz1996@mail.ru. All rights reserved.
//

import UIKit
import StackedCardsContainer

class ViewController: UIViewController {
    
    @IBOutlet var cardsViewContainer: CardsViewContainer!
    
    let colorArray = [UIColor.red, UIColor.green, UIColor.blue]
    var imageArray: [UIImage] = [UIImage(named: "image1")!, UIImage(named: "image2")!, UIImage(named: "image3")!]
    //, UIColor.black, UIColor.orange, UIColor.gray, UIColor.brown, UIColor.darkGray
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cardsViewContainer.setNeedsLayout()
        cardsViewContainer.layoutIfNeeded()
        cardsViewContainer.dataSource = self
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(5)) {
            self.imageArray.reverse()
            self.cardsViewContainer.reloadData()
        }
    }
}

extension ViewController: CardViewDataSource {
    func numberOfCards() -> Int {
        return colorArray.count
    }
    
    func card(forItemAtIndex index: Int) -> CardView {
        var corners = CornersOfView()
        corners.topLeft = 2
        corners.topRight = 1
        corners.bottomRight = 0
        corners.bottomLeft = 2
        var cornersSizes = CornersSizes()
        cornersSizes.topRightSize = 70
        cornersSizes.bottomRightSize = 30
        cornersSizes.bottomLeftSize = 20
        cornersSizes.topLeftSize = 70
        cornersSizes.offset = 10
        cornersSizes.radius = 10
        cardsViewContainer.offset = CGPoint(x: 60, y: 70)
        let color = colorArray[index]
        let image = imageArray[index]
        let view = UIView()
        view.backgroundColor = .clear
        let cardView = CardView(frame: CGRect(x: 0, y: 0, width: cardsViewContainer.bounds.width - 50, height: cardsViewContainer.bounds.height - 10), color: color, customView: view, image: image, corners: corners, cornersSize: cornersSizes)
        return cardView
    }
}

