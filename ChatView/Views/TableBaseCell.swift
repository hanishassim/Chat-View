//
//  TableBaseCell.swift
//  Chat View
//
//  Created by H on 09/08/2019.
//  Copyright © 2019 H. All rights reserved.
//

import UIKit

class TableBaseCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    func setupCell() { }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
