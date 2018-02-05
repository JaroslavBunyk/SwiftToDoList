//
//  ViewController.swift
//  ToDoList
//
//  Created by Bunyk Jaroslav on 2/3/18.
//  Copyright © 2018 JaroslavBunyk. All rights reserved.
//

import UIKit

class ToDoLIstViewController: UITableViewController {
    
    var itemArray = [Item]();
    
    //let defaults = UserDefaults.standard
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadItems()
        
    }

    //MARK - Tableview datasource
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return itemArray.count;
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.isDone ? .checkmark : .none
        
        return cell
        
    }

    
    //MARK - Tableview delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        itemArray[indexPath.row].isDone = !itemArray[indexPath.row].isDone
        
        self.saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New ToDo item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add item", style: .default) { (action) in
            
            let newItem = Item()
            
            newItem.title = textField.text!
            self.itemArray.append(newItem)
            
            //self.defaults.set(self.itemArray, forKey: "ToDoListArray")
            
            self.saveItems()
            
            self.tableView.reloadData()

            print("Success!")
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            
            textField = alertTextField
            //print(newItem)
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    func saveItems() {
        
        let encoder = PropertyListEncoder()
        
        do {
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        } catch {
            
            print("Error encoding item array, \(error)")
        }
        
        self.tableView.reloadData()
        
    }
    
        func loadItems() {
     
            if let data = try? Data(contentsOf: dataFilePath!) {
                
                let decoder = PropertyListDecoder()
                
                do {
                    itemArray = try decoder.decode([Item].self, from: data)
                } catch {
                    
                    print("Error decoding, \(error)")
                }

            }
    }

    
}

