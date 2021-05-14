//
//  SearchTableViewCell.swift
//  Library_application
//
//  Created by user189640 on 5/14/21.
//

import UIKit

class SearchTableViewCell: UITableViewCell {

    @IBOutlet weak var imgBookCover: UIImageView!
    @IBOutlet weak var lblBookTitle: UILabel!
    @IBOutlet weak var lblBookAuthorAndYear: UILabel!
    @IBOutlet weak var lblSearchInfo: UILabel!
    @IBOutlet weak var lblBookStatus: UILabel!
    @IBOutlet weak var btnAddToCart: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func onClickOfAddToCart(_ sender: UIButton) {
    }
}
