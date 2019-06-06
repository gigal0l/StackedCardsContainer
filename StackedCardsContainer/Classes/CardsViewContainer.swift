//
//  CardsViewContainer.swift
//  CardsView
//
//  Created by Андрей Зубехин on 18/03/2019.
//  Copyright © 2019 Андрей Зубехин. All rights reserved.
//

import UIKit

@objc public protocol CardViewDelegate {
    @objc func didSelect(card: CardView, atIndex index: Int)
    @objc func didBeginSwipe(card: CardView, index: Int)
    @objc func didEndSwipe(card: CardView, index: Int)
}

@objc public protocol CardViewDataSource {
    @objc func numberOfCards() -> Int
    @objc func card(forItemAtIndex index: Int) -> CardView
}

@objcMembers
open class CardsViewContainer: UIView {
    
    open weak var dataSource: CardViewDataSource? {
        didSet {
            reloadData()
        }
    }
    
    open weak var delegate: CardViewDelegate?

    @objc open var offset: CGPoint = CGPoint(x: 20, y: 30)
    @objc public let horizontalInset: CGFloat = 12.0
    @objc public let verticalInset: CGFloat = 12.0
    @objc public let numberOfVisibleCards: Int = 3
    
    @objc open var cardsViews = [CardView]()
    @objc open var visibleCardsViews: [CardView] {
        return subviews as? [CardView] ?? []
    }
    
    fileprivate var remainingCards = 0
    fileprivate var newIndex = 0
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .clear
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    /// Reloads the data used to layout card views in the
    /// card stack. Removes all existing card views and
    /// calls the dataSource to layout new card views.
    open func reloadData() {
        removeAllCardViews()
        guard let dataSource = dataSource else { return }
        
        let numberOfCards = dataSource.numberOfCards()
        remainingCards = numberOfCards
        
        for index in 0..<min(numberOfCards, numberOfVisibleCards) {
            addCardView(cardView: dataSource.card(forItemAtIndex: index), atIndex: index)
        }
        setNeedsLayout()
    }
    
    private func addCardView(cardView: CardView, atIndex index: Int) {
        cardView.delegate = self
        setFrame(forCardView: cardView, atIndex: index)
        layoutIfNeeded()
        cardsViews.append(cardView)
        insertSubview(cardView, at: 0)
        remainingCards -= 1
    }
    
    private func removeAllCardViews() {
        visibleCardsViews.forEach({ $0.removeFromSuperview() })
        cardsViews = []
    }
    
    private func setFrame(forCardView cardView: CardView, atIndex index: Int, isEndSwipe: Bool = false) {
        let newWidth = bounds.size.width * 0.8
        let newHeight = bounds.size.height * 0.8
        let newBounds = CGRect(x: offset.x, y: offset.y, width: newWidth, height: newHeight)
        var cardViewFrame = newBounds
        let horizontalInset = CGFloat(index) * self.horizontalInset
        let verticalInset = CGFloat(index) * self.verticalInset
        
        cardViewFrame.size.width -= 2 * horizontalInset
        cardViewFrame.size.height -= 2 * verticalInset
        cardViewFrame.origin.x += 2 * horizontalInset
        cardViewFrame.origin.y -= verticalInset
        
        cardView.frame = cardViewFrame
        cardView.setShadow()
        
        if visibleCardsViews.count >= 1 {
            visibleCardsViews.reversed().first?.setupGestureRecognizers()
        }
    }
}

extension CardsViewContainer: BaseViewDelegate {
    public func didTap(view: BaseView) {
        if let cardView = view as? CardView,
            let dataSource = dataSource,
            let index = cardsViews.firstIndex(of: cardView) {
            let newIndex = index % dataSource.numberOfCards()
            delegate?.didSelect(card: cardView, atIndex: newIndex)
        }
    }
    
    public func didBeginSwipe(onView view: BaseView) {
        if let cardView = view as? CardView,
            let dataSource = dataSource,
            let index = cardsViews.firstIndex(of: cardView) {
            let newIndex = index % dataSource.numberOfCards()
            delegate?.didBeginSwipe(card: cardView, index: newIndex)
        }
    }
    
    public func didEndSwipe(onView view: BaseView) {
        guard let dataSource = dataSource, let cardView = view as? CardView else { return }
        if let index = cardsViews.firstIndex(of: cardView) {
            let newIndex = index % dataSource.numberOfCards()
            delegate?.didEndSwipe(card: cardView, index: newIndex)
        }
        
        // Remove swiped card
        view.removeFromSuperview()
        
        let reversedCards = visibleCardsViews.reversed()

        //for loop
        if remainingCards == 0 {
            remainingCards = dataSource.numberOfCards()
        }
        
        // Calculate new card's index
        newIndex = dataSource.numberOfCards() - remainingCards

        // Add new card as Subview
        addCardView(cardView: remainingCards == 0 ? cardView : dataSource.card(forItemAtIndex: newIndex), atIndex: reversedCards.count <= 1 ? 1 : 2)

        // Update all existing card's frames based on new indexes, animate frame change
        // to reveal new card from underneath the stack of existing cards.
        UIView.animate(withDuration: 0.2, animations: {
            for (cardIndex, cardView) in reversedCards.enumerated() {
                view.center = self.center
                self.setFrame(forCardView: cardView, atIndex: cardIndex)
            }
        }, completion: { (completed) in
            self.layoutIfNeeded()
        })
    }
}
