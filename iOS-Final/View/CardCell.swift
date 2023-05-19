//
//  CardCell.swift
//  iOS-Final
//
//  Created by Alikhan Gubayev on 19.05.2023.
//

import UIKit

class CardCell: UICollectionViewCell {
    
    // MARK: - Properties
    static let cellIdentifier = "CardCell"
    
    var card: Card? {
        didSet {
            guard let card = card else { return }
            frontImageView.image = card.image
            
            frontImageView.layer.cornerRadius = 5.0
            backImageView.layer.cornerRadius = 5.0
            
            frontImageView.layer.masksToBounds = true
            backImageView.layer.masksToBounds = true
        }
    }
    
    var isShown: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Outlets
    let frontImageView: UIImageView = {
        let fiv = UIImageView()
        fiv.contentMode = .scaleAspectFit
        return fiv
    } ()
    
    let backImageView: UIImageView = {
        let fiv = UIImageView()
        fiv.contentMode = .scaleAspectFit
        return fiv
    } ()
    
    // MARK: - UI
    func setUI() {
        [backImageView, frontImageView].forEach { self.addSubview($0) }
        
        [backImageView, frontImageView].forEach { $0.fillView(self) }
    }
    
    func showCard(_ isShow: Bool, animated: Bool) {
        frontImageView.isHidden = false
        backImageView.isHidden = false
        isShown = isShow
        if animated {
            if isShow {
                UIView.transition(from: backImageView,
                                  to: frontImageView,
                                  duration: 0.5,
                                  options: [.transitionFlipFromRight, .showHideTransitionViews]) { (finished: Bool) -> Void in }
            } else {
                UIView.transition(from: frontImageView,
                                  to: backImageView,
                                  duration: 0.5,
                                  options: [.transitionFlipFromRight, .showHideTransitionViews]) { (finished: Bool) -> Void in }
            }
        } else {
            if isShow {
                bringSubviewToFront(frontImageView)
                backImageView.isHidden = true
            } else {
                bringSubviewToFront(backImageView)
                frontImageView.isHidden = true
            }
        }

    }
}
