//
//  GamingPageViewController.swift
//  Match me
//
//  Created by MSadri on 1/24/19.
//  Copyright © 2019 MSadri. All rights reserved.
//

import UIKit

class GamingPageViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var gameCollectionView: UICollectionView!
    
    var myTimer : Timer!
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("\nIIIIIIIIIIIII\nI am loading")
        return DataManager.sharedObject.gameLevel * 2
    }
    //var cellContainer = [GameCardCollectionViewCell]()
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = gameCollectionView.dequeueReusableCell(withReuseIdentifier: "gameCard", for: indexPath) as! GameCardCollectionViewCell
        cell.mainImageView.image =  DataManager.sharedObject.gameCards[indexPath.item].imageOfCard
        
        cell.backImageView.image = DataManager.sharedObject.gameCards[indexPath.item].isDepricated ? DataManager.sharedObject.gameCards[indexPath.item].imageOfCard : UIImage(named: "Card Simple BG" )!
        cell.alpha = DataManager.sharedObject.gameCards[indexPath.item].isDepricated ? 0 : 1.0
        //TODO: config the folowwing lines in cell data manager
        cell.mainImageView.layer.cornerRadius = 10
        cell.mainImageView.layer.masksToBounds = true
        
        cell.backImageView.layer.cornerRadius = 10
        cell.backImageView.layer.masksToBounds = true
        
        cell.mainImageView.isHidden = !DataManager.sharedObject.gameCards[indexPath.item].isShown
        cell.backImageView.isHidden = DataManager.sharedObject.gameCards[indexPath.item].isShown

        DataManager.sharedObject.gameCards[indexPath.item].thisView = cell
        
        return cell
    }
    //Is hiddin before rotating : Done
    //Loader defines show wich side based on isShownFlag : Done
    //Round corners : Done
    //write a function to rotate/rotateBack - this help us to lock it : No need now
    //write a func to lock/unlock the rotate func : no need now
    //writ start func : -Timer -Unlock rotate - Rotate all back
    //write a glance func
    //Move functions to the logic class
    var rotatedCards = [CardModel]() {
        didSet{
            if rotatedCards.count == 2 {
                //check match
                print("call check match")
                isLockedRotateAction = true
                self.matchCheck()
                //TODO: lock rotate action here and unlock it when the rotation is finished
                
            }
        }
    }
    
    var isLockedRotateAction : Bool = false
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if !isLockedRotateAction {
            if !DataManager.sharedObject.gameCards[indexPath.item].isDepricated {
                let cellView = DataManager.sharedObject.gameCards[indexPath.item].thisView
                let frontImageView  : UIImageView = cellView.mainImageView
                let backImageView   : UIImageView = cellView.backImageView
                
                DataManager.sharedObject.gameCards[indexPath.item].isShown = !DataManager.sharedObject.gameCards[indexPath.item].isShown
                
                if !DataManager.sharedObject.gameCards[indexPath.item].isShown {
                    //rotate back
                    UIView.transition(from: frontImageView, to: backImageView, duration: 0.5, options: [.transitionFlipFromLeft, .showHideTransitionViews] , completion: nil)
                    self.rotatedCards.removeLast()
                } else {
                    //rotate
                    UIView.transition(from: backImageView, to: frontImageView, duration: 0.5, options: [.transitionFlipFromRight, .showHideTransitionViews] ) { (state) in
                    }
                    
                    print("the \(indexPath.item)th card : No. \(DataManager.sharedObject.gameCards[indexPath.item].cardNumber) - Shown : \(DataManager.sharedObject.gameCards[indexPath.item].shownTime)")
                    
                    self.rotatedCards.append(DataManager.sharedObject.gameCards[indexPath.item])
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(DataManager.sharedObject.gameCards.count)
        DataManager.sharedObject.userCurrentScore = 0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.preSetupToStartTheGame()

    }
    
    enum TypeOfRotate {
        case rotate
        case rotateBack
    }
    
    func rotateCards(rotationType : TypeOfRotate) {
        switch rotationType {
        case .rotate:
            
            break
        case .rotateBack:
            
            break
            
        }
    }
    
    func whichCellsAreShown()       -> [Int] {
        var result : [Int] = []
        for index in 0...DataManager.sharedObject.gameCards.count - 1 {
            
            if DataManager.sharedObject.gameCards[index].isShown {
                result.append(index)
            }
        }
        return result
    }
    
    func whichCellsAreDepricated()  -> [Int] {
        var result : [Int] = []
        for index in 0...DataManager.sharedObject.gameCards.count - 1 {
            
            if DataManager.sharedObject.gameCards[index].isDepricated {
                result.append(index)
            }
        }
        return result
    }
    
    
    func doubleRotateBack() {
        /*find wich cells are shown:
         1. store their cell index to rotate them back
         2. turn of isShown flag
         */
        let whichCells = whichCellsAreShown()
        
        if whichCells.count == 2 {
            for index in whichCells {
                DataManager.sharedObject.gameCards[index].isShown = false
                
                let frontImageView  : UIImageView = DataManager.sharedObject.gameCards[index].thisView.mainImageView
                let backImageView   : UIImageView = DataManager.sharedObject.gameCards[index].thisView.backImageView
                
                self.rotatedCards.removeLast()
                //A delay
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1 ) {
                    
                    //rotate back
                    UIView.transition(from: frontImageView, to: backImageView, duration: 0.4, options: [.transitionFlipFromLeft, .showHideTransitionViews]) { (state) in
                        self.isLockedRotateAction = false
                    }
                }
            }
        }
    }
    
    func matchCheck() {
        /*
         func match Check
         1. If two cards are show this func will call automatically
         2. + Check if these two have same card number :
         2.1. claculate the score : max ((11-shownTimeFirstCard), 1) * max ((11-shownTimeFirstCard), 1) * remained seconds * remained cards
         2.2. Delete them from the board (turn on the depricated flag and add this if to loader to not show depricated cards and add this if to didSelect to do not any action on them)
         2.3 if ther is no cards, do winning alert.
         2. - if not match:
         2.4 rotate them back
         */
        var whichCells = self.whichCellsAreShown()
        
        if DataManager.sharedObject.gameCards[ whichCells[0]].cardNumber == DataManager.sharedObject.gameCards[ whichCells[1]].cardNumber {
            
            //We use isShown Cards to rotate them back in continue, so here we have to change the status of isShown to prevent its conflict
            DataManager.sharedObject.gameCards[ whichCells[0]].isShown = false
            DataManager.sharedObject.gameCards[ whichCells[1]].isShown = false
            
            //Unlock the rotate
            self.isLockedRotateAction = false
            
            //Depricate matched cards:
            DataManager.sharedObject.gameCards[ whichCells[0]].isDepricated = true
            DataManager.sharedObject.gameCards[ whichCells[1]].isDepricated = true
            
            //Clean rotatedCards array:
            self.rotatedCards = []
            
            //calculate the score:
            let thisTimeScore : Float = Float(
                max ( ( 4 - DataManager.sharedObject.gameCards[ whichCells[0]].shownTime ) , 1) *
                    max( ( 4 - DataManager.sharedObject.gameCards[ whichCells[1]].shownTime ) , 1)
                )
                * self.iSeconds / self.totalTickedTimer
            * Float( DataManager.sharedObject.gameCards.count - whichCellsAreDepricated().count )
            
            DataManager.sharedObject.userCurrentScore += thisTimeScore
            
            print("This Score: \t\(thisTimeScore)\nTotal Score: \t\(DataManager.sharedObject.userCurrentScore)")
            //-----
            
            //if there is only two cards that are not depricated rotate them and finish the game
            if DataManager.sharedObject.gameCards.count - whichCellsAreDepricated().count == 2 {
                self.lastTwoCardAutoAction { (state) in
                    print("\n\n *******************\n\tThe Game is Finished\n\n\tYour Score:\t\(DataManager.sharedObject.userCurrentScore)")
                }
            } else {
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5 ) {
                    self.gameCollectionView.reloadData()
                }
                if whichCellsAreDepricated().count == DataManager.sharedObject.gameCards.count {
                    self.myTimer.invalidate()
                    timerLabel.textColor = UIColor.green
                    timerLabel.font = UIFont.boldSystemFont(ofSize: 17)
                    timerLabel.text = "Score: \(Int(DataManager.sharedObject.userCurrentScore * 10))"
                }
            }
            
        } else {
            self.doubleRotateBack()
        }
    }
    
    
    func lastTwoCardAutoAction(complitionHandler: @escaping (String) -> Void) {

        isLockedRotateAction = true
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1 ) {
            var indexes : [Int] = []
            for i in 0...DataManager.sharedObject.gameCards.count - 1 {
                indexes.append(i)
            }
            
            let lastTwoCardsIndexes : [Int] = indexes.filter{
                !self.whichCellsAreDepricated().contains($0)
            }
            print("----")
            print(lastTwoCardsIndexes)
            DataManager.sharedObject.gameCards[lastTwoCardsIndexes[0]].isShown = true
            DataManager.sharedObject.gameCards[lastTwoCardsIndexes[1]].isShown = true

            print("the \(lastTwoCardsIndexes[0])th card : No. \(DataManager.sharedObject.gameCards[lastTwoCardsIndexes[0]].cardNumber) - Shown : \(DataManager.sharedObject.gameCards[lastTwoCardsIndexes[0]].shownTime)")
            
            print("the \(lastTwoCardsIndexes[1])th card : No. \(DataManager.sharedObject.gameCards[lastTwoCardsIndexes[1]].cardNumber) - Shown : \(DataManager.sharedObject.gameCards[lastTwoCardsIndexes[1]].shownTime)")

            //rotate
            UIView.transition(from: DataManager.sharedObject.gameCards[lastTwoCardsIndexes[0]].thisView.backImageView, to: DataManager.sharedObject.gameCards[lastTwoCardsIndexes[0]].thisView.mainImageView, duration: 0.5, options: [.transitionFlipFromRight, .showHideTransitionViews] ) { (state) in
                
                self.rotatedCards.append(DataManager.sharedObject.gameCards[lastTwoCardsIndexes[0]])

            }
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1 ) {
                
                UIView.transition(from: DataManager.sharedObject.gameCards[lastTwoCardsIndexes[1]].thisView.backImageView, to: DataManager.sharedObject.gameCards[lastTwoCardsIndexes[1]].thisView.mainImageView, duration: 0.5, options: [.transitionFlipFromRight, .showHideTransitionViews] ) { (state) in
                    
                    self.rotatedCards.append(DataManager.sharedObject.gameCards[lastTwoCardsIndexes[1]])
                    complitionHandler("Done")
                }
            }
        }
    }
    

    /*BUG:
     1.
     Problem:
     When user tapped on a card which is ready to autoRotateBack, it confiused.
     
     Solution:
     - change state of the card in complition handler
     - lock the flip func when 2 cards are shown
     
     state: SOLVED
     --
     2.
     
     */
    
    func preSetupToStartTheGame() {
        /*
         1. Lock the rotate
         2. Rotate all cards
         3. Conduct user to the end of the list
         4. Conduct user to the top of the list
         5. Start the game after a short while
            5.1. Enable the timerLabel
            5.2. Unlock the flip Action
            5.3. Start the timer
         */
        //1.
        isLockedRotateAction = true
        
        //2,3,4.
        {
            //2. Show cards:
            for i in 0...DataManager.sharedObject.gameCards.count-1 {
                DataManager.sharedObject.gameCards[i].isShown = true
            }
            gameCollectionView.reloadData()
            
            //3.1. Go to bottom:
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1 ) {
                self.gameCollectionView.scrollToItem(at: IndexPath(item: DataManager.sharedObject.gameCards.count - 1, section: 0), at: UICollectionView.ScrollPosition.bottom, animated: true)
                
                //4. Go to Top:
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2 ) {
                    self.gameCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: UICollectionView.ScrollPosition.top, animated: true)
                    
                    //5. Hide cards and start game after a short while:
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 4, execute: {
                        //TODO: Define a Timer here to show it on page
                        for i in 0...DataManager.sharedObject.gameCards.count-1 {
                            DataManager.sharedObject.gameCards[i].isShown = false
                        }
                        self.gameCollectionView.reloadData()
                        
                        //5.1
                        self.timerLabel.isHidden = false
                        
                        //5.2
                        self.isLockedRotateAction = false
                       
                        //5.3.
                        self.myTimer = Timer.scheduledTimer(timeInterval: 1 / 5 , target: self, selector: #selector(self.timerElapsed), userInfo: nil, repeats: true)
                        
                    })
                }
            }
        }()
    }
    
    var totalTickedTimer : Float = Float(( ( DataManager.sharedObject.gameCards.count + 2 ) * 3 )  * 5)
    var iSeconds : Float = Float( DataManager.sharedObject.gameLevel * (DataManager.sharedObject.gameLevel - 1) * 5 ) + 5
    
    @objc func timerElapsed () {
        iSeconds -= 1
        //print(iSeconds)
        let seconds = String (format: "%.2f", iSeconds/5)
        timerLabel.text = "Time Remaining: \t\(seconds)"
        
        //When the timer has reached the 0...
        if iSeconds <= 0 {
            myTimer?.invalidate()
            timerLabel.textColor = UIColor.red
            timerLabel.font = UIFont.boldSystemFont(ofSize: 17)
            timerLabel.text = "Score: \(Int(DataManager.sharedObject.userCurrentScore * 10))"
            //TODO: change the text of label to win/loos state based on checking is remained any unmatched card or not.
            //TODO: Show the score
        }
    }
}
