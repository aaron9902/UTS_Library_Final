//
//  LoginViewData.swift
//  Library_application
//
//  Created by user189640 on 5/16/21.
//

import Foundation
import UIKit

let appColor = UIColor.init(red: 15.0/255.0, green: 75.0/255.0, blue: 235.0/255.0, alpha: 1.0)

class LoginViewData: CommonProperty {
    
    let emptyTitle = "Username or Password is Empty"
    let emptyDescription = "Please enter your username and password."
    
    let invalidTitle = "Username or Password is Invalid"
    let invalidDescription = "Please enter your valid username and password."
        
    func loginViewcommonDefaultSetting(username: UITextField, password: UITextField, stackViewLoginContainer: UIStackView, btnLogin: UIButton) {
        setDefaultCustomTextFieldSettings(username)
        setDefaultCustomTextFieldSettings(password)
        setDefaultCustomStackViewSettings(stackViewLoginContainer)
        setDefaultCustomButtonSettings(btnLogin)
    }
}

class SearchViewData: CommonProperty {
            
    func searchViewcommonDefaultSetting(tableViewBooks: UITableView, searchBarSearchBooks: UISearchBar, lblResult: UILabel) {
        setDefaultCustomTableViewSettings(tableViewBooks)
        setDefaultCustomSearchBarSettings(searchBarSearchBooks)
        setDefaultCustomLabelSettings(lblResult)
    }
}

class CommonTableViewCell: CommonProperty {
    
    func commonTableViewCellDefaultSetting(btnAddToCart: UIButton, btnBorrow: UIButton, btnRemove: UIButton, btnPreview: UIButton, btnReturn: UIButton) {
        setDefaultCustomButtonSettings(btnAddToCart)
        setDefaultCustomButtonSettings(btnBorrow)
        setDefaultCustomButtonSettings(btnRemove)
        setDefaultCustomButtonSettings(btnPreview)
        setDefaultCustomButtonSettings(btnReturn)
    }
}

class DetailViewData: CommonProperty {
    
    func detailViewDefaultSetting (btnAddToCart: UIButton, btnBorrow: UIButton, btnReturn: UIButton, btnRemoveFromCart: UIButton) {
        setDefaultCustomButtonSettings(btnAddToCart)
        setDefaultCustomButtonSettings(btnBorrow)
        setDefaultCustomButtonSettings(btnReturn)
        setDefaultCustomButtonSettings(btnRemoveFromCart)
    }
    
}
    
    class EnquiryViewData: CommonProperty {
        
        func enquiryViewDefaultSetting (btnSubmit: UIButton) {
            setDefaultCustomButtonSettings(btnSubmit)
        }
}
