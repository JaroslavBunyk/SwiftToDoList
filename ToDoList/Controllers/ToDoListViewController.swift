//
//  ViewController.swift
//  ToDoList
//
//  Created by Bunyk Jaroslav on 2/3/18.
//  Copyright © 2018 JaroslavBunyk. All rights reserved.
//

import UIKit
import CoreData

class ToDoLIstViewController: UITableViewController {
    
    var currentCategory : Category? {
        didSet {
            loadItems()
        }
    }
    
    var itemArray = [Item]();
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
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
            
            let newItem = Item(context: self.context)
            
            newItem.title = textField.text!
            newItem.isDone = false
            newItem.parentCategory = self.currentCategory
            self.itemArray.append(newItem)
            
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
        
        do {
            try context.save()
        } catch {
            
            print("Error encoding item array, \(error)")
        }
        
        self.tableView.reloadData()
        
    }
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
            
            let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", currentCategory!.name!)
        
        if let additionalPredicate = predicate {
            
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        } else {
            
            request.predicate = categoryPredicate
        }
        
            do {
            itemArray = try context.fetch(request)
            } catch {
                print("Error fetching data from context \(error)")
            }
            

    }
}
    
    extension ToDoLIstViewController: UISearchBarDelegate {
        
        func searchBarSearchButtonClicked(_ searchBar : UISearchBar) {
            
            let request : NSFetchRequest<Item> = Item.fetchRequest()
            
            let predicate = NSPredicate(format: "title CONTAINS %@", searchBar.text!)
            
            request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
            
            loadItems(with: request, predicate: predicate)
        
        }
        
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            if searchBar.text?.count == 0 {
                
                loadItems()
                
                DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }

}
