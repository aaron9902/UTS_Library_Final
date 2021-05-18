//
//  File.swift
//  Library_application
//
//  Created by Aaron Hyungju Lee on 11/5/21.
//

import Foundation


import UIKit

class DetailViewController: UIViewController {
    
    let detailViewData = DetailViewData()
    
    var bookId = String()
    var username = String()
    var user: UserData? = nil
    
    @IBOutlet weak var lblBookTitle: UILabel!
    @IBOutlet weak var imgBookCoverPage: UIImageView!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblAuthor: UILabel!
    @IBOutlet weak var lblEdition: UILabel!
    @IBOutlet weak var lblYear: UILabel!
    @IBOutlet weak var lblISBN: UILabel!
    @IBOutlet weak var lblCategory: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblDueDate: UILabel!
    @IBOutlet weak var btnAddToCart: UIButton!
    @IBOutlet weak var btnBorrow: UIButton!
    @IBOutlet weak var btnReturn: UIButton!
    @IBOutlet weak var btnLogout: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        detailViewData.detailViewDefaultSetting(btnAddToCart: btnAddToCart, btnBorrow: btnBorrow, btnReturn: btnReturn)
        
        if let bookShelf = bookShelf {
            if let book = bookShelf.books.first(where: {$0.id == bookId}) {
                setBookDataToView(book)
                
                if !usersData.isEmpty {
                    user = usersData.first(where: {$0.userID == username})
                    if let user = user {
                        if user.bookInCartArray.contains(book.id) {
                            lblStatus.text = "In Cart"
                            lblStatus.textColor = UIColor.systemYellow
                            lblDueDate.isHidden = true
                            btnAddToCart.isHidden = true
                            btnBorrow.isHidden = false
                            btnReturn.isHidden = true
                        } else if user.bookBorrowedArray.keys.contains(book.id) {
                            lblDueDate.isHidden = false
                            
                            let dueDate = detailViewData.getFormattedDateString(user.bookBorrowedArray[book.id]!)
                            lblDueDate.text = "Due: \(dueDate)"
                            
                            if detailViewData.getDifferenceInDaysWithCurrentDate(dueDate) < 7 {
                                lblStatus.text = "Borrowed/Overdue"
                                lblStatus.textColor = UIColor.systemRed
                            } else {
                                lblStatus.text = "Borrowed"
                                lblStatus.textColor = appColor
                            }
                            
                            btnAddToCart.isHidden = true
                            btnBorrow.isHidden = true
                            btnReturn.isHidden = false
                        } else {
                            lblStatus.text = "Available"
                            lblStatus.textColor = UIColor.systemGreen
                            lblDueDate.isHidden = true
                            btnAddToCart.isHidden = false
                            btnBorrow.isHidden = true
                            btnReturn.isHidden = true
                        }
                    }
                }
            }
        }
    }
    
    
    
    @IBAction func onClickOfAddToCart(_ sender: UIButton) {
        if let user = user {
            if !user.bookInCartArray.contains(bookId) { user.bookInCartArray.append(bookId) }
            if user.bookBorrowedArray.keys.contains(bookId) { user.bookBorrowedArray[bookId] = nil }
            lblStatus.text = "In Cart"
            lblStatus.textColor = UIColor.systemYellow
            lblDueDate.isHidden = true
            btnAddToCart.isHidden = true
            btnBorrow.isHidden = false
            btnReturn.isHidden = true
            
            usersData.remove(at: (usersData as NSArray).index(of: user))
            usersData.append(user)
            detailViewData.encodeAndStoreUsersData(usersData: usersData)
            
            openDialog(title: "In Cart", description: "Book is added to your Cart.", image: UIImage(named: "bookCart.png")!)
        }
        
    }
    
    
    @IBAction func onClickOfBorrow(_ sender: UIButton) {
        if let user = user {
            if user.bookBorrowedArray.keys.contains(bookId) { user.bookBorrowedArray[bookId] = Date() }
            if !user.bookInCartArray.contains(bookId) { user.bookInCartArray.append(bookId) }
            if user.bookBorrowedArray.keys.contains(bookId) { user.bookBorrowedArray[bookId] = nil }
            lblStatus.text = "In Cart"
            lblStatus.textColor = UIColor.systemYellow
            lblDueDate.isHidden = true
            btnAddToCart.isHidden = true
            btnBorrow.isHidden = false
            btnReturn.isHidden = true
            
            usersData.remove(at: (usersData as NSArray).index(of: user))
            usersData.append(user)
            detailViewData.encodeAndStoreUsersData(usersData: usersData)
            
            openDialog(title: "In Cart", description: "Book is added to your Cart.", image: UIImage(named: "bookCart.png")!)
        }
    }
    
    
    
    @IBAction func onClickOfReturn(_ sender: UIButton) {
    }
    
    
    
    
    
    
    
    func setBookDataToView(_ book: Book) {
        imgBookCoverPage.image = UIImage(named: "\(book.id).jpg")!
        lblBookTitle.attributedText = "Title: \(book.title)".withBoldText(text: "Title: ")
        lblDescription.attributedText = "Description: \(book.bookDescription)".withBoldText(text: "Description: ")
        lblAuthor.attributedText = "Author: \(book.author)".withBoldText(text: "Author: ")
        lblEdition.attributedText = "Edition: \(book.edition)".withBoldText(text: "Edition: ")
        lblYear.attributedText = "Year: \(book.year)".withBoldText(text: "Year: ")
        lblISBN.attributedText = "ISBN: \(book.id)".withBoldText(text: "ISBN: ")
        lblCategory.attributedText = "Category: \(book.categories)".withBoldText(text: "Category: ")
    }
    
    fileprivate func openDialog(title: String, description: String, image: UIImage) {
        let alert = PMAlertController(title: title, description: description, image: image, style: .alert)
        alert.addAction(PMAlertAction(title: "OK", style: .default, action: {}))
        self.present(alert, animated: true, completion: nil)
    }
}

extension String {
    func withBoldText(text: String, font: UIFont? = nil) -> NSAttributedString {
        let _font = font ?? UIFont.systemFont(ofSize: 20, weight: .regular)
        let fullString = NSMutableAttributedString(string: self, attributes: [NSAttributedString.Key.font: _font])
        let boldFontAttribute: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: _font.pointSize)]
        let range = (self as NSString).range(of: text)
        fullString.addAttributes(boldFontAttribute, range: range)
        return fullString
    }}
