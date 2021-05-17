//
//  CheckoutViewcontroller.swift
//  Library_application
//
//  Created by user190351 on 5/16/21.
//

import Foundation
import UIKit

class CheckoutViewController: UIViewController, cellCommunicateDelegate , UITableViewDelegate, UITableViewDataSource  {
    
    
    func addToCartTapped(at index: IndexPath) {
    //test
    }
    
    func viewPreviewTapped(at index: IndexPath) {
       print()
    }

    @IBOutlet weak var tableViewBooks: UITableView!
    var bookShelfManager = BookShelfManager()
    var bookShelf: BookShelf? = nil
    var tableViewBooksData: BookShelf? = nil
    var searchText: String? = nil
    var indexForCell = Int()
    var username = ""
    
    //Toolbar programatical navigation
    @IBAction func navigateDashboard(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                           let nextViewController = storyBoard.instantiateViewController(withIdentifier: "DashboardViewController") as! DashboardViewController
        nextViewController.username = self.username
        self.present(nextViewController, animated: true)
    }
    @IBAction func navigateSearch(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                           let nextViewController = storyBoard.instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
        nextViewController.username = self.username
        self.present(nextViewController, animated: true)
    }
    @IBAction func navigateCheckout(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                           let nextViewController = storyBoard.instantiateViewController(withIdentifier: "CheckoutViewController") as! CheckoutViewController
        nextViewController.username = self.username
        self.present(nextViewController, animated: true)
    }
    
    @IBAction func navigateEnquiry(_ sender: Any) {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "EnquiryViewController") as! EnquiryViewController
            nextViewController.username = self.username
        self.present(nextViewController, animated: true)
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bookShelf = bookShelfManager.fetchBooks()
        tableViewBooksData = getUpdatedTableViewData(bookShelf: bookShelf, searchText: searchText)
        tableViewBooks.delegate = self
        tableViewBooks.dataSource = self
        let nib = UINib(nibName: "SearchTableViewCell", bundle: nil)
        tableViewBooks.register(nib, forCellReuseIdentifier: "SearchTableViewCell")
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
            cell.btnAddToCart.isHidden = true
            let imageName = "\(tableViewBooksData?.books[indexPath.row].id ?? "737930").jpg"//"yourImage.png"
            let image = UIImage(named: imageName)!
            cell.btnBorrow.isEnabled = true
            cell.lblStatus.text = "In Cart"
            cell.lblStatus.textColor = UIColor.systemYellow
            cell.lblDueDate.text = ""
            cell.imgViewBook.image = image
            cell.delegate = self
            cell.indexPath = indexPath
            return cell
    }
        
    func removeFromCartTapped(at index: IndexPath) {
        let clickedCell = tableViewBooks.cellForRow(at: index) as! SearchTableViewCell
        let cellStatus:String? = clickedCell.lblStatus.text!
        let selectedBookId = clickedCell.lblISBN.text
        let commonProperty = CommonProperty()
        usersData = commonProperty.retrieveAndDecodeStoredUsersData()
        if let user = usersData.first(where: {$0.userID == username})
            {
            let usersDataIndex = usersData.firstIndex(where: {$0.userID == username})
            if(cellStatus == "Borrowed")
            {
                let keyExists = user.bookBorrowedArray[selectedBookId!] != nil
                if keyExists
                {
                    user.bookBorrowedArray.removeValue(forKey: selectedBookId!)
                    usersData.remove(at: usersDataIndex!)
                    usersData.append(user)
                    commonProperty.encodeAndStoreUsersData(usersData: usersData)
                }
            }
            else if (cellStatus == "In Cart")
            {
                let existInCart = user.bookInCartArray.contains(selectedBookId!)
                if existInCart
                {
                    let cartIndex = user.bookInCartArray.firstIndex(of: selectedBookId!)
                    user.bookInCartArray.remove(at: cartIndex!)
                    usersData.remove(at: usersDataIndex!)
                    usersData.append(user)
                    commonProperty.encodeAndStoreUsersData(usersData: usersData)
                }
            }
        }
        // Delete the row from the data source
        let intIndex = index.row
        tableViewBooksData?.books.remove(at: intIndex)
        tableViewBooks.deleteRows(at: [index], with: .fade)
        tableViewBooks.reloadData()
        }
    
    func borrowBookTapped(at index: IndexPath) {
        let clickedCell = tableViewBooks.cellForRow(at: index) as! SearchTableViewCell
        let now = Date()
        let selectedBookId = clickedCell.lblISBN.text
        let commonProperty = CommonProperty()
        usersData = commonProperty.retrieveAndDecodeStoredUsersData()
        if let user = usersData.first(where: {$0.userID == username})
        {
            let usersDataIndex = usersData.firstIndex(where: {$0.userID == username})
            var currentBooks: [String : Date]  = user.bookBorrowedArray
            let keyExists = currentBooks[selectedBookId!] != nil
            if !keyExists
            {
                currentBooks[selectedBookId!] = now
                user.bookBorrowedArray = currentBooks
                usersData.remove(at: usersDataIndex!)
                usersData.append(user)
                commonProperty.encodeAndStoreUsersData(usersData: usersData)
            }
        }
        let intIndex = index.row
        tableViewBooksData?.books.remove(at: intIndex)
        tableViewBooks.deleteRows(at: [index], with: .fade)
        tableViewBooks.reloadData()
        openAlertDialog()
    }

    fileprivate func openAlertDialog() {
        
        // This class creates the alert view
        let alert = PMAlertController(title: "Book Borrowed", description: "Return within 7 days to avoid dues", image: UIImage(named: "borrowedBook.png"), style: .alert)
        
        //Add action button to alert view
        alert.addAction(PMAlertAction(title: "OK", style: .default, action: { () in
        
        alert.dismiss(animated: true, completion: nil)
            
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    fileprivate func openReturnDialog() {
        
        // This class creates the alert view
        let alert = PMAlertController(title: "Book Returned", description: "Contact librarian for confirmation", image: UIImage(named: "wecomeLogo.png"), style: .alert)
        
        //Add action button to alert view
        alert.addAction(PMAlertAction(title: "OK", style: .default, action: { () in
        
        alert.dismiss(animated: true, completion: nil)
            
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false                            // The table view should not be editable by the user.
    }
    
    func getUpdatedTableViewData(bookShelf: BookShelf?, searchText: String?) -> BookShelf?
    {
        var booksData: BookShelf? = nil
        let commonProperty = CommonProperty()
        usersData = commonProperty.retrieveAndDecodeStoredUsersData()
        if let user = usersData.first(where: {$0.userID == username})
            {
            if var bookShelf = bookShelf {
            let books = bookShelf.books.filter { book in
               return user.bookInCartArray.contains(book.id)
            }
            bookShelf.books = books
            booksData = bookShelf
            }
            
        }
        return booksData
    }
}

