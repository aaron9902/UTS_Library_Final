//
//  File.swift
//  Library_application
//
//  Created by Aaron Hyungju Lee on 11/5/21.
//

import Foundation


import UIKit

class DashboardViewController: UIViewController, cellCommunicateDelegate, UITableViewDelegate, UITableViewDataSource  {
    func addToCartTapped(at index: IndexPath) {
        
    }
    
    func viewPreviewTapped(at index: IndexPath) {
        
    }
    
    func removeFromCartTapped(at index: IndexPath) {
        
    }
    
    func borrowBookTapped(at index: IndexPath) {
        
    }
    
    
    @IBOutlet weak var tableViewBooks: UITableView!
    var bookShelfManager = BookShelfManager()
    var bookShelf: BookShelf? = nil
    var tableViewBooksData: BookShelf? = nil
    var searchText: String? = nil
    var studentId = String()
    let username = "14085930"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bookShelf = bookShelfManager.fetchBooks()
        tableViewBooksData = getUpdatedTableViewData(bookShelf: bookShelf, searchText: searchText)
        tableViewBooks.delegate = self
        tableViewBooks.dataSource = self
        let nib = UINib(nibName: "SearchTableViewCell", bundle: nil)
        tableViewBooks.register(nib, forCellReuseIdentifier: "SearchTableViewCell")
    }
    
    @IBAction func onClickBooksBorrowed(_ sender: Any) {
        tableViewBooksData = getUpdatedTableViewData(bookShelf: bookShelf, searchText: searchText)
        tableViewBooks.reloadData()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1                                                        //it has 1 single section
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        if let tableViewBooksData = tableViewBooksData {
            count = tableViewBooksData.books.count
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableViewBooks.dequeueReusableCell(withIdentifier: "SearchTableViewCell", for: indexPath) as! SearchTableViewCell
        cell.lblBookTitle.text = tableViewBooksData?.books[indexPath.row].title
        cell.lblBookAuthor.text = tableViewBooksData?.books[indexPath.row].author
        cell.lblBookEdition.text = tableViewBooksData?.books[indexPath.row].edition
        cell.lblPublishedYear.text = tableViewBooksData?.books[indexPath.row].year
        cell.lblISBN.text = tableViewBooksData?.books[indexPath.row].id
        cell.btnBorrow.isHidden = true
        cell.btnRemove.isHidden = true
        cell.btnAddToCart.isHidden = true
        let imageName = "\(tableViewBooksData?.books[indexPath.row].id ?? "737930").jpg"//"yourImage.png"
        let image = UIImage(named: imageName)!
        cell.imgViewBook.image = image
        let selectedBookId = cell.lblISBN.text
        let commonProperty = CommonProperty()
        usersData = commonProperty.retrieveAndDecodeStoredUsersData()
        if let user = usersData.first(where: {$0.userID == username})
        {
            let bookBorrowed = user.bookBorrowedArray[selectedBookId!] != nil
            let bookInCart = user.bookInCartArray.contains(selectedBookId!)
            if bookBorrowed
            {
                cell.lblStatus.text = "Borrowed"
                cell.lblStatus.textColor = UIColor.red
                let dateFormatter = DateFormatter()
                var dateComponent = DateComponents()
                dateComponent.day = 7
                let dueDate = Calendar.current.date(byAdding: dateComponent, to: user.bookBorrowedArray[selectedBookId!]!)
                dateFormatter.dateFormat = "dd/MM/YY"
                cell.lblDueDate.isHidden = false
                cell.lblDueDate.text = dateFormatter.string(from: dueDate!)
                cell.lblDueDate.textColor = UIColor.systemRed
            }
            else if bookInCart
            {
                cell.lblStatus.text = "In Cart"
                cell.lblStatus.textColor = UIColor.systemYellow
            }else
            {
                cell.lblStatus.text = "Available"
                cell.lblStatus.textColor = UIColor.green
            }
        }
        cell.delegate = self
        cell.indexPath = indexPath
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false                            // The table view should not be editable by the user.
    }
    
    func getUpdatedTableViewData(bookShelf: BookShelf?, searchText: String?) -> BookShelf? {
        var booksData: BookShelf? = nil
        let commonProperty = CommonProperty()
        usersData = commonProperty.retrieveAndDecodeStoredUsersData()
        if let user = usersData.first(where: {$0.userID == username})
            {
            if var bookShelf = bookShelf {
            let books = bookShelf.books.filter { book in
                return user.bookBorrowedArray[book.id] != nil
            }
            bookShelf.books = books
            booksData = bookShelf
            }
        }
        return booksData
    }
}
