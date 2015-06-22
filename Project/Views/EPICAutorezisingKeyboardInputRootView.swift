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
    private var originalFrame : CGRect!
    private var bottomOffset : CGFloat!
    
    //MARK: - lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        registerNotifications()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        registerNotifications()
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    //MARK: - notification handling
    private func registerNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillChangeFrame:"), name: UIKeyboardWillChangeFrameNotification, object: nil)
    }
    
    internal func keyboardWillChangeFrame(notification:NSNotification) {
        guard let notificationDictionary = notification.userInfo else {
            throwKeyboardNotificationAssertionFailure()
            return
        }
        guard let frame = notificationDictionary[UIKeyboardFrameEndUserInfoKey]?.CGRectValue else {
            throwKeyboardNotificationAssertionFailure()
            return
        }
        
        if !CGRectEqualToRect(frame, CGRectZero) {
            let keyboardTop = frame.origin.y;
            let keyboardBottom = keyboardTop + frame.size.height;            
            let viewBottom = originalFrame!.origin.y + originalFrame!.size.height;
            if keyboardTop >= viewBottom || keyboardBottom < viewBottom {
                //keyboard will hide or is ipad split keyboard
                UIView.animateWithKeyboardNotificationUserInfo(notificationDictionary, animation: { () -> Void in
                    self.frame = self.originalFrame!
                })
            } else {
                //keyboard will show
                var viewFrame = originalFrame!;
                viewFrame.size.height = originalFrame!.size.height-(viewBottom-keyboardTop)
                UIView.animateWithKeyboardNotificationUserInfo(notificationDictionary, animation: { () -> Void in
                    self.frame = viewFrame
                })
            }
        }
    }
    
    //MARK: - layout
    override func didMoveToWindow() {
        super.didMoveToWindow()
        let windowFrame = self.window!.frame
        bottomOffset = windowFrame.size.height-self.frame.origin.y-self.frame.size.height
    }
    
    override func layoutSubviews() {
        originalFrame = self.window!.frame
        originalFrame.origin.y = self.frame.origin.y
        originalFrame.size.height -= originalFrame.origin.y + bottomOffset
        super.layoutSubviews()
    }

}
