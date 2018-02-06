//
//  SwipeTableViewController.swift
//  ToDoList
//
//  Created by Bunyk Jaroslav on 2/5/18.
//  Copyright © 2018 JaroslavBunyk. All rights reserved.
//

import UIKit
import SwipeCellKit

class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 80.0
    }
    
    //MARK: - TableView DataSource methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell
        
        cell.delegate = self
        
        return cell
    }

    //MARK: - Swipe cell Delegate Methods
        
        func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
            guard orientation == .right else { return nil }
            
            let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
                
                self.updateModel(at: indexPath)
                
//                if let categoryForDeletion = self.categories?[indexPath.row] {
//                    do {
//                        try self.realm.write {
//                            self.realm.delete(categoryForDeletion)
//                        }
//                    } catch {
//                        print("Error deleting category, \(error)")
//                    }
//                }
            }
            // customize the action appearance
            deleteAction.image = UIImage(named: "delete_icon")
            
            return [deleteAction]
        }
        
        func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeTableOptions {
            var options = SwipeTableOptions()
            options.expansionStyle = .destructive
            return options
        }
    
    func updateModel(at indexPath: IndexPath) {
        
    }
    
}
