//
//  LoginViewController.swift
//  ChatApp
//
//  Created by aayushisingh on 16/10/20.
//  Copyright © 2020 aayushisingh. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class LoginViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordTextfield.isSecureTextEntry = true
    }
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        //SVProgressHUD.show()
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextfield.text!, completion:{(result, error) in
            
            if error != nil {
                print ("login error :: \(String(describing: error))")
            }else{
               // SVProgressHUD.dismiss()
                self.performSegue(withIdentifier: "loginToChat", sender: self)
            }
        })
    }
}
