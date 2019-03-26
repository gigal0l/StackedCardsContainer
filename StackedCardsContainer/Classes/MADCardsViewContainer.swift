//
//  MADCardsViewContainer.swift
//  CardsView
//
//  Created by Андрей Зубехин on 18/03/2019.
//  Copyright © 2019 Андрей Зубехин. All rights reserved.
//

import UIKit

public protocol MADCardViewDelegate: class {
    func didSelect(card: MADCardView, atIndex index: Int)
    func didBeginSwipe(card: MADCardView, index: Int)
    func didEndSwipe(card: MADCardView, index: Int)
}

public protocol MADCardViewDataSource: class {
    func numberOfCards() -> Int
    func card(forItemAtIndex index: Int) -> MADCardView
    func viewForEmptyCards() -> UIView?
}

public class MADCardsViewContainer: UIView {
    fileprivate struct Constants {
        static let horizontalInset: CGFloat = 12.0
        static let verticalInset: CGFloat = 12.0
        static let numberOfVisibleCards: Int = 3
    }
    
    open weak var dataSource: MADCardViewDataSource? {
        didSet {
            reloadData()
        }
    }
    
    public weak var delegate: MADCardViewDelegate?
    
    public var cardsViews = [MADCardView]()
    public var visibleCardsViews: [MADCardView] {
        return subviews as? [MADCardView] ?? []
    }
    
    fileprivate var remainingCards = 0
    var newIndex = 0
    public var offset: CGPoint = CGPoint(x: 20, y: 30)
    
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
        
        for index in 0..<min(numberOfCards, Constants.numberOfVisibleCards) {
            addCardView(cardView: dataSource.card(forItemAtIndex: index), atIndex: index)
        }
        setNeedsLayout()
    }
    
    private func addCardView(cardView: MADCardView, atIndex index: Int) {
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
    
    private func setFrame(forCardView cardView: MADCardView, atIndex index: Int, isEndSwipe: Bool = false) {
        let newWidth = bounds.size.width * 0.8
        let newHeight = bounds.size.height * 0.8
        let newBounds = CGRect(x: offset.x, y: offset.y, width: newWidth, height: newHeight)
        var cardViewFrame = newBounds
        let horizontalInset = (CGFloat(index) * Constants.horizontalInset)
        let verticalInset = CGFloat(index) * Constants.verticalInset
        
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

extension MADCardsViewContainer: MADViewDelegate {
    public func didTap(view: MADView) {
        if let cardView = view as? MADCardView,
            let dataSource = dataSource,
            let index = cardsViews.index(of: cardView) {
            let newIndex = index  % dataSource.numberOfCards()
            print("\(newIndex)")
            delegate?.didSelect(card: cardView, atIndex: newIndex)
        }
    }
    
    public func didBeginSwipe(onView view: MADView) {
        if let cardView = view as? MADCardView,
            let dataSource = dataSource,
            let index = cardsViews.index(of: cardView) {
            let newIndex = index  % dataSource.numberOfCards()
            delegate?.didBeginSwipe(card: cardView, index: newIndex)
        }
    }
    
    public func didEndSwipe(onView view: MADView) {
        guard let dataSource = dataSource, let cardView = view as? MADCardView else { return }
        if let index = cardsViews.index(of: cardView) {
            let newIndex = index  % dataSource.numberOfCards()
            print("\(newIndex)")
//            var newCardIndex = 0
//            if index >= dataSource.numberOfCards() {
//                newCardIndex = index - (cardsViews.count - dataSource.numberOfCards())
//            }
//            print("\(index >= dataSource.numberOfCards() ? newCardIndex : index)")
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
