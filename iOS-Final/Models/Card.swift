//
//  Card.swift
//  iOS-Final
//
//  Created by Alikhan Gubayev on 19.05.2023.
//

import UIKit

class Card {
    public var id: String
    public var isShown: Bool
    public var image: UIImage
    
    public init(card: Card) {
        self.id = card.id
        self.isShown = card.isShown
        self.image = card.image
    }
    
    public init(image: UIImage) {
        self.id = UUID().uuidString
        self.isShown = false
        self.image = image
    }
    
    public func equals(_ card: Card) -> Bool {
        return card.id == id
    }
    
    public func copy() -> Card {
        return Card(card: self)
    }
}
