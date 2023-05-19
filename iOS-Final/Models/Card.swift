//
//  Card.swift
//  iOS-Final
//
//  Created by Alikhan Gubayev on 19.05.2023.
//

import UIKit

class Card {
    var id: String
    var isShown: Bool
    var image: UIImage
    
    init(card: Card) {
        self.id = card.id
        self.isShown = card.isShown
        self.image = card.image
    }
    
    init(image: UIImage) {
        self.id = UUID().uuidString
        self.isShown = false
        self.image = image
    }
    
    func equals(_ card: Card) -> Bool {
        return card.id == id
    }
    
    func copy() -> Card {
        return Card(card: self)
    }
}
