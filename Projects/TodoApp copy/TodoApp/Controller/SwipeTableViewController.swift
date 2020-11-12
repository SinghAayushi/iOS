//
//  SwipeTableViewCell.swift
//  TodoApp
//
//  Created by aayushisingh on 30/10/20.
//  Copyright © 2020 aayushi. All rights reserved.
//

import UIKit
import SwipeCellKit

class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate {

//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell
        cell.delegate = self
            
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
           guard orientation == .right else {
               return nil
           }
           
           let deleteAction = SwipeAction(style: .destructive, title: "Delete") { (action, indexPath) in
            print("delete cell")
            self.updateModel(at: indexPath)
           }
           
           deleteAction.image = UIImage(named: "delete-icon")
           return [deleteAction]
       }
       
       func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
           var options = SwipeTableOptions()
           options.expansionStyle = .destructiveAfterFill
    
           return options
       }
    func updateModel(at indexPath: IndexPath){
        
    }
}

