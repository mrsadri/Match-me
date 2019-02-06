//
//  cardModel.swift
//  Match me
//
//  Created by MSadri on 1/24/19.
//  Copyright © 2019 MSadri. All rights reserved.
//

import Foundation
import UIKit

struct CardModel {
    
    var imageOfCard     : UIImage   = UIImage(named: "Card Simple BG" )!
    var isImageSet      : Bool      = false
    var cardNumber      : Int       = 0
    var isDepricated    : Bool      = false
    var shownTime       : Int       = 0
    var isShown         : Bool      = false {
        willSet(value){
            if value {
            shownTime += 1
            }
        }
    }
    var thisView        : GameCardCollectionViewCell = GameCardCollectionViewCell()
}
