//
//  User.swift
//  Library_application
//
//  Created by Aaron Hyungju Lee on 11/5/21.
//

import Foundation
import UIKit

class UserData: Codable {

    var userID : String
    var userPassword : String
    var bookBorrowedArray: [String : Date] // Bookname + Borrowed Date
    var bookInCartArray: [String] // book names that student will borrow.
    
    init(userID:String, userPassword: String, bookBorrowedArray: [String: Date], bookInCartArray: [String]) {
        self.userID = userID
        self.userPassword = userPassword
        self.bookBorrowedArray = bookBorrowedArray
        self.bookInCartArray = bookInCartArray
    }
}
