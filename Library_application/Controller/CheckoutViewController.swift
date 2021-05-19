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
    }
    
    func returnBookTapped(at index: IndexPath) {
    }
    
    @IBOutlet weak var btnCheckout: UIBarButtonItem!
    
    func viewPreviewTapped(at index: IndexPath) {
        let selectedBookID = (tableViewBooks.cellForRow(at: index) as! SearchTableViewCell).lblISBN.text
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        nextViewController.modalPresentationStyle = .fullScreen
        nextViewController.modalTransitionStyle = .crossDissolve
        nextViewController.username = "13736626"//self.username
        nextViewController.bookId = selectedBookID!
        self.present(nextViewController, animated: true)
        
    }
    
    func removeFromCartTapped(at index: IndexPath) {
        let selectedBookID = (tableViewBooks.cellForRow(at: index) as! SearchTableViewCell).lblISBN.text
        if let user = user {
            if user.bookInCartArray.contains(selectedBookID!) { user.bookInCartArray.remove(at: (user.bookInCartArray as NSArray).index(of: selectedBookID!))}
            if user.bookBorrowedArray.keys.contains(selectedBookID!) { user.bookBorrowedArray[selectedBookID!] = nil }
            
            usersData.remove(at: usersData.firstIndex(where: {$0.userID == user.userID})!)
            usersData.append(user)
            commonProperty.encodeAndStoreUsersData(usersData: usersData)
            openDialog(title: "Book Removed", description: "Book is removed from your Cart.", image: UIImage(named: "bookCart.png")!)
        }
    }
    
    @IBAction func onClickofLogout(_ sender: Any) {
        let alertVC = PMAlertController(title: "Confirm Logout", description: "Are you sure you want to logout?", image: UIImage(named: "Logout.jpg"), style: .alert)
        
        alertVC.addAction(PMAlertAction(title: "Cancel", style: .cancel, action: {}))
        
        alertVC.addAction(PMAlertAction(title: "OK", style: .default, action: { () in
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            nextViewController.modalPresentationStyle = .fullScreen
            nextViewController.modalTransitionStyle = .crossDissolve
            self.present(nextViewController, animated: true)
        }))
        
        self.present(alertVC, animated: true, completion: nil)

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "segueCheckoutToDashboard" )
        {
            let destinationController = segue.destination as! DashboardViewController
            destinationController.username = self.username;
        }
        if(segue.identifier == "segueCheckoutToSearch" )
        {
            let destinationController = segue.destination as! SearchViewController
            destinationController.username = self.username;
        }
        if(segue.identifier == "segueCheckoutToEnquiry" )
        {
            let destinationController = segue.destination as! EnquiryViewController
            destinationController.username = self.username;
        }
        if(segue.identifier == "segueCheckoutRefresh" )
        {
            let destinationController = segue.destination as! CheckoutViewController
            destinationController.username = self.username;
        }
    }
    
    func borrowBookTapped(at index: IndexPath) {
        let selectedBookID = (tableViewBooks.cellForRow(at: index) as! SearchTableViewCell).lblISBN.text
        if let user = user {
            
            var dayComponent = DateComponents()
            dayComponent.day = 7
            let dueDate = Calendar.current.date(byAdding: dayComponent, to: Date())
            if user.bookBorrowedArray.keys.contains(selectedBookID!) { user.bookBorrowedArray[selectedBookID!] = dueDate }
            else { user.bookBorrowedArray[selectedBookID!] = dueDate }
            
            if user.bookInCartArray.contains(selectedBookID!) { user.bookInCartArray.remove(at: (user.bookInCartArray as NSArray).index(of: selectedBookID!))}
            
            usersData.remove(at: usersData.firstIndex(where: {$0.userID == user.userID})!)
            usersData.append(user)
            commonProperty.encodeAndStoreUsersData(usersData: usersData)
            
            openDialog(title: "Book Borrowed", description: "Go to Dashboard to view your borrowed books. Return within 7 days to avoid dues.", image: UIImage(named: "borrowedBook.png")!)
        }
        
    }
    
    @IBOutlet weak var tableViewBooks: UITableView!
    //var bookShelfManager = BookShelfManager()
    //var bookShelf: BookShelf? = nil
    var tableViewBooksData: BookShelf? = nil
    var searchText: String? = nil
    var indexForCell = Int()
    var username = ""
    var user: UserData? = nil
    let commonProperty = CommonProperty()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnCheckout.tintColor = UIColor.init(red: 255.0/255.0, green: 35.0/255.0, blue: 5.0/255.0, alpha: 1.0)
        
        if !usersData.isEmpty {
            user = usersData.first(where: {$0.userID == username})
        }
        //bookShelf = bookShelfManager.fetchBooks()
        tableViewBooksData = getUpdatedTableViewData(bookShelf: bookShelf)
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
        
        if let tableViewBooksData = tableViewBooksData, let user = user {
            let bookId = tableViewBooksData.books[indexPath.row].id
            cell.imgViewBook.image = UIImage(named: "\(bookId).jpg")!
            cell.lblBookTitle.text = tableViewBooksData.books[indexPath.row].title
            cell.lblBookAuthor.text = tableViewBooksData.books[indexPath.row].author
            cell.lblBookEdition.text = tableViewBooksData.books[indexPath.row].edition
            cell.lblPublishedYear.text = tableViewBooksData.books[indexPath.row].year
            cell.lblISBN.text = bookId
            cell.btnPreview.isHidden = false
            if user.bookInCartArray.contains(bookId) {
                cell.lblStatus.text = "In Cart"
                cell.lblStatus.textColor = UIColor.systemYellow
                cell.lblDueDate.isHidden = true
                cell.btnAddToCart.isHidden = true
                cell.btnBorrow.isHidden = false
                cell.btnRemove.isHidden = false
                cell.btnReturn.isHidden = true
                
            }
        }
        cell.delegate = self
        cell.indexPath = indexPath
        return cell
    }
    
    
    
    fileprivate func openDialog(title: String, description: String, image: UIImage) {
        let alert = PMAlertController(title: title, description: description, image: image, style: .alert)
        alert.addAction(PMAlertAction(title: "OK", style: .default, action: { () in
            self.tableViewBooksData = self.getUpdatedTableViewData(bookShelf: bookShelf)
            self.tableViewBooks.reloadData()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false                            // The table view should not be editable by the user.
    }
    
    func getUpdatedTableViewData(bookShelf: BookShelf?) -> BookShelf?
    {
        var booksData: BookShelf? = nil
        if let user = user
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

