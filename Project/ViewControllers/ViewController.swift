//
//  ViewController.swift
//  TES 2
//
//  Created by Danny Bravo on 18/04/2015.
//  Copyright (c) 2015 EPIC. All rights reserved.
//  See LICENSE.txt for this sample’s licensing information
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    //MARK: - view
    var castedView : View {
        return self.view as! View;
    }
    
    //MARK: - interaction
    @IBAction func showKeyboard() {
        castedView.hiddenTextField.becomeFirstResponder()
    }
    
    @IBAction func hideKeyboard() {
        castedView.hiddenTextField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        hideKeyboard()
        return false
    }
    

}

