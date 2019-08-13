//
//  KeyboardInfo.swift
//  Chat View
//
//  Created by H on 13/08/2019.
//  Copyright © 2019 H. All rights reserved.
//

import UIKit

struct KeyboardInfo {
    var animationCurve: UIView.AnimationCurve
    var animationOption: UIView.AnimationOptions
    var animationDuration: Double
    var isLocal: Bool
    var frameBegin: CGRect
    var frameEnd: CGRect
}

extension KeyboardInfo {
    init?(_ notification: Notification) {
        guard notification.name == UIResponder.keyboardWillShowNotification || notification.name == UIResponder.keyboardWillHideNotification || notification.name == UIResponder.keyboardWillChangeFrameNotification else { return nil }
        let u = notification.userInfo!
        
        animationCurve = UIView.AnimationCurve(rawValue: u[UIWindow.keyboardAnimationCurveUserInfoKey] as! Int)!
        animationOption = UIView.AnimationOptions.curveEaseOut
        animationDuration = u[UIWindow.keyboardAnimationDurationUserInfoKey] as! Double
        isLocal = u[UIWindow.keyboardIsLocalUserInfoKey] as! Bool
        frameBegin = u[UIWindow.keyboardFrameBeginUserInfoKey] as! CGRect
        frameEnd = u[UIWindow.keyboardFrameEndUserInfoKey] as! CGRect
    }
}
