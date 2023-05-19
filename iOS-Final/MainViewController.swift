//
//  MainViewController.swift
//  iOS-Final
//
//  Created by Alikhan Gubayev on 19.05.2023.
//

import UIKit

class MainViewController: UIViewController {
    
    // MARK: - Properties
    var count = 0
    var game = MemoryGame()
    var cards = [Card]()
    let sectionInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    
    // MARK: - Outlets
    private let collectionView: UICollectionView = {
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewLayout.init())
        cv.backgroundColor = .red
        return cv
    } ()
    
    private let playButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Play", for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        btn.backgroundColor = Colors.buttonBackground
        btn.layer.cornerRadius = 16
        return btn
    } ()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setActions()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isHidden = true
        
        game.delegate = self
        
        collectionView.register(CardCell.self, forCellWithReuseIdentifier: CardCell.cellIdentifier)
        getCards()
    }
    
    // MARK: Methods
    
    func getCards() {
        Service.shared.getCardImages { [weak self] result in
            switch result {
            case .success(let cards):
                self?.cards = cards
                self?.startGame()
            case .failure(let failure):
                print("\(failure)")
            }
        }
    }
    
    func startGame() {
        cards = game.startNewGame(cardsArray: self.cards)
        collectionView.reloadData()
    }
    
    func resetGame() {
        game.restartGame()
        startGame()
    }
    
    // MARK: - Actions
    private func setActions() {
        self.playButton.addTarget(self, action: #selector(handlePlayButton), for: .touchUpInside)
    }
    
    @objc private func handlePlayButton() {
        collectionView.isHidden = false
        count = 0
    }
    
    // MARK: - UI
    private func setUI() {
        self.view.backgroundColor = Colors.mainBackground
        [playButton, collectionView].forEach { self.view.addSubview($0) }
        
        playButton.anchor(right: self.view.rightAnchor, bottom: self.view.bottomAnchor, left: self.view.leftAnchor, paddingRight: 64, paddingBottom: 100, paddingLeft: 64)
        collectionView.anchor(top: self.view.topAnchor, right: self.view.rightAnchor, bottom: playButton.topAnchor, left: self.view.leftAnchor, paddingTop: 56, paddingBottom: 16)
    }
}

extension MainViewController: MemoryGameProtocol {
    
    func memoryGameDidStart(_ game: MemoryGame) {
        collectionView.reloadData()
    }
    
    func memoryGameDidEnd(_ game: MemoryGame) {
        let alertController = UIAlertController(title: "Good Job!", message: "Want to play again?", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "No", style: .cancel) { [weak self] action in
            self?.collectionView.isHidden = true
        }
        
        let playAgainAction = UIAlertAction(title: "Yes", style: .default) { [weak self] action in
            self?.collectionView.isHidden = true
            self?.resetGame()
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(playAgainAction)
        
        self.present(alertController, animated: true)
        resetGame()
    }
    
    func memoryGame(_ game: MemoryGame, showCards: [Card]) {
        for card in cards {
            guard let index = game.getIndexForCard(card) else { continue }
            let cell = collectionView.cellForItem(at: IndexPath(item: index, section: 0)) as! CardCell
            cell.showCard(true, animated: true)
        }
    }
    
    func memoryGame(_ game: MemoryGame, hideCards: [Card]) {
        for card in cards {
            guard let index = game.getIndexForCard(card) else { continue }
            let cell = collectionView.cellForItem(at: IndexPath(item: index, section: 0)) as! CardCell
            cell.showCard(false, animated: true)
        }
    }
}

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cards.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CardCell.cellIdentifier, for: indexPath) as? CardCell else {
            return UICollectionViewCell()
        }
        cell.showCard(false, animated: false)
        
        guard let card = game.getCardAtIndex(indexPath.item) else { return cell }
        cell.card = card
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! CardCell
        
        if cell.isShown { return }
        game.didSelectCard(cell.card)
        
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}

extension MainViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = Int(sectionInsets.left) * 4
        let availableWidth = Int(view.frame.width) - paddingSpace
        let widthPerItem = availableWidth / 4
        
        return CGSize(width: widthPerItem, height: widthPerItem + (widthPerItem / 2))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.top
    }
}
