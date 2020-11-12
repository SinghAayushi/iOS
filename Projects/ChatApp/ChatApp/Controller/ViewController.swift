//
//  ViewController.swift
//  ChatApp
//
//  Created by aayushisingh on 15/10/20.
//  Copyright © 2020 aayushisingh. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func loginButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "welcomeToLogin", sender: self)
    }
    
    @IBAction func RegisterButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "welcomeToRegister", sender: self)
    }
}

