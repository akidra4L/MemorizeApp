//
//  MemoryGame.swift
//  iOS-Final
//
//  Created by Alikhan Gubayev on 19.05.2023.
//

import UIKit

protocol MemoryGameProtocol {
    func memoryGameDidStart(_ game: MemoryGame)
    func memoryGameDidEnd(_ game: MemoryGame)
    func memoryGame(_ game: MemoryGame, showCards: [Card])
    func memoryGame(_ game: MemoryGame, hideCards: [Card])
}

class MemoryGame {
    
    // MARK: - Properties
    var delegate: MemoryGameProtocol?
    var cards: [Card] = [Card]()
    var cardsShown: [Card] = [Card]()
    var isPlaying: Bool = false
    
    // MARK: - Methods
    func startNewGame(cardsArray: [Card]) -> [Card] {
        cards = getShuffledCards(cards: cardsArray)
        isPlaying = true
        
        delegate?.memoryGameDidStart(self)
        
        return cards
    }
    
    func restartGame() {
        isPlaying = false
        cards.removeAll()
        cardsShown.removeAll()
    }
    
    func endGame() {
        isPlaying = false
        delegate?.memoryGameDidEnd(self)
    }
    
    func getCardAtIndex(_ index: Int) -> Card? {
        return cards.count > index ? cards[index] : nil
    }
    
    func getIndexForCard(_ card: Card) -> Int? {
        for index in 0...cards.count - 1 {
            if card === cards[index] {
                return index
            }
        }
        return nil
    }
    
    func didSelectCard(_ card: Card?) {
        guard let card = card else { return }
        
        delegate?.memoryGame(self, showCards: [card])
        
        if getUnmatchedCardsShown() {
            let unmatchedCard = getUnmatchedCard()!
            
            if card.equals(unmatchedCard) {
                cardsShown.append(card)
            } else {
                let secondCard = cardsShown.removeLast()
                
                let delay = DispatchTime.now() + 1.0
                
                DispatchQueue.main.asyncAfter(deadline: delay) {
                    self.delegate?.memoryGame(self, hideCards: [card, secondCard])
                }
            }
        } else {
            cardsShown.append(card)
        }
        
        if cardsShown.count == cards.count {
            endGame()
        }
    }
    
    func getUnmatchedCardsShown() -> Bool {
        return cardsShown.count % 2 != 0
    }
    
    func getUnmatchedCard() -> Card? {
        return cardsShown.last
    }
    
    func getShuffledCards(cards: [Card]) -> [Card] {
        return cards.shuffled()
    }
}
