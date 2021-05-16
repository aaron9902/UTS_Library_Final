//
//  SearchTableViewCell.swift
//  Library_application
//
//  Created by user189640 on 5/14/21.
//

import UIKit

protocol addToCartBtnDelegate{
    func addToCartTapped(at index:IndexPath)
}

class SearchTableViewCell: UITableViewCell {

    @IBOutlet weak var imgViewBook: UIImageView!
    @IBOutlet weak var lblBookTitle: UILabel!
    @IBOutlet weak var lblBookAuthor: UILabel!
    @IBOutlet weak var lblBookEdition: UILabel!
    @IBOutlet weak var lblPublishedYear: UILabel!
    var delegate:addToCartBtnDelegate!
    @IBOutlet weak var btnAddToCart: UIButton!
    var indexPath:IndexPath!
    
    @IBAction func addToCarts(_ sender: UIButton) {
        self.delegate?.addToCartTapped(at: indexPath)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    

}
