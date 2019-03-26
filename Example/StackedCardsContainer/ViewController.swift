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
    
    @IBOutlet var cardsViewContainer: MADCardsViewContainer!
    
    let colorArray = [UIColor.red, UIColor.green, UIColor.blue]
    let imageArray: [UIImage] = [UIImage(named: "image1")!, UIImage(named: "image2")!, UIImage(named: "image3")!]
    //, UIColor.black, UIColor.orange, UIColor.gray, UIColor.brown, UIColor.darkGray
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cardsViewContainer.setNeedsLayout()
        cardsViewContainer.layoutIfNeeded()
        cardsViewContainer.dataSource = self
    }
}

extension ViewController: MADCardViewDataSource {
    func numberOfCards() -> Int {
        return colorArray.count
    }
    
    func card(forItemAtIndex index: Int) -> MADCardView {
        cardsViewContainer.offset = CGPoint(x: 60, y: 70)
        let color = colorArray[index]
        let image = imageArray[index]
        let view = UIView()
        view.backgroundColor = .clear
        let cardView = MADCardView(frame: CGRect(x: 0, y: 0, width: cardsViewContainer.bounds.width - 50, height: cardsViewContainer.bounds.height - 10), color: color, customView: view, image: image)
        return cardView
    }
    
    func viewForEmptyCards() -> UIView? {
        return nil
    }
}

