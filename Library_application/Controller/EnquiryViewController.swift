//
//  EnquiryViewController.swift
//  Library_application
//
//  Created by Andy Zhang on 12/5/21.
//

import Foundation
import UIKit

class EnquiryViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {

    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var enquiryField: UITextView!
    var username = ""
    let enquiryViewData = EnquiryViewData()
    
    @IBOutlet weak var btnEnquiry: UIBarButtonItem!
   
    @IBAction func onClickofLogout(_ sender: Any) {
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
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnEnquiry.tintColor = UIColor.init(red: 255.0/255.0, green: 35.0/255.0, blue: 5.0/255.0, alpha: 1.0)
        enquiryViewData.enquiryViewDefaultSetting(btnSubmit: submitButton)
    }
    
    // This delegate method for UITextField
     func textFieldShouldReturn(_ textField: UITextField) -> Bool {      //allows pop-up keyboard to close when pressing enter
        self.view.endEditing(true)
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "segueEnquiryToDashboard" )
        {
            let destinationController = segue.destination as! DashboardViewController
            destinationController.username = self.username;
        }
        if(segue.identifier == "segueEnquiryToSearch" )
        {
            let destinationController = segue.destination as! SearchViewController
            destinationController.username = self.username;
        }
        if(segue.identifier == "segueEnquiryToCheckout" )
        {
            let destinationController = segue.destination as! CheckoutViewController
            destinationController.username = self.username;
        }
        if(segue.identifier == "segueEnquiryRefresh" )
        {
            let destinationController = segue.destination as! EnquiryViewController
            destinationController.username = self.username;
        }
    }
    
    
    @IBAction func submitEnquiry(_ sender: Any) {
        var alert = UIAlertController(title: "Warning", message: "", preferredStyle: .alert)
        if (nameField.text == "" || emailField.text == "" || enquiryField.text == "")
        {
            alert  = UIAlertController(title: "Warning", message: "Please fill in all the fields before submit the enquiry!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
        } else
        {
        let alertVC = PMAlertController(title: "Enquiry Received", description: "We will get back in 2-3 working days. Contact Librarian for more support.", image: UIImage(named: "wecomeLogo.jpg"), style: .alert)
        
        alertVC.addAction(PMAlertAction(title: "OK", style: .default, action: { () in
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "DashboardViewController") as! DashboardViewController
            nextViewController.modalPresentationStyle = .fullScreen
            nextViewController.modalTransitionStyle = .crossDissolve
            self.present(nextViewController, animated: true)
        }))
        self.present(alertVC, animated: true, completion: nil)
    }

    }}
