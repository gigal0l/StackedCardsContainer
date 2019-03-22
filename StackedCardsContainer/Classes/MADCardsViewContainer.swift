//
//  MADCardsViewContainer.swift
//  CardsView
//
//  Created by Андрей Зубехин on 18/03/2019.
//  Copyright © 2019 Андрей Зубехин. All rights reserved.
//

import UIKit

protocol MADCardViewDelegate: class {
    func didSelect(card: MADCardView, atIndex index: Int)
    func didBeginSwipe(card: MADCardView, index: Int)
    func didEndSwipe(card: MADCardView, index: Int)
}

protocol MADCardViewDataSource: class {
    func numberOfCards() -> Int
    func card(forItemAtIndex index: Int) -> MADCardView
    func viewForEmptyCards() -> UIView?
}

open class MADCardsViewContainer: UIView {
    fileprivate struct Constants {
        static let horizontalInset: CGFloat = 12.0
        static let verticalInset: CGFloat = 12.0
        static let numberOfVisibleCards: Int = 3
    }
    
    weak var dataSource: MADCardViewDataSource? {
        didSet {
            reloadData()
        }
    }
    
    weak var delegate: MADCardViewDelegate?
    
    private var cardsViews = [MADCardView]()
    private var visibleCardsViews: [MADCardView] {
        return subviews as? [MADCardView] ?? []
    }
    
    fileprivate var remainingCards = 0
    fileprivate var cardsViewIndex = 0
    fileprivate var lastCardsView = [MADCardView]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .clear
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    /// Reloads the data used to layout card views in the
    /// card stack. Removes all existing card views and
    /// calls the dataSource to layout new card views.
    func reloadData() {
        removeAllCardViews()
        guard let dataSource = dataSource else { return }
        
        let numberOfCards = dataSource.numberOfCards()
        remainingCards = numberOfCards
        
        for index in 0..<min(numberOfCards, Constants.numberOfVisibleCards) {
            addCardView(cardView: dataSource.card(forItemAtIndex: index), atIndex: index)
        }
        if let emptyView = dataSource.viewForEmptyCards() {
            addSubview(emptyView)
            addEdgeConstrainedSubView(view: emptyView)
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
        let newBounds = CGRect(x: 20, y: 30, width: newWidth, height: newHeight)
        var cardViewFrame = newBounds
        let horizontalInset = (CGFloat(index) * Constants.horizontalInset)
        let verticalInset = CGFloat(index) * Constants.verticalInset
        
        cardViewFrame.size.width -= 2 * horizontalInset
        cardViewFrame.origin.x += 2 * horizontalInset
        cardViewFrame.origin.y -= verticalInset
        
        cardView.frame = cardViewFrame
        cardView.setShadow()
    }
}

extension MADCardsViewContainer: MADViewDelegate {
    func didTap(view: MADView) {
        if let cardView = view as? MADCardView,
            let index = cardsViews.index(of: cardView) {
            delegate?.didSelect(card: cardView, atIndex: index)
        }
    }
    
    func didBeginSwipe(onView view: MADView) {
        if let cardView = view as? MADCardView,
            let index = cardsViews.index(of: cardView) {
            delegate?.didBeginSwipe(card: cardView, index: index)
        }
    }
    
    func didEndSwipe(onView view: MADView) {
        if let cardView = view as? MADCardView,
            let index = cardsViews.index(of: cardView) {
            delegate?.didEndSwipe(card: cardView, index: index)
        }
        guard let dataSource = dataSource else { return }
        // Remove swiped card
        view.removeFromSuperview()
        let reversedCards = visibleCardsViews.reversed()

        // Only add a new card if there are cards remaining
        if remainingCards > 0 {
            
            // Calculate new card's index
            let newIndex = dataSource.numberOfCards() - remainingCards

            // Add new card as Subview
            addCardView(cardView: dataSource.card(forItemAtIndex: newIndex), atIndex: 2)
        }
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
