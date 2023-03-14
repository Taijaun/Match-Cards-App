//
//  ViewController.swift
//  MatchApp
//
//  Created by Taijaun Pitt on 28/02/2023.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var timerLabel: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    
    let model = CardModel()
    var cardsArray = [Card]()
    
    var timer: Timer?
    var milliseconds: Int = 10 * 1000
    
    // Keep track of the first flipped card
    var firstFlippedCardIndex: IndexPath?
    
    var soundPlayer: SoundManager = SoundManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        cardsArray = model.getCards()
        
        // set the view controller as the datasource and delegate for the collection view
        collectionView.dataSource = self
        // when user taps on cell, they tell the delegate, which tells the collection view to handle some action
        collectionView.delegate = self
        
        // Initialize the timer
        timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(timerFired), userInfo: nil, repeats: true)
        RunLoop.main.add(timer!, forMode: .common)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // Play shuffle sound
        soundPlayer.playSound(effect: .shuffle)
        
    }
    
    // MARK: - Timer Methods
    
    @objc func timerFired() {
        
        // Decrement the counter
        milliseconds -= 1
        
        // Update the label
        let seconds: Double = Double(milliseconds)/1000.0
        timerLabel.text = String(format: "Time Remaining: %.2f", seconds)
        
        // Stop the timer if it reachers zero
        if milliseconds == 0 {
            timerLabel.textColor = UIColor.red
            timer?.invalidate()
            // TODO: check if the user has cleared all the pairs
            
            checkForGameEnd()
        }

    }
    
    
    
    // MARK: - Collection View Delegate Methods
    
    // DataSource protocol methods
    
    // Display the number of cards that we choose
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        // In this case just return the amount of cards within the cardsArray
        return cardsArray.count
    }
    
    
    
    // indexpath.row actually refers to the number of the cell not the actual row
    // create cellm configure it and give it to collection view to display
    // returns collection view
    // what type of cell are we using?
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // Get a Cell
        // looks for cell that is no longer on screen to reuse it
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as! CardCollectionViewCell
        
                // Return it
        return cell
    }
    
    // configure cell before it gets displayed
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        let cardCell = cell as? CardCollectionViewCell
        
        // Configure the state of the cell based on the properties of the Card that it represents
        // get the card from the card array (row is the cell)
        let card = cardsArray[indexPath.row]
        
        // Finish configuring cell
        cardCell?.configureCell(card: card)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // Check if there is time remaining, dont let user interact if there is not
        if milliseconds <= 0 {
            return
        }
        
        // Get a reference to the cell that was tapped
        let cell = collectionView.cellForItem(at: indexPath) as? CardCollectionViewCell
        
        
        // Check the status of the card to determine how to flip it
        if cell?.card?.isFlipped == false && cell?.card?.isMatched == false {
            
            // flip the card up
            cell?.flipUp()
            
            // Play sound
            soundPlayer.playSound(effect: .flip)
            
            // Check if this is the first card that was flipped or the second card
            if firstFlippedCardIndex == nil {
                // this is the first card flipped over
                
                firstFlippedCardIndex = indexPath
                
            } else {
                // this is the second card
                
                // run the comparison logic
                checkForMatch(indexPath)
            }
        }
    }
    
    // MARK: - Game Logic Methods
    
    func checkForMatch(_ secondFlippedCardIndex: IndexPath) {
        // Get the two card objects for the two indices and see if they match
        
        let cardOne = cardsArray[firstFlippedCardIndex!.row]
        let cardTwo = cardsArray[secondFlippedCardIndex.row]
        
        // get the two collection view cells that represent card one and two
        // return as cardcollectionview cell
        let cardOneCell = collectionView.cellForItem(at: firstFlippedCardIndex!) as? CardCollectionViewCell
        let cardTwoCell = collectionView.cellForItem(at: secondFlippedCardIndex) as? CardCollectionViewCell
        
        // comparew the two
        if cardOne.imageName == cardTwo.imageName {
            // its a match
            
            // Play match sound
            soundPlayer.playSound(effect: .match)
            
            // set the status and remove them
            cardOne.isMatched = true
            cardTwo.isMatched = true
            
            cardOneCell?.remove()
            cardTwoCell?.remove()
            
            
        } else {
            
            // not a match
            
            // Play nomatch sound
            soundPlayer.playSound(effect: .nomatch)
            
            // flip them back over
            cardOneCell?.flipDown()
            cardTwoCell?.flipDown()
            cardOne.isFlipped = false
            cardTwo.isFlipped = false
            
            // Was that the last pair?
            checkForGameEnd()
        }
        
        // reset the firstFlippedCardIndex property
        firstFlippedCardIndex = nil
    }
    
    func checkForGameEnd() {
        
        // Chek if there is any card that is unmatched
        //assume the user has won, loop through all the cards to see if all of them are matched
        var hasWon = true
        
        for card in cardsArray {
            if card.isMatched == false {
                // Found a card that is unmatched
                hasWon = false
                break
            }
        }
        
        if hasWon {
            
            // User has won, show an alert
            showAlert(title: "Congratulations!", message: "You've won the game!")
            
        } else {
            
            // User has not won yet, check if there's any time left, if not, show an alert
            if milliseconds <= 0 {
                showAlert(title: "Time's Up", message: "Sorry, better luck next time!")
            }
            
        }
        
    }
    
    func showAlert(title: String, message: String) {
        
        // Create the alert
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        // Add a button for the user to dismiss the alert
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        
        alert.addAction(okAction)
        
        // Show the alert
        present(alert, animated: true)
        
    }


}

