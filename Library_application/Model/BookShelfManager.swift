//
//  Book.swift
//  Library_application
//
//  Created by Aaron Hyungju Lee on 11/5/21.
//

import Foundation
import UIKit

class BookShelfManager {
    let booksAPIURL = "https://www.googleapis.com/books/v1/volumes?key=AIzaSyA1JA0yPkfRBD4x0FUt2wHhK7OO04ArZJI&q="
    
    
    func fetchBooks(searchKey: String = "iOS Development") -> BookShelf? {
        var bookShelf: BookShelf? = nil
        var allowedQueryParamAndKey = NSCharacterSet.urlQueryAllowed
        allowedQueryParamAndKey.remove(charactersIn: ";/?:@&=+$, ")
        
        if let encodedSearchKey = searchKey.addingPercentEncoding(withAllowedCharacters: allowedQueryParamAndKey) {
            bookShelf = performSearch(encodedSearchKey: encodedSearchKey)
        }
        return bookShelf
    }
    
    func performSearch(encodedSearchKey: String) -> BookShelf? {
        var bookShelf: BookShelf? = nil
        let semaphore = DispatchSemaphore(value: 0)
        let urlString = booksAPIURL + encodedSearchKey
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print(error!)
                    return
                }
                if let safeData = data {
                    
                    bookShelf = self.parseJSON(bookShelf: safeData)
                    semaphore.signal()
                }
            }
            task.resume()
            semaphore.wait()
        }
        return bookShelf
    }
    
    func parseJSON(bookShelf: Data) -> BookShelf? {
        var bookData: BookShelf? = nil
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(BookShelf.self, from: bookShelf)
            bookData = decodedData
        } catch {
            print(error)
        }
        return bookData
    }
}
