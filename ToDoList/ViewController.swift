//
//  ViewController.swift
//  ToDoList
//
//  Created by Athena on 3/17/18.
//  Copyright © 2018 Sheena Elveus. All rights reserved.
//

import Cocoa
import CoreData

class ViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate {

    
    @IBOutlet var errorLabel: NSTextField!
    @IBOutlet var textField: NSTextField!
    @IBOutlet var importantCheck: NSButton!
    @IBOutlet var tableView: NSTableView!
    @IBOutlet var deleteButton: NSButton!
    
    var toDoItems: [ToDoItem] = []
    
    
    @IBAction func deleteItem(_ sender: Any) {
        let toDoItem = toDoItems[tableView.selectedRow]
        
        if let context = (NSApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
            
            context.delete(toDoItem)
            
            (NSApplication.shared.delegate as? AppDelegate)?.saveAction(nil)
            
            //update todo list
            getToDoItems()
        
            deleteButton.alphaValue = 0
        }
        
    }
    
    
    @IBAction func addItem(_ sender: Any) {
        print("adding an item")
        
        if textField.stringValue != "" {
            //erase error label if it was displaying something
            errorLabel.alphaValue = 0
            errorLabel.stringValue = ""
            
            if let context = (NSApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
                let toDoItem = ToDoItem(context: context)
                toDoItem.name = textField.stringValue
                
                if importantCheck.state.rawValue == 0 {
                    //not important
                    toDoItem.important = false
                }else{
                    //important
                    toDoItem.important = true
                }
                (NSApplication.shared.delegate as? AppDelegate)?.saveAction(nil)
            
                //empty the text field and important check box
                textField.stringValue = ""
                importantCheck.state = NSControl.StateValue(rawValue: 0)
                
                //update todo list
                getToDoItems()
            }
        }else{
            //display empty field label
            errorLabel.alphaValue = 1
            errorLabel.stringValue = "Please enter something."
        }
    }
    
    
    func getToDoItems(){
        
        //get the todo items from CoreData
        if let context = (NSApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
            do{
                toDoItems = try context.fetch(ToDoItem.fetchRequest())
                print(toDoItems.count)
            } catch{
                
            }
            
            //update the table
            tableView.reloadData()
        }
        //set them to the class property
        
        //update
    }
    
    
    // MARK: = TableView Stuff
    func numberOfRows(in tableView: NSTableView) -> Int {
        return toDoItems.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        let toDoItem = toDoItems[row]
        
        if (tableColumn?.identifier)!.rawValue == "ImportantColumn" {
            
            // IMPORTANT
            if let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "ImportantCell"), owner: self) as? NSTableCellView {
                
                if toDoItem.important {
                    cell.textField?.stringValue = "❗️"
                }else{
                    cell.textField?.stringValue = ""
                }
                
                return cell
            }
        }else {
            // TODO TITLE
            if let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "ToDoItem"), owner: self) as? NSTableCellView {
                cell.textField?.stringValue = toDoItem.name!
                return cell
            }
        }
        
        
        
        return nil
        
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        //show delete button
        deleteButton.alphaValue = 1
        
        
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //remove the error label and delete button
        errorLabel.alphaValue = 0
        deleteButton.alphaValue = 0
        
        //get the todo list
        getToDoItems()
        
        
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

