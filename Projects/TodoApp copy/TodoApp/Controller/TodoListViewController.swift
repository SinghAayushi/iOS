//
//  TodoListViewController.swift
//  TodoApp
//
//  Created by aayushisingh on 27/10/20.
//  Copyright © 2020 aayushi. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit
import ChameleonFramework

class TodoListViewController : SwipeTableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    var todoListArray: Results<TodoListItem>!
    let realm = try! Realm()
    var selectedCategory: CategoryList? {
        didSet{
            // as soon as category is set  it will load the data, if we load in view did load then it may crash in case of core data
            fetchDataFromRealm()
        }
    }
    let filePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("plist.items")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        tableView.rowHeight = 80.0

        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
         title = selectedCategory!.name
         if let colorHex = UIColor(hexString: selectedCategory!.color){
            searchBar.barTintColor = colorHex
            searchBar.searchTextField.backgroundColor = UIColor(hexString: "#FFFFFF")
               navigationController?.navigationBar.barTintColor = colorHex
           }
    }
    
    @IBAction func addTodoListItem(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController.init(title: "Add new todo item", message: "", preferredStyle: .alert)
        let alertAction = UIAlertAction.init(title: "add Item", style: .default) { (action) in
            if let text = textField.text {
                if let currentCategory = self.selectedCategory {
                    do{
                        try self.realm.write(){
                             let item = TodoListItem()
                             item.todoListItem = text
                             currentCategory.todoListArray.append(item)
                        }
                    }catch {
                        
                    }
                    self.tableView.reloadData()
                }
                
            }
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Enter your new todo item"
            textField = alertTextField
        }
        
        alert.addAction(alertAction)
        present(alert, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.todoListArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel?.text = self.todoListArray[indexPath.row].todoListItem
        let item = todoListArray[indexPath.row]
        cell.accessoryType = item.todoItemChecked ? .checkmark : .none
        
        let color = UIColor(hexString: selectedCategory!.color)?.darken(byPercentage: CGFloat(indexPath.row)/CGFloat(todoListArray! .count))
        cell.backgroundColor = color
        cell.textLabel?.textColor = UIColor.init(contrastingBlackOrWhiteColorOn: color!, isFlat: true)
        
        return cell
    }
    
    //MARK - Table view delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = todoListArray?[indexPath.row]{
            do{
                  try realm.write(){
                    item.todoItemChecked = !item.todoItemChecked
                   }
               } catch {
                   print ("error in saving check val \(error)")
               }
        }
       
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }

    
    func saveDataInRealm(list: TodoListItem){

        do {
            try realm.write(){
                realm.add(list)
            }
        }catch {
            
        }
        tableView.reloadData()
    }


    override func updateModel(at indexPath: IndexPath) {
        if let itemToDel = self.todoListArray?[indexPath.row]{
            do {
                try self.realm.write {
                    self.realm.delete(itemToDel)
                }
            }catch{
                 print ("error in deleting \(error)")
            }
        }
    }
    
    //optional value in parameter if no argument is passed then it will take the parameter value
    func fetchDataFromRealm(){
        todoListArray = selectedCategory?.todoListArray.sorted(byKeyPath: "todoListItem")
         tableView.reloadData()
    }
}


extension TodoListViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print ("search clicked")
        todoListArray = todoListArray?.filter("todoListItem CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "todoListItem", ascending: true)

        tableView.reloadData()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            fetchDataFromRealm()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }

}
