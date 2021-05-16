//
//  File.swift
//  Library_application
//
//  Created by Aaron Hyungju Lee on 11/5/21.
//

import Foundation
import UIKit

class SearchViewController: UIViewController, cellCommunicateDelegate, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {
    
    func viewPreviewTapped(at index: IndexPath) {
        
    }
    
    func removeFromCartTapped(at index: IndexPath) {
        
    }
    
    func borrowBookTapped(at index: IndexPath) {
        
    }

    let searchViewData = SearchViewData()
    let username = "14085930"
    @IBOutlet weak var tableViewBooks: UITableView!
    @IBOutlet weak var searchBarSearchBooks: UISearchBar!
    
    @IBOutlet weak var lblResult: UILabel!
    
    var bookShelfManager = BookShelfManager()
    var bookShelf: BookShelf? = nil
    var tableViewBooksData: BookShelf? = nil
    var searchTextInput: String? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchViewData.searchViewcommonDefaultSetting(tableViewBooks: tableViewBooks, searchBarSearchBooks: searchBarSearchBooks, lblResult: lblResult)
        lblResult.text = "Recommended Books"
        bookShelf = bookShelfManager.fetchBooks()
        tableViewBooksData = getUpdatedTableViewData(bookShelf: bookShelf, searchText: searchTextInput)
        tableViewBooks.delegate = self
        tableViewBooks.dataSource = self
        let nib = UINib(nibName: "SearchTableViewCell", bundle: nil)
        tableViewBooks.register(nib, forCellReuseIdentifier: "SearchTableViewCell")
        
        searchBarSearchBooks.searchTextField.clearButton?.addTarget(self, action: #selector(onClickOfClearBtn), for: .touchUpInside)
    }
    
    @objc func onClickOfClearBtn(_ sender: UIButton) {
        tableViewBooksData = getUpdatedTableViewData(bookShelf: bookShelf, searchText: searchTextInput)
        tableViewBooks.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        
        let inputString = searchText.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        
        if inputString.count > 0
        {
            searchTextInput = searchBarSearchBooks.text != nil && searchBarSearchBooks.text != "" ?  searchBarSearchBooks.text : nil
            tableViewBooksData = getUpdatedTableViewData(bookShelf: bookShelf, searchText: searchText)
            
        }
        else
        {
            tableViewBooksData = getUpdatedTableViewData(bookShelf: bookShelf, searchText: searchTextInput)
        }
        tableViewBooks.reloadData()
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
        cell.lblDueDate.isHidden = true
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
                cell.btnAddToCart.isHidden = true
                cell.lblDueDate.text = dateFormatter.string(from: dueDate!)
                cell.lblDueDate.textColor = UIColor.systemRed
            }
            else if bookInCart
            {
                cell.lblStatus.text = "In Cart"
                cell.lblStatus.textColor = UIColor.systemYellow
                cell.btnAddToCart.isEnabled = false
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
    
    func addToCartTapped(at index: IndexPath) {
        let clickedCell = tableViewBooks.cellForRow(at: index) as! SearchTableViewCell
        let selectedBookID:String? = clickedCell.lblISBN.text
        let commonProperty = CommonProperty()
        usersData = commonProperty.retrieveAndDecodeStoredUsersData()
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
        tableViewBooks.reloadData()
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

extension UISearchTextField {
    var clearButton: UIButton? {
        return value(forKey: "_clearButton") as? UIButton
    }
}
