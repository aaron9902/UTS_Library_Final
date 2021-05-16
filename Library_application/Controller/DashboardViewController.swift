//
//  File.swift
//  Library_application
//
//  Created by Aaron Hyungju Lee on 11/5/21.
//

import Foundation


import UIKit

class DashboardViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    @IBOutlet weak var tableViewBooks: UITableView!
    var bookShelfManager = BookShelfManager()
    var bookShelf: BookShelf? = nil
    var tableViewBooksData: BookShelf? = nil
    var searchText: String? = nil
    var studentId = String()
    
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
            cell.lblPublishedYear.text = tableViewBooksData?.books[indexPath.row].year
            let imageName = "\(tableViewBooksData?.books[indexPath.row].id ?? "737930").jpg"//"yourImage.png"
            let image = UIImage(named: imageName)!
            cell.imgViewBook.image = image
        
        return cell
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
