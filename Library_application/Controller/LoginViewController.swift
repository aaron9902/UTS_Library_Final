//
//  File.swift
//  Library_application
//
//  Created by Aaron Hyungju Lee on 11/5/21.
//

import Foundation


import UIKit

class LoginViewController: UIViewController {

    var curUserName: String = ""
    var curUserPassword: String = ""

    // Retrieve user database to runtime
    var userPassword: [String : String] = UserDefaults.standard.object(forKey: "Pass") as? [String : String] ?? [:]
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var loginWarningLabel: UILabel!
    
    @IBAction func login(_ sender: UIButton) {
        
        curUserName = username.text!
        curUserPassword = password.text!
        
        if (username.text == "" || password.text == "") {
            loginWarningLabel.text = "Please enter Username & Password"
        }
        else {
            // Store Latest Logged In User /the current logged in userName
            UserDefaults.standard.set(curUserName, forKey: "lastLoggedInUserName")
            UserDefaults.standard.set(curUserPassword, forKey: "Pass")
            
            // Next Page Determination
            
            if userPassword["\(curUserName)"] == curUserPassword {
                // Go to TabBarController VC if userExists
                performSegue(withIdentifier: "DashboardController", sender: self)
            }
            else if userPassword["\(curUserName)"] != curUserPassword {
                loginWarningLabel.text = "Username or Password is Invalid"
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
}
