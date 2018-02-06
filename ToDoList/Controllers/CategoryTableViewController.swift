//
//  CategoryTableViewController.swift
//  ToDoList
//
//  Created by Bunyk Jaroslav on 2/5/18.
//  Copyright © 2018 JaroslavBunyk. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit
import ChameleonFramework

class CategoryTableViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    
    var categories : Results<Category>?
    
    
     //let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 80.0
        
        loadCategories()
        
        tableView.separatorStyle = .none
        
    }
    
    //MARK: - Tableview datasource
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories"
        
        
        guard let categoryColor = UIColor(hexString : (categories?[indexPath.row].colorString)!) else { fatalError() }
        
        cell.backgroundColor = categoryColor
        cell.textLabel?.textColor = ContrastColorOf(categoryColor, returnFlat: true)

        return cell
        
    }
    
    
    //MARK: - Tableview delegate
    
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
                newCategory.colorString = UIColor.randomFlat.hexValue()
                
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
    
    //MARK - Delete data from swipe
    
    override func updateModel(at indexPath: IndexPath) {
        
        super.updateModel(at: indexPath)
        
        if let categoryForDeletion = self.categories?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(categoryForDeletion)
                }
            } catch {
                print("Error deleting category, \(error)")
            }
        }
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
            destVC.currentColorString = (categories?[indexPath.row].colorString)!
            }
        }
    }

}

//MARK: - Swipe cell Delegate Methods

//extension CategoryTableViewController: SwipeTableViewCellDelegate {
//    
//    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
//        guard orientation == .right else { return nil }
//        
//        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
//            
//            if let categoryForDeletion = self.categories?[indexPath.row] {
//      do {
//            try self.realm.write {
//                self.realm.delete(categoryForDeletion)
//            }
//            } catch {
//                print("Error deleting category, \(error)")
//            }
//        }
//    }
//        // customize the action appearance
//        deleteAction.image = UIImage(named: "delete_icon")
//        
//        return [deleteAction]
//    }
//    
//    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeTableOptions {
//        var options = SwipeTableOptions()
//        options.expansionStyle = .destructive
//        return options
//    }
//    
//}

