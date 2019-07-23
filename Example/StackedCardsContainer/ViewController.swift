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
        cardsViewContainer.delegate = self
    }
}

extension ViewController: CardViewDataSource {
    func numberOfCards() -> Int {
        return colorArray.count
    }
    
    func card(forItemAtIndex index: Int) -> CardView {
        let corners = Corners(topLeft: .straight, topRight: .rounded, bottomRight: .straight, bottomLeft: .cutOff)
        let cornersSizes = CornersSizes(topLeftCutOff: 70, topRightCutOff: 70, bottomLeftCutOff: 20, bottomRightCutOff: 30, offset: 10, radius: 10)
        cardsViewContainer.offset = CGPoint(x: 60, y: 70)
        let color = colorArray[index]
        let image = imageArray[index]
        let view = UIView()
        view.backgroundColor = .clear
        let cardView = CardView(frame: CGRect(x: 0, y: 0, width: cardsViewContainer.bounds.width - 50, height: cardsViewContainer.bounds.height - 10), color: color, customView: view, image: image, corners: corners, cornersSize: cornersSizes)
        return cardView
    }
    
    
}

extension ViewController: CardViewDelegate {
    func didBeginSwipe(card: CardView, index: Int) {
    }
    
    func didEndSwipe(card: CardView, index: Int) {
    }
    
    func didSelect(card: CardView, atIndex index: Int) {
    }
    
}

