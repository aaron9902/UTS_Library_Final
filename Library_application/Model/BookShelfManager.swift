//
//  Book.swift
//  Library_application
//
//  Created by Aaron Hyungju Lee on 11/5/21.
//

import Foundation
import UIKit

class BookShelfManager {
   
    func fetchBooks(searchKey: String = "iOS Development") -> BookShelf? {
        var bookShelf: BookShelf? = nil
        if let localData = self.readLocalFile(forName: "books") {
            bookShelf = self.parse(jsonData: localData)
        }
        return bookShelf
    }
    
    private func readLocalFile(forName name: String) -> Data? {
        do {
            if let bundlePath = Bundle.main.path(forResource: name,
                                                 ofType: "json"),
                let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8) {
                return jsonData
            }
        } catch {
            print(error)
        }
        
        return nil
    }
    
    private func parse(jsonData: Data) -> BookShelf? {
        var bookShelf: BookShelf? = nil
        do {
            let decodedData = try JSONDecoder().decode(BookShelf.self, from: jsonData)
            bookShelf = decodedData
        } catch {
            print("decode error")
        }
        return bookShelf
    }
}
