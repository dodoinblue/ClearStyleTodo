//
//  ViewController.swift
//  Todoey
//
//  Created by charles.liu on 2017-12-20.
//  Copyright © 2017 Charles Liu. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoListViewController: SwipeTableViewController {
    
    var todoItems: Results<Item>?
    let realm = try! Realm()
    let fallbackNavBagroundColor = "#9BD9FA"
    
    @IBOutlet weak var searchBar: UISearchBar!
    var selectedCategory: Category? {
        didSet {
            loadItems()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let navBar = navigationController?.navigationBar else {
            fatalError("navBar not ready")
        }
        let colorString = selectedCategory?.color ?? fallbackNavBagroundColor
        guard let color = UIColor(hexString: colorString) else {
            fatalError("error parsing color \(colorString)")
        }
        navBar.barTintColor = color
        navBar.tintColor = ContrastColorOf(color, returnFlat: true)
        navBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: ContrastColorOf(color, returnFlat: true)]
        searchBar.barTintColor = color
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        guard let color = UIColor(hexString: fallbackNavBagroundColor) else {
            fatalError("error parsing default color")
        }
        navigationController?.navigationBar.barTintColor = color
    }

    // MARK - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        guard let navBar = navigationController?.navigationBar else {
            fatalError("navBar not ready")
        }
        
        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
            if let color = navBar.barTintColor?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(todoItems!.count)) {
                print("bar tint color \(color.hexValue())")
                cell.backgroundColor = color
                cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
            } else {
                print("error setting cell color")
            }
        } else {
            cell.textLabel?.text = "No Items Added"
        }

        return cell
    }
    
    // MARK - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                }
            } catch {
                print("error saving status \(error)")
            }
        }
        tableView.reloadData()
    }

    // MARK - Add New Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            if let category = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        category.items.append(newItem)
                    }
                } catch {
                    print("error saving new items: \(error)")
                }
            }
            self.tableView.reloadData()
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item ..."
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Delete items
    override func updateModel(at indexPath: IndexPath) {
        if let item = todoItems?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(item)
                }
            } catch {
                print("Error saving context \(error)")
            }
        }
    }
    
    // MARK: - Save / Load data
    func loadItems() {
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
    
}

extension TodoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.text!.count < 1 {
            loadItems()
        } else {
            todoItems = todoItems?.filter("title CONTAINS %@", searchBar.text!).sorted(byKeyPath: "title", ascending: true)
        }
        tableView.reloadData()
    }
}

