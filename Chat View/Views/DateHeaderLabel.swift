//
//  DateHeaderLabel.swift
//  Chat View
//
//  Created by H on 09/08/2019.
//  Copyright © 2019 H. All rights reserved.
//

import UIKit

class DateHeaderLabel: UILabel {
    override var intrinsicContentSize: CGSize {
        let originalIntrinsicContentSize = super.intrinsicContentSize
        let height = originalIntrinsicContentSize.height + 12
        
        layer.cornerRadius = (height / 2) - 3
        layer.masksToBounds = true
        
        return CGSize(width: originalIntrinsicContentSize.width + 36, height: height)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor(white: 0.9, alpha: 1)
        textColor = accentColor
        textAlignment = .center
        translatesAutoresizingMaskIntoConstraints = false
        font = UIFont.systemFont(ofSize: 12)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
