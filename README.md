# StackedCardsContainer

[![CI Status](https://img.shields.io/travis/vlz1996@mail.ru/StackedCardsContainer.svg?style=flat)](https://travis-ci.org/vlz1996@mail.ru/StackedCardsContainer)
[![Version](https://img.shields.io/cocoapods/v/StackedCardsContainer.svg?style=flat)](https://cocoapods.org/pods/StackedCardsContainer)
[![License](https://img.shields.io/cocoapods/l/StackedCardsContainer.svg?style=flat)](https://cocoapods.org/pods/StackedCardsContainer)
[![Platform](https://img.shields.io/cocoapods/p/StackedCardsContainer.svg?style=flat)](https://cocoapods.org/pods/StackedCardsContainer)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Installation

StackedCardsContainer is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'StackedCardsContainer'
```
## Getting start guide
- For first, inherit from class 'CardsViewContainer':
```swift
    class CardsContainer: CardsViewContainer! 
    { ... }
```
or create UIView in storyboard and set custom view 'CardsViewContainer'

![StackedCardsContainer customClassScreenShot](https://snag.gy/LH8cR4.jpg)

- Don't forget to set the delegate & datasource class;

```swift
    cardsViewContainer.dataSource = self
    cardsViewContainer.delegate = self
```

- I have prepared the parameters so that you can customize the cards at your wish:
  - public var offset: CGPoint –– property for change start point of the card;
  - public let horizontalInset: CGFloat & public let verticalInset: CGFloat –– these are for horizontal and vertical position changes;
  - public let numberOfVisibleCards: Int –– property for set a number of visible cards in container;
   
```swift
    cardsViewContainer.offset = CGPoint(x: 20, y: 30)
    cardsViewContainer.horizontalInset: CGFloat = 22.0
    cardsViewContainer.verticalInset: CGFloat = 22.0
    cardsViewContainer.numberOfVisibleCards: Int = 3
``` 

4. The example of initialization of card. You can set custom view, background image of the card. Use support structs (Corners, CornersSizes) to set type of corner and size of cut-off corner.

```swift
    func card(forItemAtIndex index: Int) -> CardView {
        let corners = Corners(topLeft: .straight, topRight: .rounded, bottomRight: .straight, bottomLeft: .cutOff)
        let cornersSizes = CornersSizes(topLeftCutOff: 70, topRightCutOff: 70, bottomLeftCutOff: 20, bottomRightCutOff: 30, offset: 10, radius: 10)
        cardsViewContainer.offset = CGPoint(x: 60, y: 70)
        let color = colorArray[index]
        let view = UIView()
        view.backgroundColor = .clear
        let cardView = CardView(frame: CGRect(x: 0, y: 0, width: cardsViewContainer.bounds.width - 50, height: cardsViewContainer.bounds.height - 10), color: color, customView: view, corners: corners, cornersSize: cornersSizes)
        return cardView
    }
``` 

## Author

andrew@wearemad.ru

## License

StackedCardsContainer is available under the MIT license. See the LICENSE file for more info.
# StackedCardsContainer
