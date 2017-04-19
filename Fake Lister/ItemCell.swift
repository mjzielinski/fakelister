//
//  ItemCell.swift
//  Fake Lister
//
//  Created by Michael Zielinski on 4/17/17.
//  Copyright © 2017 Worldengine. All rights reserved.
//


// separate View and Model
// this updates the values in each cell
import UIKit

class ItemCell: UITableViewCell {

    @IBOutlet weak var thumb: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var details: UILabel!

    func configureCell(item: Item) {
        
        title.text = item.title
        price.text = "$\(item.price)"
        details.text = item.details
        thumb.image = item.toImage?.image as? UIImage
        
    }

}
