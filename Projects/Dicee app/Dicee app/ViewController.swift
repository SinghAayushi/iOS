//
//  ViewController.swift
//  Dicee app
//
//  Created by aayushisingh on 25/09/20.
//  Copyright © 2020 aayushisingh. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var diceOneIndex:Int = 0
    var diceTwoIndex:Int = 0
    let diceArray = ["One", "Two", "Three", "four", "Five", "Six"]
    
    @IBOutlet weak var dice1: UIImageView!
    @IBOutlet weak var dice2: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateDiceImages()
        // Do any additional setup after loading the view.
    }

    @IBAction func rollButton(_ sender: UIButton) {
        updateDiceImages()
    }
    
    func updateDiceImages(){
        diceOneIndex = Int (arc4random_uniform(5))
        diceTwoIndex = Int (arc4random_uniform(5))
        
        dice1.image = UIImage(named: diceArray[diceOneIndex])
        dice2.image = UIImage(named: diceArray[diceTwoIndex])
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        updateDiceImages()
    }
}

