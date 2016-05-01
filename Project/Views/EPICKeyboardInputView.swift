//
//  EPICKeyboardInputView.swift
//  EPIC
//  Created by Danny Bravo on 18/04/2015.
//
//  Created by Danny Bravo on 27/05/2015.
//  Copyright (c) 2015 EPIC. All rights reserved.
//  See LICENSE.txt for this sample’s licensing information
//
//  Version 2.0

import UIKit

private func throwKeyboardNotificationAssertionFailure() {
    assertionFailure("This method should only be called using a keyboard update notification. Failed to retrieve the correct keyboard notification information.")
}

class EPICKeyboardInputView : UIView {
    
    //MARK: - lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    ///A convenience function for grouping together common post initialization tasks, like registering notifications and gestures into the view
    final private func commonInit() {
        registerNotifications()
        registerGestures()
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    //MARK: - gesture handling
    private func registerGestures() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(EPICKeyboardInputView.tapDetected))
        self.addGestureRecognizer(gesture)
    }
    
    ///The tap gesture recognizer's action. Dismisses all responders from the view
    internal func tapDetected() {
        self.endEditing(true)
    }
    
    //MARK: - notification handling
    private func registerNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(EPICKeyboardInputView.keyboardWillChangeFrame(_:)), name: UIKeyboardWillChangeFrameNotification, object: nil)
    }
    
    /**
     Generic function for managing keyboard frame changes. Should only ever be fired by a `UIKeyboard` notification
     
     - parameter notification: The notification object forwarded by a `UIKeyboard` notification
     
     - warning: This method will cause an assertion failure if the notification does not have a `userInfo` dictionary or if the key `UIKeyboardFrameEndUserInfoKey` are not found in the notification dictionary
     */
    internal func keyboardWillChangeFrame(notification:NSNotification) {
        guard let notificationDictionary = notification.userInfo, let keyboardFrame = notificationDictionary[UIKeyboardFrameEndUserInfoKey]?.CGRectValue else {
            assertionFailure("This method should only be called by a UIKeyboardWillChangeFrameNotification")
            return
        }
        guard let windowFrame = window?.frame else {
            assertionFailure("The view does not belong to the window hierarchy")
            return
        }
        
        if keyboardFrame != CGRect.zero {
            let keyboardHeight = keyboardFrame.size.height
            let keyboardVisible = windowFrame.contains(keyboardFrame) && keyboardFrame.origin.y + keyboardHeight >= windowFrame.height
            if keyboardVisible {
                //keyboard will show
                UIView.animateWithKeyboardNotificationUserInfo(notificationDictionary, animation: { [weak self] () -> Void in
                    self?.layoutForKeyboardWithHeight(keyboardHeight)
                    })
            } else {
                //keyboard will hide or is ipad split keyboard
                UIView.animateWithKeyboardNotificationUserInfo(notificationDictionary, animation: { [weak self] () -> Void in
                    self?.layoutForKeyboardWithHeight(0)
                    })
            }
        }
    }
    
    func layoutForKeyboardWithHeight(keyboardHeight: CGFloat) {
        var bounds = UIScreen.mainScreen().bounds
        bounds.size.height -= keyboardHeight
        self.frame = bounds
    }
    
}