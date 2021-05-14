//
//  File.swift
//  Library_application
//
//  Created by Aaron Hyungju Lee on 11/5/21.
//

import Foundation


import UIKit

class SearchViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableViewBooks: UITableView!
    @IBOutlet weak var searchBarSearchBooks: UISearchBar!
    var bookShelfManager = BookShelfManager()
    var bookShelf: BookShelf? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bookShelf = bookShelfManager.fetchBooks()
        tableViewBooks.delegate = self
        tableViewBooks.dataSource = self
        let nib = UINib(nibName: "SearchTableViewCell", bundle: nil)
        tableViewBooks.register(nib, forCellReuseIdentifier: "SearchTableViewCell")
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        bookShelf = bookShelfManager.fetchBooks()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        if let bookShelf = bookShelf {
            count = bookShelf.books.count
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableViewBooks.dequeueReusableCell(withIdentifier: "SearchTableViewCell", for: indexPath) as! SearchTableViewCell
        cell.lblBookTitle.text = bookShelf?.books[indexPath.row].title
        cell.lblBookAuthor.text = bookShelf?.books[indexPath.row].author
        cell.lblBookEdition.text = bookShelf?.books[indexPath.row].edition
        cell.lblPublishedYear.text = bookShelf?.books[indexPath.row].year
        let imageName = "\(bookShelf?.books[indexPath.row].id ?? "737930").jpg"//"yourImage.png"
        let image = UIImage(named: imageName)!
        cell.imgViewBook.image = image
        return cell
    }
    
}

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                    self?.image = image
                    }
                }
            }
        }
    }
}
