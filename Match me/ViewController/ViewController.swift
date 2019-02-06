//
//  ViewController.swift
//  Match me
//
//  Created by MSadri on 1/24/19.
//  Copyright © 2019 MSadri. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var selectedCardNumber  : Int = 0
    
    @IBOutlet weak var levelDefinerOutlet: UISlider!
    
    @IBAction func levelDefinerAction(_ sender: UISlider) {
        let newLevel = Int(levelDefinerOutlet.value * 4 + 4.49)
        if abs(newLevel - DataManager.sharedObject.gameLevel) > 0 {
            DataManager.sharedObject.gameLevel = newLevel
            print("Game Level is: \(DataManager.sharedObject.gameLevel)")
            myCollection.scrollToItem(at: IndexPath.init(item: 0, section: 0), at: UICollectionView.ScrollPosition.left, animated: true)
            myCollection.reloadData()
        }
    }
    
    @IBAction func startGameButton(_ sender: UIButton) {
        for i in 1...DataManager.sharedObject.startingCards.count-1 {
            for j in 0...i-1 {
                if DataManager.sharedObject.startingCards[i].imageOfCard == DataManager.sharedObject.startingCards[j].imageOfCard {
                    print("Change photo of card no. \(i) or \(j)")
                }
            }
        }
        DataManager.sharedObject.setGameCards()
        let gamingPage = storyboard?.instantiateViewController(withIdentifier: "gamingPage") as! GamingPageViewController
        self.navigationController?.pushViewController(gamingPage, animated: true)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return DataManager.sharedObject.gameLevel
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedCardNumber = indexPath.item
        let pickerPage = UIImagePickerController()
        pickerPage.delegate = self
        pickerPage.sourceType = .savedPhotosAlbum
        self.present(pickerPage, animated: true) {
            //
        }
        
    }
    var imageOne : UIImage!
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let pickedimage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        DataManager.sharedObject.startingCards[selectedCardNumber].imageOfCard = pickedimage
        DataManager.sharedObject.startingCards[selectedCardNumber].isImageSet = true
        picker.dismiss(animated: true) {
            self.myCollection.reloadData()
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = myCollection.dequeueReusableCell(withReuseIdentifier: "myCell", for: indexPath) as! MyCollectionViewCell
        cell.cardImage.layer.cornerRadius = 10
        cell.cardImage.layer.masksToBounds = true
        //fetch cell Data:
        cell.cardImage.image = DataManager.sharedObject.startingCards[indexPath.item].imageOfCard
        cell.selecPhotoLabel.isHidden = DataManager.sharedObject.startingCards[indexPath.item].isImageSet
        
        //fetch cell Data  -X
        
        cell.cardNumber.image = UIImage(named: "\(indexPath.item + 1)")
        cell.backgroundColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0)
        return cell
    }
    
    

    @IBOutlet weak var myCollection: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        levelDefinerOutlet.setValue(1, animated: true)
        
        //collectionView Setting
        myCollection.dataSource = self
        myCollection.delegate = self
        if let layout = myCollection.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
        }
        myCollection.backgroundColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0)
        //COllectionView Setting -X
        
        var arrayToEnsureProduceUnicNumbers = ["0", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13"]
        for thisCard in 0...7 {
            let randomNumber = Int.random(in: 0 ... arrayToEnsureProduceUnicNumbers.count-1)
            let deletedPart = arrayToEnsureProduceUnicNumbers.remove(at: randomNumber)
            DataManager.sharedObject.startingCards[thisCard].imageOfCard = UIImage(named: "card" + deletedPart)!
        }
        myCollection.reloadData()
        
    }


}

/*
 TODO List:
 
     - High:
     - Change collectionView Of first page with what is used in musicApp
     - A big Auto Hide Label on main page to show the current level*/
    ///- Done: Define loose strategy: 1.Time out
    ///- Done: Define win strategy: 1.Finish cards
    ///- Done: check if all cards are not setted, set them randomly by the app*/
    ///- Done: define a greate algorythm to calculate the score :
            ///- time  - how many time show a card  - chance
    ///- Done: Impliment atAGlance func to show to the user all cards at first step: redirect user to the bottom of list and when he get in touch to the top of list, game starts automatically
    /*
    - Add allert to start button to allert the user that how many cars are selected automatically*/
    ///-  Done:Impliment the timer in the game board page
    /*- prevent user to start with same pictures and if there is a same alert him to change it*/
    ///- Done :AutoRotate the last two ones
    /*- Add Custom popUp library to show scores
    - Add playAgainButton
 
 - Medium:
    - setUp default images for each card at first step
    - replace "selectPhoto" button with a glassy one
    - Add sounds : -flip -win -end (loose or win)
 
 
 - Low:
    - Check is there two cards same as each others
    - Start to rotate others one by one when timer is 0

 */

