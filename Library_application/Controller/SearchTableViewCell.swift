//
//  SearchTableViewCell.swift
//  Library_application
//
//  Created by user189640 on 5/14/21.
//

import UIKit

protocol cellCommunicateDelegate{
    func addToCartTapped(at index:IndexPath)
    func viewPreviewTapped(at index:IndexPath)
    func removeFromCartTapped(at index:IndexPath)
    func borrowBookTapped(at index:IndexPath)
}

class SearchTableViewCell: UITableViewCell {

    @IBOutlet weak var imgViewBook: UIImageView!
    @IBOutlet weak var lblBookTitle: UILabel!
    @IBOutlet weak var lblBookAuthor: UILabel!
    @IBOutlet weak var lblBookEdition: UILabel!
    @IBOutlet weak var lblPublishedYear: UILabel!
    @IBOutlet weak var lblISBN: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblDueDate: UILabel!
    var delegate:cellCommunicateDelegate!
    @IBOutlet weak var btnAddToCart: UIButton!
    @IBOutlet weak var btnBorrow: UIButton!
    @IBOutlet weak var btnRemove: UIButton!
    @IBOutlet weak var btnPreview: UIButton!
    var indexPath:IndexPath!
    
    @IBAction func removeFromCart(_ sender: Any) {
        self.delegate?.removeFromCartTapped(at: indexPath)
    }
    @IBAction func borrowBook(_ sender: Any) {
        self.delegate?.borrowBookTapped(at: indexPath)
    }
    @IBAction func viewPreview(_ sender: Any) {
        self.delegate?.viewPreviewTapped(at: indexPath)
    }
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
