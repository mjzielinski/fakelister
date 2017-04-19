//
//  MainViewController.swift
//  Fake Lister
//
//  Created by Michael Zielinski on 4/17/17.
//  Copyright © 2017 Worldengine. All rights reserved.
//

import UIKit
import CoreData

class MainViewController: UIViewController, NSFetchedResultsControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segment: UISegmentedControl!
    
    var controller: NSFetchedResultsController<Item>!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //generateTestData()
        attemptFetch()
        
    }
    
    // generate test data
    func generateTestData() {
        
        // create an item within NSmanagedobjectcontext
        let item = Item(context: context)
        item.title = "Fake Item"
        item.price = 100.00
        item.details = "This is a fake description for the fake item. This is not a real thing."
        
        let item2 = Item(context: context)
        item2.title = "Fake Item2"
        item2.price = 1000.00
        item2.details = "This is a fake description for the fake item. This is not a real thing."
        
        let item3 = Item(context: context)
        item3.title = "Computer Skyence"
        item3.price = 1.00
        item3.details = "This is a fake description for the fake item. This is not a real thing."
        
        // save items into core data
        ad.saveContext()
    }
    

}

extension MainViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemCell
        configureCell(cell: cell, indexPath: indexPath as NSIndexPath)
        return cell
    }
    
    func configureCell(cell: ItemCell, indexPath: NSIndexPath) {
        
        let item = controller.object(at: indexPath as IndexPath)
        cell.configureCell(item: item)
    }
    
    // when user clicks on item in table view, perform segue to ItemDetailsViewController and send item
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let objs = controller.fetchedObjects, objs.count > 0 {
            let item = objs[indexPath.row]
            performSegue(withIdentifier: "ItemDetailsVC", sender: item)
        }
    }
    
    // prepare for segue, create variable for destination, create item from item, send item to destination
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ItemDetailsVC" {
            if let destination = segue.destination as? ItemDetailsViewController {
                if let item = sender as? Item {
                    destination.itemToEdit = item
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let sections = controller.sections {
            
            let sectionInfo = sections[section]
            return sectionInfo.numberOfObjects
        }
        
        return 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if let sections = controller.sections {
            return sections.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
}

extension MainViewController: UITableViewDelegate {
    
}
