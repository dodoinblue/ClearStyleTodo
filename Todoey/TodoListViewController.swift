//
//  ViewController.swift
//  Todoey
//
//  Created by charles.liu on 2017-12-20.
//  Copyright © 2017 Charles Liu. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    let itemArray = ["Find Mike", "Buy Eggos", "Destory Demogorgon"]

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        cell.textLabel?.text = itemArray[indexPath.row]
        return cell
    }
    
    // MARK - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print(itemArray[indexPath.row])
        let type = tableView.cellForRow(at: indexPath)?.accessoryType
        tableView.cellForRow(at: indexPath)?.accessoryType = type == .checkmark ? .none : .checkmark
        tableView.deselectRow(at: indexPath, animated: true)
    }

}

