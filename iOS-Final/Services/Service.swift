//
//  Service.swift
//  iOS-Final
//
//  Created by Alikhan Gubayev on 19.05.2023.
//

import UIKit

enum CustomErrors: LocalizedError {
    case empty
}

class Service {
    static let shared = Service()
    
    static var defaultCardImages: [UIImage] = [
        UIImage(named: "1")!,
        UIImage(named: "2")!,
        UIImage(named: "3")!,
        UIImage(named: "4")!,
        UIImage(named: "5")!,
        UIImage(named: "6")!,
        UIImage(named: "7")!,
        UIImage(named: "8")!,
    ]
    
    public func getCardImages(completion: (Result<[Card], Error>) -> Void) {
        var cards = [Card]()
        let cardImages = Service.defaultCardImages
        
        for image in cardImages {
            let card = Card(image: image)
            let copy = card.copy()
            
            cards.append(card)
            cards.append(copy)
        }
        
        if !cards.isEmpty {
            completion(.success(cards))
        } else {
            completion(.failure(CustomErrors.empty))
        }
    }
}
