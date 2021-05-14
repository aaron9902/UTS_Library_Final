//
//  EnquiryViewController.swift
//  Library_application
//
//  Created by Andy Zhang on 12/5/21.
//

import UIKit

class EnquiryViewController: UIViewController {

    @IBOutlet weak var submitButton: UIButton!
    
    @IBOutlet weak var nameField: UITextField!
    
    @IBOutlet weak var emailField: UITextField!
    
    @IBOutlet weak var enquiryField: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        submitButton.layer.borderWidth = 2
        submitButton.layer.borderColor = UIColor.white.cgColor
        submitButton.layer.cornerRadius = 10
    }


    @IBAction func submitEnquiry(_ sender: Any) {
        var alert = UIAlertController(title: "Warning", message: "", preferredStyle: .alert)
        if nameField.text == "" || emailField.text == "" || enquiryField.text == "" {
            alert  = UIAlertController(title: "Warning", message: "Please fill in all the fields before submit the enquiry!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
        } else {
            alert  = UIAlertController(title: "Warning", message: "You sure you want to submit the enquiry now?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .default))
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
                action in self.performSegue(withIdentifier: "goEnquiryConfirmed", sender: self)
            }))
        }
        self.present(alert, animated: true)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "goEnquiryConfirmed" {
            let vc = segue.destination as! EnquiryConfirmationViewController
            vc.studentName = nameField.text!
            vc.studentEmail = emailField.text!
        }
    }
}
