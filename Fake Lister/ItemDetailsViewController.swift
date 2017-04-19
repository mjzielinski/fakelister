//
//  ItemDetailsViewController.swift
//  Fake Lister
//
//  Created by Michael Zielinski on 4/18/17.
//  Copyright © 2017 Worldengine. All rights reserved.
//

import UIKit
import CoreData

class ItemDetailsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    
    @IBOutlet weak var storePicker: UIPickerView!
    
    @IBOutlet weak var titleField: CustomTextField!
    
    @IBOutlet weak var priceField: CustomTextField!
    
    @IBOutlet weak var detailsField: CustomTextField!
    
    var stores = [Store]()
    
    // this variable is used if editing an existing item
    var itemToEdit: Item?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        storePicker.delegate = self
        storePicker.dataSource = self
        
        /* run this once to set up the stores in Core Data
        let store = Store(context: context)
        store.name = "Fake.com"
        let store2 = Store(context: context)
        store2.name = "Fakazon.com"
        let store3 = Store(context: context)
        store3.name = "Fakkle"
        let store4 = Store(context: context)
        store4.name = "Fakes R Us"
        ad.saveContext()
        */
        
        getStores()
        
        if itemToEdit != nil {
            
            loadItemData()
        }

    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let store = stores[row]
        return store.name
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return stores.count
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //
    }
    
    func getStores() {
        let fetchRequest: NSFetchRequest<Store> = Store.fetchRequest()
        
        do {
            self.stores = try context.fetch(fetchRequest)
            self.storePicker.reloadAllComponents()
        } catch {}
    }
    
    @IBAction func saveTapped(_ sender: Any) {
        
        var item: Item!
        
        if itemToEdit == nil {
            item = Item(context: context)
        } else {
            item = itemToEdit
        }
        
        if let title = titleField.text {
            item.title = title
        }
        
        if let price = priceField.text {
            item.price = (price as NSString).doubleValue
        }
        
        if let details = detailsField.text {
            item.details = details
        }
        
        item.toStore = stores[storePicker.selectedRow(inComponent: 0)]
        
        ad.saveContext()
        
        _ = navigationController?.popViewController(animated: true)
        
    }
    
    
    // action to delete from core data
    @IBAction func garbageTapped(_ sender: Any) {
        
        if itemToEdit != nil {
            context.delete(itemToEdit!)
            ad.saveContext()
        }
        _ = navigationController?.popViewController(animated: true)
    }
    
    
    func loadItemData() {
        if let item = itemToEdit {
            titleField.text = item.title
            priceField.text = "\(item.price)"
            detailsField.text = item.details
            
            if let store = item.toStore {
                var index = 0
                repeat {
                    let s = stores[index]
                    if s.name == store.name {
                        storePicker.selectRow(index, inComponent: 0, animated: false)
                        break
                    }
                    index += 1
                } while (index < stores.count)
            }
        }
    }

}
