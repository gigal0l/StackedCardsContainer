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
    @objc optional func didBeginSwipe(card: CardView, index: Int)
    @objc func didEndSwipe(card: CardView, index: Int)
    @objc func change(state: Bool, cardView: CardView)
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

    @objc open var offset: CGPoint = CGPoint(x: 0, y: 0)
    @objc public let horizontalInset: CGFloat = 12.0
    @objc public let verticalInset: CGFloat = 15.0
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
    
    open func reloadItemAtIndex(_ index: Int) {
        guard let dataSource = dataSource else { return }
        let views = visibleCardsViews
        if index < views.count {
            let cardView = views[index]
            cardView.removeFromSuperview()
            addCardView(cardView: dataSource.card(forItemAtIndex: index), atIndex: index)
            setNeedsLayout()
        }
    }
    
    open func getCurrentIndex() -> Int {
        guard let cardView = subviews.last as? CardView else { return 0 }
        if let dataSource = dataSource,
            let index = cardsViews.firstIndex(of: cardView) {
            let newIndex = index % dataSource.numberOfCards()
            return newIndex
        }
        return 0
    }
    
    private func addCardView(cardView: CardView, atIndex index: Int) {
        cardView.delegate = self
        cardsViews.append(cardView)
        insertSubview(cardView, at: 0)
        remainingCards -= 1
        setFrame(forCardView: cardView, atIndex: index)
        layoutIfNeeded()
    }
    
    private func removeAllCardViews() {
        visibleCardsViews.forEach({ $0.removeFromSuperview() })
        cardsViews = []
    }
    
    private func setFrame(forCardView cardView: CardView, atIndex index: Int, isEndSwipe: Bool = false) {
        let newWidth = bounds.size.width
        let newHeight = bounds.size.height
        let newBounds = CGRect(x: offset.x, y: offset.y, width: newWidth, height: newHeight)
        var cardViewFrame = newBounds
        let horizontalInset = CGFloat(index) * self.horizontalInset
        let verticalInset = CGFloat(index) * self.verticalInset

        cardViewFrame.origin.y -= verticalInset
        
        cardView.frame = cardViewFrame
        cardView.setShadow()

        if visibleCardsViews.count >= 0 {
            visibleCardsViews.reversed().first?.setupGestureRecognizers(enablePan: dataSource?.numberOfCards() ?? 0 > 0)
        }
    }
}

extension CardsViewContainer: BaseViewDelegate {
    public func showCurrect(view: BaseView) {
        if let cardView = view as? CardView,
            let dataSource = dataSource,
            let index = cardsViews.firstIndex(of: cardView) {
            let newIndex = index % dataSource.numberOfCards()
        }
    }
    
    public func didTap(view: BaseView) {
        guard let dataSource = dataSource, let cardView = view as? CardView else { return }
        guard let index = cardsViews.firstIndex(of: cardView) else { return }
        let currentIndex = index % dataSource.numberOfCards()
        delegate?.didSelect(card: cardView, atIndex: currentIndex)
    }
    
    public func didBeginSwipe(onView view: BaseView) {
    }
    
    public func didEndSwipe(onView view: BaseView) {
        guard let dataSource = dataSource, let cardView = view as? CardView else { return }
        guard let index = cardsViews.firstIndex(of: cardView) else { return }
        let currentIndex = index % dataSource.numberOfCards()
        delegate?.didEndSwipe(card: cardView, index: currentIndex)
        
        // Remove swiped card
        view.removeFromSuperview()
        
        let reversedCards = visibleCardsViews.reversed()

        if remainingCards > 0 {
            // Calculate new card's index
            newIndex = dataSource.numberOfCards() - remainingCards
            // Add new card as Subview
            addCardView(cardView: dataSource.card(forItemAtIndex: newIndex), atIndex: reversedCards.count <= 1 ? 1 : 2)
            // Update all existing card's frames based on new indexes, animate frame change
            // to reveal new card from underneath the stack of existing cards.
        }
        UIView.animate(withDuration: 0.2, animations: {
            for (cardIndex, cardView) in reversedCards.enumerated() {
                view.center = self.center
                self.setFrame(forCardView: cardView, atIndex: cardIndex)
            }
        }, completion: { (completed) in
            self.layoutIfNeeded()
        })
        
        if reversedCards.count != 0 {
            if let currentCardView = reversedCards.first {
                delegate?.change(state: !currentCardView.limitView.isHidden, cardView: currentCardView)
            }
        }
    }
}
