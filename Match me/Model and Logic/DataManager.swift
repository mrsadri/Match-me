//
//  DataManager.swift
//  Match me
//
//  Created by MSadri on 1/24/19.
//  Copyright © 2019 MSadri. All rights reserved.
//

import Foundation
import UIKit

class DataManager {
    
    var startingCards = [CardModel]() {
        didSet {
            //TODO: writ it to PList
        }
    }
    var userCurrentScore : Float = 0
    var gameLevel           : Int = 8
    var gameCards = [CardModel]()
    
    static let sharedObject = DataManager()
    
    private init() {
        //fetch from plist, if there is no plist:
        for index in 0...7 {
            var newCard = CardModel()
            newCard.cardNumber = index
            startingCards.append(newCard)
        }
        
        setGameCards()
    }
    
    
    func setGameCards() {
        gameCards = [] //startingCards + startingCards
        
        for i in 0...gameLevel-1 {
            gameCards.append(startingCards[i])
            gameCards.append(startingCards[i])
        }
        
        for _ in 0...startingCards.count - 1 {
            
            let randomNumberFirst   = Int.random(in: 0 ... gameCards.count-1)
            let randomNumberSeccond = Int.random(in: 0 ... gameCards.count-1)
            
            let keepCardToChangeIt : CardModel = gameCards[randomNumberFirst]
            gameCards[randomNumberFirst] = gameCards[randomNumberSeccond]
            gameCards[randomNumberSeccond] = keepCardToChangeIt
            
        }
        var arrayOfCardNumbers : [Int] = []
        for index in 0...gameCards.count - 1 {
            arrayOfCardNumbers.append(gameCards[index].cardNumber)
        }
        print("This is of array card numbers: \(arrayOfCardNumbers)")
    }
}
