//
//  TableViewCell.swift
//  Food_Data
//
//  Created by Jonathan Poon on 3/6/21.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet var foodName: UILabel!
    @IBOutlet var foodInfo: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    static let identifier = "TableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "TableViewCell", bundle: nil)
    }
    
    func configure(with model: Food) {
        self.foodName.text = model.name
        self.foodInfo.text = "Calories: " + model.calories.description + "\n" +
            "Protein: " + model.protein.description + "\n" +
            "Carbs: " + model.carbs.description + "\n" +
            "Fat: " + model.fat.description + "\n"
        
    }
    
}
