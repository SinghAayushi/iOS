//
//  RegisterViewController.swift
//  ChatApp
//
//  Created by aayushisingh on 16/10/20.
//  Copyright © 2020 aayushisingh. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class RegisterViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func registerButtonPressed(_ sender: UIButton) {
        Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
            
            if error != nil {
                print (error.debugDescription)
            } else {
                print ("registraion successful")
                self.performSegue(withIdentifier: "registerToChat", sender: self)
            }
        }
    }
}
