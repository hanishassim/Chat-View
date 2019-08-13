//
//  UIView Extensions.swift
//  Chat View
//
//  Created by H on 09/08/2019.
//  Copyright © 2019 H. All rights reserved.
//

import UIKit

extension UIView {
    func applyHuggingConstraint(isLow: Bool = false) {
        if isLow {
            self.setContentHuggingPriority(UILayoutPriority.defaultLow, for: .horizontal)
            self.setContentHuggingPriority(UILayoutPriority.defaultLow, for: .vertical)
            self.setContentCompressionResistancePriority(UILayoutPriority.defaultLow, for: .horizontal)
            self.setContentCompressionResistancePriority(UILayoutPriority.defaultLow, for: .vertical)
        } else {
            self.setContentHuggingPriority(UILayoutPriority(rawValue: 1000), for: .horizontal)
            self.setContentHuggingPriority(UILayoutPriority(rawValue: 1000), for: .vertical)
            self.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 1000), for: .horizontal)
            self.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 1000), for: .vertical)
        }
    }
}
