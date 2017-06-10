//
//  ItemsViewController.swift
//  Homepwner
//
//  Created by Emilee Duquette on 6/1/17.
//  Copyright © 2017 Ryan Petrill. All rights reserved.
//

import UIKit

class ItemsViewController: UITableViewController {
    var itemStore: ItemStore!
    
    //Set the left bar button item in the Nav Controller (edit mode must be done programatically)
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        navigationItem.leftBarButtonItem = editButtonItem
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
     /* Now Handled by Nav Bar
        
         //Get the table bar height
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        
        //position the table view underneath the status bar (padding)
        let insets = UIEdgeInsets(top: statusBarHeight, left: 0, bottom: 0, right: 0)
        tableView.contentInset = insets
        tableView.scrollIndicatorInsets = insets */
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 80
    }
    
    //Override the View Will Appear Function to Refresh Table
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    //Set number of Rows in Table View
    
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int{
        return itemStore.allItems.count
    }
    
    //Set up the Cell in the Table View
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Get a new or recycled cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemCell
        
        //Set text on the cell with description of the item
        let item = itemStore.allItems[indexPath.row]
        
        //Configure the Cell with the Item
        cell.nameLabel.text = item.name
        cell.serialNumberLabel.text = item.serialNumber
        cell.valueLabel.text = "$\(item.valueInDollars)"
        
        return cell
    }
    
    //Add a new Item to the Table View via the navbar
    
    @IBAction func addNewItem(_ sender: UIBarButtonItem){
        //Create a new item and add it to the store
        let newItem = itemStore.createItem()
        
        //Figure out where that itme is in the array
        if let index = itemStore.allItems.index(of: newItem) {
            let indexPath = IndexPath(row: index, section: 0)
            
            //Insert new row into table
            tableView.insertRows(at: [indexPath], with: .automatic)
        }
    }
    
    
   /* Now Handled By the Nav Bar
 
    //EDITING THE TABLE VIEW
    @IBAction func toggleEditingMode(_ sender: UIButton){
        
        //If you are currently in editing mode...
        if isEditing {
            //Change text of button to inform user of state
            sender.setTitle("Edit", for: .normal)
            
            //Turn off Editing Mode
            setEditing(false, animated: true)
        } else {
            //Change text of button to inform user of state
            sender.setTitle("Done", for: .normal)
            
            //Enter Editing Mode
            setEditing(true, animated: true)
        }
        
    }
    
 */
    
    //Delete rows from the table View
    
    override func tableView(_ tableView: UITableView, commit editingStle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        //If the table is asking to commit a delete command...
        if editingStle == .delete {
            let item = itemStore.allItems[indexPath.row]
            //Display a User Alert:
            let title = "Delete \(item.name)?"
            let message = "Are you sure you want to delete this item?"
            
            let ac = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            ac.addAction(cancelAction)
            
            let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: { (action) -> Void in
                
                //Remove item from the store
                self.itemStore.removeItem(item)
                
                //Remove item from the table view with an animation
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
            })
            ac.addAction(deleteAction)
            
            //Present the alert Controller
            present(ac,animated: true, completion: nil)
            
        }
    
    }
    
    //Move Cells Around
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        // Update the Model
        itemStore.moveItem(from: sourceIndexPath.row, to: destinationIndexPath.row)
    }
    
    //Pass Data Around with a segue - Can handle multiple segues in one function
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //If the triggered segue is the "showItem" segue
        switch segue.identifier {
        case "showItem"?:
            //Figure out which row was just tapped
            if let row = tableView.indexPathForSelectedRow?.row {
                
                //Then get the item in this row and pass it along
                let item = itemStore.allItems[row]
                let detailViewController = segue.destination as! DetailViewController
                detailViewController.item = item
            }
        default:
            preconditionFailure("Unexpected segue identifier.")
        }
    }
    
}
