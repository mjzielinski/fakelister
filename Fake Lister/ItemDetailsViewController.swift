//
//  ItemDetailsViewController.swift
//  Fake Lister
//
//  Created by Michael Zielinski on 4/18/17.
//  Copyright © 2017 Worldengine. All rights reserved.
//

import UIKit
import CoreData

class ItemDetailsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    @IBOutlet weak var storePicker: UIPickerView!
    
    @IBOutlet weak var titleField: CustomTextField!
    
    @IBOutlet weak var priceField: CustomTextField!
    
    @IBOutlet weak var detailsField: CustomTextField!
    
    @IBOutlet weak var thumbImage: UIImageView!
    
    var stores = [Store]()
    
    // this variable is used if editing an existing item
    var itemToEdit: Item?
    
    var imagePicker: UIImagePickerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        storePicker.delegate = self
        storePicker.dataSource = self
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
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
        
        // create a picture object
        let picture = Image(context: context)
        picture.image = thumbImage.image
        
        
        
        if itemToEdit == nil {
            item = Item(context: context)
        } else {
            item = itemToEdit
        }
        
        item.toImage = picture
        
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
    
    
    // image picker
    @IBAction func imageTapped(_ sender: Any) {
        
        // present the image picker
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    // image picker controller
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        // this gets the image out of image picker controller and assigns to thumb image
        if let img = info[UIImagePickerControllerOriginalImage] as? UIImage {
            thumbImage.image = img
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
        
    }
    
    
    func loadItemData() {
        if let item = itemToEdit {
            titleField.text = item.title
            priceField.text = "\(item.price)"
            detailsField.text = item.details
            
            thumbImage.image = item.toImage?.image as? UIImage
            
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
