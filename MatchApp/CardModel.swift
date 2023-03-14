import Foundation

class CardModel {
    
    func getCards() -> [Card] {
        
        // Declare an empty array to store numbers that we've generated
        var generatedNumbers = [Int]()
        
        // Declare an empty array to store the cards
        var generatedCards = [Card]()
        
        // Randomly generate 8 pairs of cards
        while generatedNumbers.count < 8 {
            
            // Generate a random number
            let randomNumber = Int.random(in: 1...13)
            
            if generatedNumbers.contains(randomNumber) == false {
                
                
                
                // Create the first card object
                let cardOne = Card()
                cardOne.imageName = "card\(randomNumber)"
                
                // Create the second card object
                let cardTwo = Card()
                cardTwo.imageName = "card\(randomNumber)"
                
                // add the created cards to the array
                generatedCards += [cardOne, cardTwo]
                
                // add this number to the list of generated numbers
                generatedNumbers.append(randomNumber)
                
                
                print(randomNumber)
            }
        }
        // Randomize the cards within the array
        generatedCards.shuffle()
        
        // Return the array
        return generatedCards

    }
    
}
