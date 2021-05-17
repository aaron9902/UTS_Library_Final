//
//  File.swift
//  Library_application
//
//  Created by Aaron Hyungju Lee on 11/5/21.
//

import Foundation
import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {

    var curUserName: String = ""
    var curUserPassword: String = ""
    let loginViewData = LoginViewData()
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var stackViewLoginContainer: UIStackView!
    
    @IBOutlet weak var btnLogin: UIButton!
    @IBAction func login(_ sender: UIButton) {
        
        if (username.text == "" || password.text == "") {
            openAlertDialog(title: loginViewData.emptyTitle, description: loginViewData.emptyDescription)
        }
        
        if !usersData.isEmpty {
            if let user = usersData.first(where: {$0.userID == username.text}) {
                if user.userPassword == password.text {
                    // Navigate to Dashboard Sceen when user enter correct username and password
                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                    let nextViewController = storyBoard.instantiateViewController(withIdentifier: "DashboardViewController") as! DashboardViewController
                    nextViewController.username = user.userID
                    self.present(nextViewController, animated: true)
                } else {
                    openAlertDialog(title: loginViewData.invalidTitle, description: loginViewData.invalidDescription)
                }
            } else {
                openAlertDialog(title: loginViewData.invalidTitle, description: loginViewData.invalidDescription)
            }
        } else {
            openAlertDialog(title: loginViewData.invalidTitle, description: loginViewData.invalidDescription)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginViewData.loginViewcommonDefaultSetting(username: username, password: password, stackViewLoginContainer: stackViewLoginContainer,btnLogin: btnLogin)
        username.keyboardType = .numberPad
    }
    // This delegate method for UITextField
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    fileprivate func openAlertDialog(title: String, description: String) {
        
        // This class creates the alert view
        let alert = PMAlertController(title: title, description: description, image: nil, style: .alert)
        
        // Add action button to alert view
        alert.addAction(PMAlertAction(title: "OK", style: .default, action: { () in
            self.username.becomeFirstResponder()
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
}
