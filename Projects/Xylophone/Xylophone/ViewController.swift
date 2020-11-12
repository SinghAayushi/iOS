//
//  ViewController.swift
//  Xylophone
//
//  Created by aayushisingh on 02/10/20.
//  Copyright © 2020 aayushisingh. All rights reserved.
//

import UIKit
import AVFoundation


class ViewController: UIViewController {
    var player: AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


    @IBAction func playNote(_ sender: UIButton){
        let url = Bundle.main.url(forResource: "note1", withExtension: "wav")!
       do {
        player = try AVAudioPlayer(contentsOf: url)
        guard let player = player else { return }
        
        player.prepareToPlay()
            player.play()
       } catch let error as NSError{
           print ("error  \(error)")
       }
    }
}

