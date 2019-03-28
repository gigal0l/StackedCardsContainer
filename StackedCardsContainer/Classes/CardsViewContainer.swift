//
//  CardsViewContainer.swift
//  CardsView
//
//  Created by Андрей Зубехин on 18/03/2019.
//  Copyright © 2019 Андрей Зубехин. All rights reserved.
//

import UIKit

public protocol CardViewDelegate: class {
    func didSelect(card: CardView, atIndex index: Int)
    func didBeginSwipe(card: CardView, index: Int)
    func didEndSwipe(card: CardView, index: Int)
}

public protocol CardViewDataSource: class {
    func numberOfCards() -> Int
    func card(forItemAtIndex index: Int) -> CardView
}

public class CardsViewContainer: UIView {
    
    open weak var dataSource: CardViewDataSource? {
        didSet {
            reloadData()
        }
    }
    
    public weak var delegate: CardViewDelegate?

    public var offset: CGPoint = CGPoint(x: 20, y: 30)
    public let horizontalInset: CGFloat = 12.0
    public let verticalInset: CGFloat = 12.0
    public let numberOfVisibleCards: Int = 3
    public var cardsViews = [CardView]()
    public var visibleCardsViews: [CardView] {
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
            let index = cardsViews.index(of: cardView) {
            let newIndex = index % dataSource.numberOfCards()
            delegate?.didSelect(card: cardView, atIndex: newIndex)
        }
    }
    
    public func didBeginSwipe(onView view: BaseView) {
        if let cardView = view as? CardView,
            let dataSource = dataSource,
            let index = cardsViews.index(of: cardView) {
            let newIndex = index % dataSource.numberOfCards()
            delegate?.didBeginSwipe(card: cardView, index: newIndex)
        }
    }
    
    public func didEndSwipe(onView view: BaseView) {
        guard let dataSource = dataSource, let cardView = view as? CardView else { return }
        if let index = cardsViews.index(of: cardView) {
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
        for (cardIndex, cardView) in reversedCards.enumerated() {
            UIView.animate(withDuration: 0.2, animations: {
                view.center = self.center
                self.setFrame(forCardView: cardView, atIndex: cardIndex)
                self.layoutIfNeeded()
            })
        }
    }
}
