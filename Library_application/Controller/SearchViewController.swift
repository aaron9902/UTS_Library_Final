//
//  File.swift
//  Library_application
//
//  Created by Mehul Makwana on 11/5/21.
//

import Foundation
import UIKit

class SearchViewController: UIViewController, cellCommunicateDelegate, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {
    
    
    
    let searchViewData = SearchViewData()
    var username = ""
    @IBOutlet weak var tableViewBooks: UITableView!
    @IBOutlet weak var searchBarSearchBooks: UISearchBar!
    @IBOutlet weak var lblResult: UILabel!
    @IBOutlet weak var btnLogout: UIButton!
    
    //Toolbar programatical navigation
    //@IBAction func onClickOfSearch(_ sender: Any) {
      //  self.viewDidLoad()
    //}

    
    //var bookShelfManager = BookShelfManager()
    //var bookShelf: BookShelf? = nil
    var tableViewBooksData: BookShelf? = nil
    var searchTextInput: String? = nil
    var user: UserData? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchViewData.searchViewcommonDefaultSetting(tableViewBooks: tableViewBooks, searchBarSearchBooks: searchBarSearchBooks, lblResult: lblResult)
        
        if !usersData.isEmpty {
            user = usersData.first(where: {$0.userID == "13736626"}) //username
        }
        
        lblResult.text = "Recommended Books"
        tableViewBooksData = getUpdatedTableViewData(bookShelf: bookShelf, searchText: searchTextInput)
        tableViewBooks.delegate = self
        tableViewBooks.dataSource = self
        let nib = UINib(nibName: "SearchTableViewCell", bundle: nil)
        tableViewBooks.register(nib, forCellReuseIdentifier: "SearchTableViewCell")
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToDashboardFromSearchView" {
            let destinationVC = segue.destination as! DashboardViewController
            destinationVC.username = username
        }
        if segue.identifier == "goToCheckoutFromSearchView" {
            let destinationVC = segue.destination as! CheckoutViewController
            destinationVC.username = username
        }
        if segue.identifier == "goToEnquiryFromSearchView" {
            let destinationVC = segue.destination as! EnquiryViewController
            destinationVC.username = username
        }
        if segue.identifier == "goToSearchFromSearchView" {
            let destinationVC = segue.destination as! SearchViewController
            destinationVC.username = username
        }
    }
    
    @IBAction func onClickOfLogout(_ sender: UIButton) {
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
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        let inputString = searchText.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        
        if inputString.count > 0
        {
            tableViewBooksData = getUpdatedTableViewData(bookShelf: bookShelf, searchText: inputString)
            if tableViewBooksData?.books.count ?? 0 > 0 { lblResult.text = "Search Reasult" }
            else { lblResult.text = "No Books Found" }
        }
        else
        {
            tableViewBooksData = getUpdatedTableViewData(bookShelf: bookShelf, searchText: inputString)
            lblResult.text = "Recommended Books"
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
                
            } else if user.bookBorrowedArray.keys.contains(bookId) {
                cell.lblDueDate.isHidden = false
                
                let dueDate = searchViewData.getFormattedDateString(user.bookBorrowedArray[bookId]!)
                cell.lblDueDate.text = "Due: \(dueDate)"
                
                if searchViewData.getDifferenceInDaysWithCurrentDate(dueDate) < 7 {
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
            } else {
                cell.lblStatus.text = "Available"
                cell.lblStatus.textColor = UIColor.systemGreen
                cell.lblDueDate.isHidden = true
                cell.btnAddToCart.isHidden = false
                cell.btnBorrow.isHidden = true
                cell.btnRemove.isHidden = true
                cell.btnReturn.isHidden = true
            }
        }
        
        /*cell.lblBookTitle.text = tableViewBooksData?.books[indexPath.row].title
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
        }*/
        cell.delegate = self
        cell.indexPath = indexPath
        return cell
    }
    
    func addToCartTapped(at index: IndexPath) {
        let selectedBookID = (tableViewBooks.cellForRow(at: index) as! SearchTableViewCell).lblISBN.text
        if let user = user {
            if !user.bookInCartArray.contains(selectedBookID!) { user.bookInCartArray.append(selectedBookID!) }
            if user.bookBorrowedArray.keys.contains(selectedBookID!) { user.bookBorrowedArray[selectedBookID!] = nil }
            usersData.remove(at: usersData.firstIndex(where: {$0.userID == user.userID})!)
            usersData.append(user)
            searchViewData.encodeAndStoreUsersData(usersData: usersData)
            
            openDialog(title: "Book Added", description: "Book is added to your Cart.", image: UIImage(named: "bookCart.png")!)
        }
    }
    
    func returnBookTapped(at index: IndexPath) {
        let selectedBookID = (tableViewBooks.cellForRow(at: index) as! SearchTableViewCell).lblISBN.text
        if let user = user {
            if user.bookInCartArray.contains(selectedBookID!) { user.bookInCartArray.remove(at: (user.bookInCartArray as NSArray).index(of: selectedBookID!))}
            if user.bookBorrowedArray.keys.contains(selectedBookID!) { user.bookBorrowedArray[selectedBookID!] = nil }
            usersData.remove(at: usersData.firstIndex(where: {$0.userID == user.userID})!)
            usersData.append(user)
            searchViewData.encodeAndStoreUsersData(usersData: usersData)
            
            openDialog(title: "Book Returned", description: "Contact librarian for confirmation.", image: UIImage(named: "wecomeLogo.png")!)
        }
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
    
    func removeFromCartTapped(at index: IndexPath) {
        let selectedBookID = (tableViewBooks.cellForRow(at: index) as! SearchTableViewCell).lblISBN.text
        if let user = user {
            if user.bookInCartArray.contains(selectedBookID!) { user.bookInCartArray.remove(at: (user.bookInCartArray as NSArray).index(of: selectedBookID!))}
            if user.bookBorrowedArray.keys.contains(selectedBookID!) { user.bookBorrowedArray[selectedBookID!] = nil }
    
            usersData.remove(at: usersData.firstIndex(where: {$0.userID == user.userID})!)
            usersData.append(user)
            searchViewData.encodeAndStoreUsersData(usersData: usersData)
            openDialog(title: "Book Removed", description: "Book is removed from your Cart.", image: UIImage(named: "bookCart.png")!)
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
            searchViewData.encodeAndStoreUsersData(usersData: usersData)
            
            openDialog(title: "Book Borrowed", description: "Return within 7 days to avoid dues.", image: UIImage(named: "borrowedBook.png")!)
        }
        
    }
    
    fileprivate func openDialog(title: String, description: String, image: UIImage) {
        let alert = PMAlertController(title: title, description: description, image: image, style: .alert)
        alert.addAction(PMAlertAction(title: "OK", style: .default, action: { () in
            self.tableViewBooks.reloadData()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    func getUpdatedTableViewData(bookShelf: BookShelf?, searchText: String?) -> BookShelf? {
        var booksData: BookShelf? = nil
        if var bookShelf = bookShelf {
            if let searchText = searchText != nil && searchText != "" ? searchText : nil {
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
