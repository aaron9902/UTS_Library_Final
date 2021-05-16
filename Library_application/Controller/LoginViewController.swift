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
    
    //let student = User(userID: "test", userPassword: "1234", bookBorrowedArray: [], bookInCartArray: [])
    let loginViewData = LoginViewData()

    // Retrieve user database to runtime
   // var userPassword: [String : String] = UserDefaults.standard.object(forKey: "Pass") as? [String : String] ?? [:]
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var stackViewLoginContainer: UIStackView!
    
    @IBOutlet weak var btnLogin: UIButton!
    @IBAction func login(_ sender: UIButton) {
        
        if (username.text == "" || password.text == "") {
            //loginWarningLabel.text = "Please enter Username & Password"
        }
        
        if !usersData.isEmpty {
            if let user = usersData.first(where: {$0.userID == username.text}) {
               // do something with foo
            } else {
               // item could not be found
            }
            
            
        } else {
            
        }
        
        
        curUserName = username.text!
        curUserPassword = password.text!
        
        if (username.text == "" || password.text == "") {
            //loginWarningLabel.text = "Please enter Username & Password"
        }
        else {
            // Store Latest Logged In User /the current logged in userName
            UserDefaults.standard.set(curUserName, forKey: "lastLoggedInUserName")
            UserDefaults.standard.set(curUserPassword, forKey: "Pass")
            
            // Next Page Determination
            
            /*if student.userPassword == curUserPassword {
                // Go to Dashboard VC if userExists
                performSegue(withIdentifier: "goToDashboard", sender: self)
            }
            else if student.userPassword != curUserPassword {
                //loginWarningLabel.text = "Username or Password is Invalid"
            }*/
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
    
    /*func openDialog(title: String, description: String, dialogType: String, confirmBtn: String?, confirmAction: String?, cancelBtn: String?, cancelAction: String?) {
        // This class creates the Alert View
        let dialog = PMAlertController(title: title, description: description, image: nil, style: dialogType == "walkthrough" ? .walkthrough : .alert)
        
        // This block of code perform cancel action when player hits Cancel button / No button on Alert Dialog
        if cancelBtn != nil {
            let cancelAct = cancelAction != nil ? cancelAction == "FocusNameTxtField" ? { () -> Void in self.txtName.becomeFirstResponder()} : {} : {}
            dialog.addAction(PMAlertAction(title: cancelBtn, style: .cancel, action: cancelAct))
        }
        
        // This block of code perform confirm action when player hits Ok button / Yes button on Alert Dialog
        if confirmBtn != nil {
            let confirmAct = confirmAction != nil ? confirmAction == "OpenGameSettingViewController" ? { () -> Void in
                
                // Navigate to Game Setting Sceen when play confirms to play with default player name. i.e. "Bubble Popper"
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let nextViewController = storyBoard.instantiateViewController(withIdentifier: "GameSettingViewController") as! GameSettingViewController
                nextViewController.gameSettingViewPlayerName = "Bubble Popper"
                self.navigationController!.pushViewController(nextViewController, animated: true)
            }
            : confirmAction == "FocusNameTxtField" ? { () -> Void in self.txtName.becomeFirstResponder()}
            : {} : {}
            dialog.addAction(PMAlertAction(title: confirmBtn, style: .default, action: confirmAct))
        }
        
        // present alert dialog to the player
        self.present(dialog, animated: true, completion: nil)
        
    }*/
}
