//
//  File.swift
//  Library_application
//
//  Created by Aaron Hyungju Lee on 11/5/21.
//

import Foundation


import UIKit

class DashboardViewController: UIViewController, cellCommunicateDelegate, UITableViewDelegate, UITableViewDataSource  {

    var overDueFlag = false
    
    func addToCartTapped(at index: IndexPath) {
        
    }
    
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
            
            openDialog(title: "Book Borrowed", description: "Return within 7 days to avoid dues.", image: UIImage(named: "borrowedBook.png")!)
        }
        
    }
    
    func removeFromCartTapped(at index: IndexPath) {
        
    }
    
    
    @IBOutlet weak var btnDashboard: UIBarButtonItem!
    
    @IBOutlet weak var tableViewBooks: UITableView!
    @IBOutlet weak var welcomeName : UILabel!
    @IBOutlet weak var dueStack: UIStackView!
    @IBOutlet weak var borrowStack: UIStackView!
    @IBOutlet weak var tableHeading: UILabel!
    @IBOutlet weak var borrowCount: UILabel!
    @IBOutlet weak var dueCount: UILabel!
    var user: UserData? = nil
    let commonProperty = CommonProperty()
    var tableViewBooksData: BookShelf? = nil
    var searchText: String? = nil
    var username = ""
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "segueDashboardToSearch" )
        {
            let destinationController = segue.destination as! SearchViewController
            destinationController.username = self.username;
        }
        if(segue.identifier == "segueDashboardToCheckout" )
        {
            let destinationController = segue.destination as! CheckoutViewController
            destinationController.username = self.username;
        }
        if(segue.identifier == "segueDashboardToEnquiry" )
        {
            let destinationController = segue.destination as! EnquiryViewController
            destinationController.username = self.username;
        }
        if(segue.identifier == "segueDashboardRefresh" )
        {
            let destinationController = segue.destination as! DashboardViewController
            destinationController.username = self.username;
        }
    }
            
    @IBAction func logoutClicked(_ sender: Any) {
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
    @IBAction func overdueClicked(_ sender: UIButton) {
        overDueFlag = true
        dueStack.backgroundColor = UIColor.blue
        borrowStack.backgroundColor = UIColor.black
        tableHeading.text = "List of overdue books"
        tableViewBooksData = getUpdatedTableViewData(bookShelf: bookShelf, overdueFlag: overDueFlag)
        tableViewBooks.reloadData()
        dueCount.text = String((tableViewBooksData?.books.count)!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overDueFlag = false
        btnDashboard.tintColor = UIColor.init(red: 255.0/255.0, green: 35.0/255.0, blue: 5.0/255.0, alpha: 1.0)
        if !usersData.isEmpty {
            user = usersData.first(where: {$0.userID == username}) //username
        }
        welcomeName.text = username
        tableViewBooksData = getUpdatedTableViewData(bookShelf: bookShelf, overdueFlag: overDueFlag)
        tableViewBooks.delegate = self
        tableViewBooks.dataSource = self
        borrowStack.backgroundColor = UIColor.blue
        let nib = UINib(nibName: "SearchTableViewCell", bundle: nil)
        tableViewBooks.register(nib, forCellReuseIdentifier: "SearchTableViewCell")
        if let borrow = getUpdatedTableViewData(bookShelf: bookShelf, overdueFlag: false) {
            borrowCount.text = String(borrow.books.count)
        }
        if let overdue = getUpdatedTableViewData(bookShelf: bookShelf, overdueFlag: true) {
            dueCount.text = String(overdue.books.count)
        }

    }

    func returnBookTapped(at index: IndexPath) {
        let selectedBookID = (tableViewBooks.cellForRow(at: index) as! SearchTableViewCell).lblISBN.text
        if let user = user {
            if user.bookInCartArray.contains(selectedBookID!) { user.bookInCartArray.remove(at: (user.bookInCartArray as NSArray).index(of: selectedBookID!))}
            if user.bookBorrowedArray.keys.contains(selectedBookID!) { user.bookBorrowedArray[selectedBookID!] = nil }
            usersData.remove(at: usersData.firstIndex(where: {$0.userID == user.userID})!)
            usersData.append(user)
            commonProperty.encodeAndStoreUsersData(usersData: usersData)
            
            openDialog(title: "Book Returned", description: "Contact librarian for confirmation.", image: UIImage(named: "wecomeLogo.png")!)
        }
    }
    
    
    fileprivate func openDialog(title: String, description: String, image: UIImage) {
        let alert = PMAlertController(title: title, description: description, image: image, style: .alert)
        alert.addAction(PMAlertAction(title: "OK", style: .default, action: { () in
        
            self.tableViewBooksData = self.getUpdatedTableViewData(bookShelf: bookShelf, overdueFlag: self.overDueFlag)
            self.tableViewBooks.reloadData()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
        
    @IBAction func onClickBooksBorrowed(_ sender: UIButton) {
        overDueFlag = false
        dueStack.backgroundColor = UIColor.black
        borrowStack.backgroundColor = UIColor.blue
        tableHeading.text = "List of borrowed books"
        tableViewBooksData = getUpdatedTableViewData(bookShelf: bookShelf, overdueFlag: overDueFlag)
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
        
        if let tableViewBooksData = tableViewBooksData, let user = user {
            let bookId = tableViewBooksData.books[indexPath.row].id
            cell.imgViewBook.image = UIImage(named: "\(bookId).jpg")!
            cell.lblBookTitle.text = tableViewBooksData.books[indexPath.row].title
            cell.lblBookAuthor.text = tableViewBooksData.books[indexPath.row].author
            cell.lblBookEdition.text = tableViewBooksData.books[indexPath.row].edition
            cell.lblPublishedYear.text = tableViewBooksData.books[indexPath.row].year
            cell.lblISBN.text = bookId
            cell.btnPreview.isHidden = false
            if user.bookBorrowedArray.keys.contains(bookId) {
                cell.lblDueDate.isHidden = false
                
                let dueDate = commonProperty.getFormattedDateString(user.bookBorrowedArray[bookId]!)
                cell.lblDueDate.text = "Due: \(dueDate)"
                
                if commonProperty.getDifferenceInDaysWithCurrentDate(dueDate) < 7 {
                    cell.lblStatus.text = "Borrowed/Overdue"
                    cell.lblStatus.textColor = UIColor.systemRed
                } else {
                    cell.lblStatus.text = "Borrowed"
                    cell.lblStatus.textColor = appColor
                }
                
                cell.btnAddToCart.isHidden = true
                cell.btnBorrow.isHidden = true
                cell.btnRemove.isHidden = true
                cell.btnReturn.isHidden = false
            } 
        }
               
        cell.delegate = self
        cell.indexPath = indexPath
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false                            // The table view should not be editable by the user.
    }
    
    func getUpdatedTableViewData(bookShelf: BookShelf?, overdueFlag : Bool) -> BookShelf? {
        var booksData: BookShelf? = nil
        if let user = user
        {
            if var bookShelf = bookShelf {
                let books = bookShelf.books.filter { book in
                    var flag = false
                        if user.bookBorrowedArray.keys.contains(book.id) {
                            if overdueFlag {
                                let dueDate = commonProperty.getFormattedDateString(user.bookBorrowedArray[book.id]!)
                                flag = commonProperty.getDifferenceInDaysWithCurrentDate(dueDate) < 7
                            } else { flag = true }
                        }
                    return flag
                }
                bookShelf.books = books
                booksData = bookShelf
            }
            
        }
            return booksData
    }
}
