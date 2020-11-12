//
//  ViewController.swift
//  MagicEightBalls
//
//  Created by aayushisingh on 30/09/20.
//  Copyright © 2020 aayushisingh. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let answersAray = ["ball1", "ball2", "ball3", "ball4", "ball5"]
    var buttonRandomVal:Int=0;
    
    @IBOutlet weak var ballImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


    @IBAction func askButtonClick(_ sender: UIButton) {
        buttonRandomVal = Int(arc4random_uniform(5))
        
        ballImage.image = UIImage(named: answersAray[buttonRandomVal])
    }
}

