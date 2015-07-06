//
//  View.swift
//  TES 2
//
//  Created by Danny Bravo on 18/04/2015.
//  Copyright (c) 2015 EPIC. All rights reserved.
//  See LICENSE.txt for this sample’s licensing information
//

import UIKit

private func throwKeyboardNotificationAssertionFailure() {
    assertionFailure("This method should only be called using a keyboard update notification. Failed to retrieve the correct keyboard notification information.")
}

class EPICAutoresizingKeyboardInputRootView : UIView {
    
    //MARK: - variables
    ///The frame the root view is expected to have when the keyboard is not present, a reference is kept so that it can be varied with rotation.
    private var fullViewFrame : CGRect!
    
    ///A background tap gesture used for dismissing the keyboard when the view has an active first responder
    private(set) var tapGesture : UITapGestureRecognizer!
    
    //MARK: - lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    ///A convenience function for grouping together common post initialization tasks, like registering notifications and gestures into the view
    private func commonInit() {
        registerNotifications()
        registerGestures()
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    //MARK: - gesture handling
    private func registerGestures() {
        tapGesture = UITapGestureRecognizer(target: self, action: "tapDetected")
        self.addGestureRecognizer(tapGesture)
    }
    
    ///The tap gesture recognizer's action. Dismisses all responders from the view
    internal func tapDetected() {
        self.endEditing(true)
    }
    
    //MARK: - notification handling
    private func registerNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillChangeFrame:"), name: UIKeyboardWillChangeFrameNotification, object: nil)
    }
    
    /**
    Generic function for managing keyboard frame changes. Should only ever be fired by a `UIKeyboard` notification
    
    - parameter notification: The notification object forwarded by a `UIKeyboard` notification
    
    - warning: This method will cause an assertion failure if the notification does not have a `userInfo` dictionary or if the key `UIKeyboardFrameEndUserInfoKey` are not found in the notification dictionary
    */
    internal func keyboardWillChangeFrame(notification:NSNotification) {
        guard let notificationDictionary = notification.userInfo else {
            throwKeyboardNotificationAssertionFailure()
            return
        }
        guard let keyboardFrame = notificationDictionary[UIKeyboardFrameEndUserInfoKey]?.CGRectValue else {
            throwKeyboardNotificationAssertionFailure()
            return
        }
        
        if !CGRectEqualToRect(keyboardFrame, CGRectZero) {
            let keyboardTop = keyboardFrame.origin.y
            let viewBottom = fullViewFrame!.origin.y + fullViewFrame!.size.height
            if keyboardTop >= viewBottom || keyboardTop + keyboardFrame.size.height < viewBottom {
                //keyboard will hide or is ipad split keyboard
                UIView.animateWithKeyboardNotificationUserInfo(notificationDictionary, animation: { () -> Void in
                    self.frame = self.fullViewFrame!
                })
            } else {
                //keyboard will show
                var viewFrame = fullViewFrame!
                viewFrame.size.height = fullViewFrame!.size.height-(viewBottom-keyboardTop)
                UIView.animateWithKeyboardNotificationUserInfo(notificationDictionary, animation: { () -> Void in
                    self.frame = viewFrame
                })
            }
        }
    }
    
    //MARK: - layout
    override func layoutSubviews() {
        fullViewFrame = self.window!.frame
        super.layoutSubviews()
    }
    
}
