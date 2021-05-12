//
//  EnquiryConfirmationViewController.swift
//  Library_application
//
//  Created by Andy Zhang on 12/5/21.
//

import UIKit

class EnquiryConfirmationViewController: UIViewController {

    @IBOutlet weak var greetingLabel: UILabel!
    
    @IBOutlet weak var successMsgLabel: UILabel!
    
    @IBOutlet weak var backButton: UIButton!
    
    var studentName = ""
    
    var studentEmail = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        backButton.layer.borderWidth = 2
        backButton.layer.borderColor = UIColor.white.cgColor
        backButton.layer.cornerRadius = 10
        
        greetingLabel.text = "Hi, \(studentName)"
        successMsgLabel.text = "Thanks for your enquiry, we will get back to you as soon as possible. The reply email will send to your given email: \(studentEmail)"
        // Do any additional setup after loading the view.
    }
    


}
