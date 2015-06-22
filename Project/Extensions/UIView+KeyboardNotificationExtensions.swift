//
//  UIView+Extensions.swift
//  AutoresizingView
//
//  Created by Danny Bravo on 27/05/2015.
//  Copyright (c) 2015 DigitasLBi. All rights reserved.
//

import UIKit

private func throwKeyboardNotificationAssertionFailure() {
    assertionFailure("This method can only be called with a notification dictionary passed by a keyboard update notification. Could not find expected value keys for UIKeyboardAnimationDurationUserInfoKey and/or UIKeyboardAnimationCurveUserInfoKey values")
}

extension UIView {
    
    /**
    Convenience class function for creating an animation block using the values of a `NSNotification.userInfo` dictionary passed by a `UIKeyboardWillChangeFrameNotification`, `UIKeyboardWillShowNotification` or `UIKeyboardWillHideNotification`.
    
    - parameter notificationDictionary: The `userInfo` dictionary property of a `NSNotification` passed by a `UIKeyboardWillChangeFrameNotification`, `UIKeyboardWillShowNotification` or `UIKeyboardWillHideNotification` notification.
    
    - warning: This method will cause an assertion failure if the relevant keys `UIKeyboardAnimationDurationUserInfoKey` and `UIKeyboardAnimationCurveUserInfoKey` are not found in the notification dictionary
    */
    class func animateWithKeyboardNotificationUserInfo(notificationDictionary:[NSObject : AnyObject], animation:()->Void) {
        guard let duration = notificationDictionary[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber else {
            throwKeyboardNotificationAssertionFailure()
            return
        }
        guard let curve = notificationDictionary[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber else {
            throwKeyboardNotificationAssertionFailure()
            return
        }
        UIView.animateWithDuration(NSTimeInterval(duration.doubleValue), delay: 0, options: [UIViewAnimationOptions(rawValue: curve.unsignedLongValue), UIViewAnimationOptions.BeginFromCurrentState], animations: animation, completion: nil);
    }

    
}
