//
//  File.swift
//  Library_application
//
//  Created by Aaron Hyungju Lee on 11/5/21.
//

import Foundation
import UIKit

class SearchViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {
    
    let searchViewData = SearchViewData()
    
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
            let imageName = "\(tableViewBooksData?.books[indexPath.row].id ?? "737930").jpg"//"yourImage.png"
            let image = UIImage(named: imageName)!
            cell.imgViewBook.image = image
        
        return cell
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
