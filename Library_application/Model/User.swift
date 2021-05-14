//
//  User.swift
//  Library_application
//
//  Created by Aaron Hyungju Lee on 11/5/21.
//

import Foundation
import UIKit

class User{
    
    var userID : String
    var userPassword : String
    
    var bookBorrowedArray = [String]() // Bookname + Borrowed Date
    var bookInCartArray = [String]() // book names that student will borrow.
    
    init (userID : String, userPassword: String, bookBorrowedArray : [String], bookInCartArray : [String]) {
        self.userID = userID
        self.userPassword = userPassword
        self.bookBorrowedArray  = bookBorrowedArray
        self.bookInCartArray = bookInCartArray
    }
    
    func addBookInCart (newBookName :String){
        
        bookInCartArray.append(newBookName)
    }
    
    func borrowBooks (newBooks : [String]) {
        
        for bookName in bookInCartArray {
        
        bookBorrowedArray.append(bookName)
            
        }
    }
}
