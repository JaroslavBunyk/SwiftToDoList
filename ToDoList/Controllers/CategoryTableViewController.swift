//
//  CategoryTableViewController.swift
//  ToDoList
//
//  Created by Bunyk Jaroslav on 2/5/18.
//  Copyright © 2018 JaroslavBunyk. All rights reserved.
//

import UIKit
import CoreData

class CategoryTableViewController: UITableViewController {
    
     var itemArray = [Category]();
     var selectedCategory = Category()
    
    
     let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    //MARK - Tableview datasource
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count;
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.name
        
        //cell.accessoryType = item.isDone ? .checkmark : .none
        
        return cell
        
    }
    
    
    //MARK - Tableview delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //        context.delete(itemArray[indexPath.row])
        //        itemArray.remove(at: indexPath.row)
        
        //        itemArray[indexPath.row].setValue("Completed", forKey: "title")
        //
        selectedCategory = itemArray[indexPath.row]
        
        performSegue(withIdentifier: "ShowItem", sender: self)
        
//        itemArray[indexPath.row].isDone = !itemArray[indexPath.row].isDone
//
//        self.saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    
        @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
            var textField = UITextField()
            
            let alert = UIAlertController(title: "Add New ToDo Category", message: "", preferredStyle: .alert)
            
            let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
                
                let newCategory = Category(context: self.context)
                
                newCategory.name = textField.text!
                self.itemArray.append(newCategory)
                
                self.saveItems()
                
                self.tableView.reloadData()
                
                print("Success!")
            }
            
            alert.addTextField { (alertTextField) in
                alertTextField.placeholder = "Create new Category"
                
                textField = alertTextField
                //print(newItem)
            }
            
            alert.addAction(action)
            
            present(alert, animated: true, completion: nil)
            
    }
    
    func loadItems(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        
        //let request : NSFetchRequest<Item> = Item.fetchRequest() as! NSFetchRequest<Item>
        
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
        
        
    }
    
    func saveItems() {
        
        do {
            try context.save()
        } catch {
            
            print("Error encoding Category array, \(error)")
        }
        
        self.tableView.reloadData()
        
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowItem" {
            
            let destVC = segue.destination as! ToDoLIstViewController
            
            destVC.currentCategory = selectedCategory
            
        }
    }
}
