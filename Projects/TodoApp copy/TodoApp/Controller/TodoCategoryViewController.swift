//
//  TodoCategoryViewController.swift
//  TodoApp
//
//  Created by aayushisingh on 29/10/20.
//  Copyright © 2020 aayushi. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit
import ChameleonFramework

class TodoCategoryViewController: SwipeTableViewController{
    var categoryArray: Results<CategoryList>!
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        tableView.rowHeight = 80.0
        fetchData()
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var tempTextField = UITextField()
        let dialogBox = UIAlertController.init(title: "Todo Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction.init(title: "Add Category", style: .default) { (action) in
//            if let text = tempTextField.text {
                let item = CategoryList()
                item.name = tempTextField.text!
                let cellColor = UIColor.randomFlat()?.hexValue()
                item.color = cellColor ?? "#FFFFFF"
                self.saveData(category: item)
//            }
        }
        
        dialogBox.addTextField { (textField) in
            textField.placeholder = "Enter a todo category name"
            tempTextField = textField
        }
        
        dialogBox.addAction(action)
        present(dialogBox, animated: true, completion: nil)
    }
    
    //MARK: table view delegate methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.categoryArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
//        cell.textLabel?.text = self.categoryArray?[indexPath.row].name ?? "No categories available"
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        cell.textLabel?.text = self.categoryArray[indexPath.row].name
        let color = UIColor(hexString: self.categoryArray?[indexPath.row].color ?? "#1D9BF6")
        cell.backgroundColor = color
        cell.textLabel?.textColor = UIColor.init(contrastingBlackOrWhiteColorOn: color!, isFlat: true)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        self.context.delete(categoryArray[indexPath.row])
//        categoryArray.remove(at: indexPath.row)
//        saveData()
        performSegue(withIdentifier: "homeToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
    }
    //MARK: core data operations
    func saveData(category: CategoryList){
        do {
            try realm.write(){
                realm.add(category)
            }
        }catch {
            
        }
        tableView.reloadData()
    }
    
    func fetchData(){
        categoryArray = realm.objects(CategoryList.self)
        
        tableView.reloadData()
        
    }
    
    override func updateModel(at indexPath: IndexPath) {
        if let itemToDel = self.categoryArray?[indexPath.row]{
            do {
                try self.realm.write {
                    self.realm.delete(itemToDel)
                }
            }catch{
                 print ("error in deleting \(error)")
            }
        }
    }
}
