//
//  MainViewController.swift
//  iOS-Final
//
//  Created by Alikhan Gubayev on 19.05.2023.
//

import UIKit

class MainViewController: UIViewController {
    
    // MARK: - Properties
    var game = MemoryGame()
    var cards: [Card] = []
    let sectionInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    
    // MARK: - Outlets
    private var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        return cv
    } ()
    
    private lazy var playButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Play", for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        btn.backgroundColor = Colors.buttonBackground
        btn.layer.cornerRadius = 16
        return btn
    } ()
    
    private var startGameLabel: UILabel = {
        let label = UILabel()
        label.textColor = Colors.buttonBackground
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 28, weight: .bold)
        label.text = "Welcome to the Game\nto play press 'Play' button"
        label.numberOfLines = 2
        return label
    } ()
    
    private var reloadButton = CustomActionButton(icon: "arrow.clockwise.circle")
    private var shuffleButton = CustomActionButton(icon: "shuffle.circle")
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setActions()
        setUI()

        self.game.delegate = self
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isHidden = true
        collectionView.register(CardCell.self, forCellWithReuseIdentifier: CardCell.cellIdentifier)
        
        if collectionView.isHidden {
            startGameLabel.isHidden = false
        }
        
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
    func setActions() {
        self.playButton.addTarget(self, action: #selector(handlePlayButton), for: .touchUpInside)
        
        self.reloadButton.addTarget(self, action: #selector(handleReloadButton), for: .touchUpInside)
        
        self.shuffleButton.addTarget(self, action: #selector(handleShuffleButton), for: .touchUpInside)
    }
    
    @objc private func handlePlayButton() {
        collectionView.isHidden = false
        startGameLabel.isHidden = true
    }
    
    @objc private func handleReloadButton() {
        reloadGame()
    }
    
    @objc private func handleShuffleButton() {
        shuffleGame()
    }
    
    // MARK: - UI
    func setUI() {
        self.view.backgroundColor = Colors.mainBackground
        [startGameLabel, playButton, reloadButton, shuffleButton, collectionView].forEach { self.view.addSubview($0) }
        
        playButton.anchor(right: self.view.rightAnchor, bottom: self.view.bottomAnchor, left: self.view.leftAnchor, paddingRight: 90, paddingBottom: 44, paddingLeft: 90)
        
        reloadButton.setDimensions(width: 32, height: 32)
        reloadButton.anchor(right: playButton.leftAnchor, bottom: self.view.bottomAnchor, paddingRight: 32, paddingBottom: 44)
        
        shuffleButton.setDimensions(width: 32, height: 32)
        shuffleButton.anchor(bottom: self.view.bottomAnchor, left: playButton.rightAnchor, paddingBottom: 44, paddingLeft: 32)
        
        collectionView.anchor(top: self.view.topAnchor, right: self.view.rightAnchor, bottom: playButton.topAnchor, left: self.view.leftAnchor, paddingBottom: 16)
        
        startGameLabel.centerInView(in: self.view)
    }
    
    func shuffleGame() {
        UIView.animate(withDuration: 0.5, animations: { [weak self] in
            guard let self = self else { return }
            self.collectionView.alpha = 0.0
        }) { [weak self] (_) in
            guard let self = self else { return }
            cards = game.startNewGame(cardsArray: self.cards)
            collectionView.reloadData()
            
            UIView.animate(withDuration: 0.3, animations: {
                self.collectionView.alpha = 1.0
            })
        }
    }

    func reloadGame() {
        UIView.animate(withDuration: 0.5, animations: { [weak self] in
            guard let self = self else { return }
            self.collectionView.alpha = 0.0
        }) { [weak self] (_) in
            guard let self = self else { return }
            cards = game.startNewGame(cardsArray: self.cards)
            collectionView.reloadData()
            
            UIView.animate(withDuration: 0.8, animations: {
                self.collectionView.alpha = 1.0
            })
        }
    }
}

extension MainViewController: MemoryGameProtocol {
    
    func memoryGameDidStart(_ game: MemoryGame) {
        collectionView.reloadData()
    }
    
    func memoryGameDidEnd(_ game: MemoryGame) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            let alertController = UIAlertController(title: "Good Job!", message: "Want to play again?", preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "No", style: .cancel) { [weak self] action in
                self?.collectionView.isHidden = true
                self?.startGameLabel.isHidden = false
            }
            
            let playAgainAction = UIAlertAction(title: "Yes", style: .default) { [weak self] action in
                self?.resetGame()
            }
            
            alertController.addAction(cancelAction)
            alertController.addAction(playAgainAction)
            
            self.present(alertController, animated: true)
            self.resetGame()
        }
    }
    
    func memoryGame(_ game: MemoryGame, showCards: [Card]) {
        for card in showCards {
            guard let index = game.getIndexForCard(card) else { continue }
            let cell = collectionView.cellForItem(at: IndexPath(item: index, section: 0)) as! CardCell
            cell.showCard(true, animated: true)
        }
    }
    
    func memoryGame(_ game: MemoryGame, hideCards: [Card]) {
        for card in hideCards {
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
