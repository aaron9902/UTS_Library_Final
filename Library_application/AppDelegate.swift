//
//  AppDelegate.swift
//  Library_application
//
//  Created by Aaron Hyungju Lee on 9/5/21.
//

import UIKit

var usersData = [UserData]()
var bookShelf : BookShelf? = nil

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    
   // var userData = UserData(userID: String(), userPassword: String(), bookBorrowedArray: [String](), bookInCartArray: [String]())
    let commonProperty = CommonProperty()
    let bookShelfManager = BookShelfManager()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        usersData = commonProperty.retrieveAndDecodeStoredUsersData()
        if usersData.isEmpty {
            let user1 = UserData(userID: "13736626", userPassword: "1234", bookBorrowedArray: [String : Date](), bookInCartArray: [String]())
            let user2 = UserData(userID: "14085930", userPassword: "1234", bookBorrowedArray: [String : Date](), bookInCartArray: [String]())
            usersData.append(contentsOf: [user1,user2])
            commonProperty.encodeAndStoreUsersData(usersData: usersData)
        }
        
        bookShelf = bookShelfManager.fetchBooks()
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

