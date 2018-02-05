//
//  CategoryTableViewController.swift
//  ToDoList
//
//  Created by Bunyk Jaroslav on 2/5/18.
//  Copyright © 2018 JaroslavBunyk. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryTableViewController: UITableViewController {
    
    let realm = try! Realm()
    
    var categories : Results<Category>?
    
    
     let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
    }
    
    //MARK - Tableview datasource
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        //let item = categories?[indexPath.row]
        
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories"
        
        //cell.accessoryType = item.isDone ? .checkmark : .none
        
        return cell
        
    }
    
    
    //MARK - Tableview delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "ShowItem", sender: self)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    
        @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
            var textField = UITextField()
            
            let alert = UIAlertController(title: "Add New ToDo Category", message: "", preferredStyle: .alert)
            
            let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
                
                let newCategory = Category()
                
                newCategory.name = textField.text!
                
                self.save(category: newCategory)
                
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
    
    func loadCategories() {
        
        categories = realm.objects(Category.self)

        tableView.reloadData()

    }
    
    func save(category : Category) {
        
        do {
            try realm.write() {
                
                realm.add(category)
            }
        } catch {
            
            print("Error encoding Category array, \(error)")
        }
        
        self.tableView.reloadData()
        
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowItem" {
            
            let destVC = segue.destination as! ToDoLIstViewController
            if let indexPath = tableView.indexPathForSelectedRow {
            destVC.currentCategory = categories?[indexPath.row]
            }
        }
    }
}
