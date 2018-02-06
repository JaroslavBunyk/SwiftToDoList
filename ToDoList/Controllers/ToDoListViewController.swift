//
//  ViewController.swift
//  ToDoList
//
//  Created by Bunyk Jaroslav on 2/3/18.
//  Copyright © 2018 JaroslavBunyk. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class ToDoLIstViewController: SwipeTableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    var currentCategory : Category? {
        didSet {
            loadItems()
        }
    }
    var currentColorString : String = ""
    
    var todoItems : Results<Item>?
    let realm = try! Realm()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorStyle = .none
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
    }
    
    override func viewWillAppear(_ animated: Bool) {
            
            title = currentCategory?.name
        
         guard let colorHex = currentCategory?.colorString else { fatalError() }
        
        updateNavBar(withHexColor: colorHex)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        updateNavBar(withHexColor: "1D9BF6")
    }

    //MARK: - Nav Bar Setup Methods
    
    func updateNavBar(withHexColor colourHexCode: String) {
        guard let navBar = navigationController?.navigationBar else {fatalError("Nav controller does not exist.")}
        
        guard let navBarColor = UIColor(hexString: colourHexCode) else { fatalError() }
        
        navBar.barTintColor = navBarColor
        
        navBar.tintColor = ContrastColorOf(navBarColor, returnFlat: true)
        
        navBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor : ContrastColorOf(navBarColor, returnFlat: true)]
        
        searchBar.barTintColor = navBarColor
    }
    
    
    //MARK: - Tableview datasource
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return todoItems?.count ?? 1;
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        //let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        if let item = todoItems?[indexPath.row] {
            
            cell.textLabel?.text = item.title
            
            if let colour = HexColor(item.colorString)?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(todoItems!.count)) {
                
                cell.backgroundColor = colour
                cell.textLabel?.textColor = ContrastColorOf(cell.backgroundColor!, returnFlat: true)
            }
            
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
        
            cell.textLabel?.text = "No items Added"
            
        }
        
        return cell
        
    }

    
    //MARK - Tableview delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if let item = todoItems?[indexPath.row] {
            
            do {
                
                try realm.write {
                    item.done = !item.done
                }
            } catch {
                
                print("Error saving done status, \(error)")
            }
        }
        
        
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadData()
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()

        let alert = UIAlertController(title: "Add New ToDo item", message: "", preferredStyle: .alert)

        let action = UIAlertAction(title: "Add item", style: .default) { (action) in

            if let selectedCategory = self.currentCategory {
                do {
                    try self.realm.write {
                let newItem = Item()
                newItem.title = textField.text!
                newItem.dateCreated = Date()
                newItem.colorString = self.currentColorString
                        
                selectedCategory.items.append(newItem)
                    
                }
            } catch {
                
                print("Error saving new items, \(error)")
            }
        }

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

    
    func loadItems() {

        todoItems = currentCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
    
    override func updateModel(at indexPath: IndexPath) {
        if let item = todoItems?[indexPath.row] {
            do {
            try realm.write {
                realm.delete(item)
            }
            } catch {
                
                print("Error deleting item, \(error)")
            }
    }
    }
    
}
    
    //MARK: - Search bar methods
    
    extension ToDoLIstViewController: UISearchBarDelegate {
        
        func searchBarSearchButtonClicked(_ searchBar : UISearchBar) {

            todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)

            tableView.reloadData()
        
        }

        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//            if searchBar.text?.count == 0 {
//
//                loadItems()
//
//                DispatchQueue.main.async {
//                searchBar.resignFirstResponder()
//            }
//        }
        }
    }

