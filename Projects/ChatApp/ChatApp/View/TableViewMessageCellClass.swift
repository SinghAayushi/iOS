//
//  chatTableCellViewController.swift
//  ChatApp
//
//  Created by aayushisingh on 20/10/20.
//  Copyright © 2020 aayushisingh. All rights reserved.
//

import Foundation
import UIKit
class TableViewMessageCellClass : UITableViewCell{
    @IBOutlet weak var messageBackground: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var cellImageView: UIImageView!
    @IBOutlet weak var completeMessageView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
