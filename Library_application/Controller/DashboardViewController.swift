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
    
    func borrowBookTapped(at index: IndexPath) {
        
    }
    
    
    @IBOutlet weak var tableViewBooks: UITableView!
    @IBOutlet weak var welcomeName : UILabel!
    @IBOutlet weak var dueStack: UIStackView!
    @IBOutlet weak var borrowStack: UIStackView!
    @IBOutlet weak var tableHeading: UILabel!
    @IBOutlet weak var borrowCount: UILabel!
    @IBOutlet weak var dueCount: UILabel!
    var bookShelfManager = BookShelfManager()
    var bookShelf: BookShelf? = nil
    var tableViewBooksData: BookShelf? = nil
    var searchText: String? = nil
    var username = ""
            
    @IBAction func overdueClicked(_ sender: Any) {
        dueStack.backgroundColor = UIColor.blue
        borrowStack.backgroundColor = UIColor.black
        tableHeading.text = "List of overdue books"
        tableViewBooksData = getUpdatedTableViewData(bookShelf: bookShelf, searchText: searchText)
        tableViewBooks.reloadData()
        dueCount.text = String((tableViewBooksData?.books.count)!)
    }
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
        welcomeName.text = username
        bookShelf = bookShelfManager.fetchBooks()
        tableViewBooksData = getUpdatedTableViewData(bookShelf: bookShelf, searchText: searchText)
        tableViewBooks.delegate = self
        tableViewBooks.dataSource = self
        borrowStack.backgroundColor = UIColor.blue
        let nib = UINib(nibName: "SearchTableViewCell", bundle: nil)
        tableViewBooks.register(nib, forCellReuseIdentifier: "SearchTableViewCell")
        if (((tableViewBooksData?.books.count)) != nil)
        {
            borrowCount.text = String((tableViewBooksData?.books.count)!)
        }
        if (((tableViewBooksData?.books.count)) != nil)
        {
            dueCount.text = String((tableViewBooksData?.books.count)!)
        }
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
            let intIndex = index.row
            tableViewBooksData?.books.remove(at: intIndex)
            tableViewBooks.deleteRows(at: [index], with: .fade)
            tableViewBooks.reloadData()
            openAlertDialog()
    }
    }
        
    @IBAction func onClickBooksBorrowed(_ sender: Any) {
        dueStack.backgroundColor = UIColor.black
        borrowStack.backgroundColor = UIColor.blue
        tableHeading.text = "List of borrowed books"
        tableViewBooksData = getUpdatedTableViewData(bookShelf: bookShelf, searchText: searchText)
        tableViewBooks.reloadData()
        borrowCount.text = String((tableViewBooksData?.books.count)!)
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
        if (((tableViewBooksData?.books.count)) != nil)
        {
            borrowCount.text = String((tableViewBooksData?.books.count)!)
        }
        if (((tableViewBooksData?.books.count)) != nil)
        {
            dueCount.text = String((tableViewBooksData?.books.count)!)
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
        cell.btnRemove.setTitle("Return", for: .normal)
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
    
    fileprivate func openAlertDialog() {
        
        // This class creates the alert view
        let alert = PMAlertController(title: "Book Returned", description: "Provide signature in library for ledger entry. Else dues will be charged.", image: UIImage(named: "wecomeLogo.png"), style: .alert)
        
        //Add action button to alert view
        alert.addAction(PMAlertAction(title: "OK", style: .default, action: { () in
        
        alert.dismiss(animated: true, completion: nil)
            
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
}
