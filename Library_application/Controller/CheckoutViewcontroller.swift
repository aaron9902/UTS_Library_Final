//
//  CheckoutViewcontroller.swift
//  Library_application
//
//  Created by user190351 on 5/16/21.
//

import Foundation
import UIKit

class CheckoutViewController: UIViewController, addToCartBtnDelegate, UITableViewDelegate, UITableViewDataSource  {
    
    @IBOutlet weak var tableViewBooks: UITableView!
    var bookShelfManager = BookShelfManager()
    var bookShelf: BookShelf? = nil
    var tableViewBooksData: BookShelf? = nil
    var searchText: String? = nil
    
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
        return 5                                       //with number of rows equal to the number of high scores
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableViewBooks.dequeueReusableCell(withIdentifier: "SearchTableViewCell", for: indexPath) as! SearchTableViewCell
            cell.lblBookTitle.text = tableViewBooksData?.books[indexPath.row].title
            cell.lblBookAuthor.text = tableViewBooksData?.books[indexPath.row].author
            cell.lblBookEdition.text = tableViewBooksData?.books[indexPath.row].edition
            cell.lblPublishedYear.text = tableViewBooksData?.books[indexPath.row].id
            let imageName = "\(tableViewBooksData?.books[indexPath.row].id ?? "737930").jpg"//"yourImage.png"
            let image = UIImage(named: imageName)!
            cell.imgViewBook.image = image
            cell.delegate = self
            cell.indexPath = indexPath
        return cell
    }
    
    func removeCell()
    {
        tableViewBooks.reloadData()
    }
    
    func addToCartTapped(at index: IndexPath) {
        let clickedCell = tableViewBooks.cellForRow(at: index) as! SearchTableViewCell
        let selectedBookID:String? = clickedCell.lblPublishedYear.text
        let commonProperty = CommonProperty()
        usersData = commonProperty.retrieveAndDecodeStoredUsersData()
        let username = "14085930"
        if let user = usersData.first(where: {$0.userID == username})
        {
            let usersDataIndex = usersData.firstIndex(where: {$0.userID == username})
            var currentCart: [String]  = user.bookInCartArray
            if !(currentCart.contains(selectedBookID!))
            {
                currentCart.append(selectedBookID!)
                user.bookInCartArray = currentCart
            }
            usersData.remove(at: usersDataIndex!)
            usersData.append(user)
            commonProperty.encodeAndStoreUsersData(usersData: usersData)
        }
        openAlertDialog()
    }

    fileprivate func openAlertDialog() {
        
        // This class creates the alert view
        let alert = PMAlertController(title: "Book is added to your Cart", description: "Visit checkout tab to continue borrowing", image: UIImage(named: "bookCart.png"), style: .alert)
        
        //Add action button to alert view
        alert.addAction(PMAlertAction(title: "OK", style: .default, action: { () in
        
        alert.dismiss(animated: true, completion: nil)
            
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false                            // The table view should not be editable by the user.
    }
    
    func getUpdatedTableViewData(bookShelf: BookShelf?, searchText: String?) -> BookShelf? {
        var booksData: BookShelf? = nil
        if var bookShelf = bookShelf {
            if let searchText = searchText {
                let books = bookShelf.books.filter { book in
                    return book.title.lowercased().contains(searchText.lowercased())
                }
                bookShelf.books = books
                booksData = bookShelf
            } else {
                let books = bookShelf.books.filter { book in
                    return book.recommended == YesNo.y
                }
                bookShelf.books = books
                booksData = bookShelf
            }
        }
        return booksData
    }
}

