//
//  ChatWindowViewController.swift
//  ChatApp
//
//  Created by aayushisingh on 16/10/20.
//  Copyright © 2020 aayushisingh. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import ChameleonFramework

class ChatWindowViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    @IBOutlet weak var chatTableView: UITableView!
    @IBOutlet weak var messageTypingAreaHeight: NSLayoutConstraint!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var messageTypingBox: UITextField!
    var messageArray: [MessageData] = [MessageData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        messageTypingBox.delegate = self
        chatTableView.delegate = self
        chatTableView.dataSource = self
        //tap gesture recogniser
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(callOnTapGesture))
        chatTableView.addGestureRecognizer(tapGesture)
        
        chatTableView.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "TableViewMessageCell")
        configureChatFunctionality()
        retrieveMessage()
        
        chatTableView.separatorStyle = .none
        
    }
    
    @IBAction func logOutPressed(_ sender: UIBarButtonItem) {
        do{
            try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
        }catch {
            print ("error, sgnout has some error")
        }
    }
    
    //MARK Table view delegate functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageArray.count
     }
     
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewMessageCell", for: indexPath) as! TableViewMessageCellClass
        
        cell.completeMessageView.layer.cornerRadius = 10
        cell.messageLabel.text = "";
        cell.messageLabel.text = messageArray[indexPath.row].message
        cell.userNameLabel.text = messageArray[indexPath.row].senderEmail
        cell.cellImageView.image = UIImage(named: "blueChatICon")
        cell.completeMessageView.backgroundColor = UIColor.flatBlue()
        
        if cell.userNameLabel.text == Auth.auth().currentUser?.email as String? {
            cell.cellImageView.image = UIImage(named: "greenChatIcon")
            cell.completeMessageView.backgroundColor = UIColor.flatGray()
           
        }
        
        return cell 
     }
    
    func configureChatFunctionality() {
        chatTableView.estimatedRowHeight = 120
        self.chatTableView.rowHeight =  UITableView.automaticDimension;
    }
    
    //MARK: - send messages through firebase
    @IBAction func sendButtonPressed(_ sender: UIButton) {
        callOnTapGesture()
        messageTypingBox.isEnabled = false
        sendButton.isEnabled = false
        
        
        let messagesDatabase = Database.database().reference().child("Messages")
        let messageData = ["Sender" : Auth.auth().currentUser?.email, "body" : messageTypingBox.text!]
        
        messagesDatabase.childByAutoId().setValue(messageData){
            (error, reference) in
            if error != nil {
                print (error!)
            } else {
                print("message saved in the database")
                self.messageTypingBox.text = ""
                self.messageTypingBox.isEnabled = true
                self.sendButton.isEnabled = true
            }
        }
        
    }
    
    //MARK: - Retrieve messages
    func retrieveMessage(){
        let messageDatabase = Database.database().reference().child("Messages")
        messageDatabase.observe(.childAdded) { (dataSnapshot) in
            let dataSnapshotValue = dataSnapshot.value as! Dictionary<String, String>
            let sender = dataSnapshotValue["Sender"]!
            let message = dataSnapshotValue["body"]!
            
            print(sender)
            print(message)
            
            let messageModel = MessageData()
            messageModel.message = message
            messageModel.senderEmail = sender
            self.messageArray.append(messageModel)
            
            self.configureChatFunctionality()
            self.chatTableView.reloadData()
        }
    }
    
    //MARK: text field delegate methods
    func textFieldDidBeginEditing(_ textField: UITextField) {
       
        UIView.animate(withDuration: 0.3) {
            self.messageTypingAreaHeight.constant = 322
            self.view.layoutIfNeeded()
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
      UIView.animate(withDuration: 0.5) {
          self.messageTypingAreaHeight.constant = 60
          self.view.layoutIfNeeded()
      }
    }
    
    //Tap gesture recognizer for tableview
    @objc func callOnTapGesture() {
        messageTypingBox.endEditing(true)
    }
}
