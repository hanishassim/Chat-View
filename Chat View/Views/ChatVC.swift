//
//  ChatVC.swift
//  Chat View
//
//  Created by H on 09/08/2019.
//  Copyright © 2019 H. All rights reserved.
//

import UIKit
import RSKGrowingTextView

class ChatVC: UIViewController {
    fileprivate lazy var tableView: UITableView = {
        let table = UITableView()
        table.dataSource = self
        table.delegate = self
        table.estimatedRowHeight = 50
        table.rowHeight = UITableView.automaticDimension
        table.keyboardDismissMode = .onDrag
        table.separatorStyle = UITableViewCell.SeparatorStyle.none
        table.tableFooterView = UIView(frame: CGRect.zero)
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    fileprivate lazy var chatInputView: UIView = {
        let view = UIView()
        view.backgroundColor = "#F5F5F5".hexToUIColor()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    fileprivate lazy var chatInputSeparatorLineView: UIView = {
        let view = UIView()
        view.backgroundColor = "#B3B3B3".hexToUIColor()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    fileprivate lazy var textViewField: RSKGrowingTextView = {
        let tv = RSKGrowingTextView()
        tv.minimumNumberOfLines = 1
        tv.maximumNumberOfLines = 5
        tv.placeholder = "Write a message..."
        tv.placeholderColor = .lightGray
        tv.backgroundColor = .white
        tv.textContainerInset = UIEdgeInsets(top: 14, left: 16, bottom: 14, right: 16)
        tv.font = UIFont.systemFont(ofSize: 14)
        tv.textColor = .black
        tv.tintColor = accentColor
        tv.isScrollEnabled = true
        tv.showsVerticalScrollIndicator = true
        tv.enablesReturnKeyAutomatically = false
        tv.layer.borderColor = UIColor.lightGray.cgColor
        tv.layer.borderWidth = 0.5
        tv.delegate = self
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    fileprivate lazy var sendButton: UIButton = {
        let button = UIButton.init(type: UIButton.ButtonType.system)
        button.setTitle("Send", for: UIControl.State.normal)
        button.setTitleColor(accentColor, for: UIControl.State.normal)
        button.backgroundColor = .white
        button.isEnabled = false
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    fileprivate let chatBubbleCellId = "chatBubbleCell"
    
    fileprivate func enableSendButton() {
        let isTextFieldEmpty = textViewField.text.isEmpty
        
        sendButton.isEnabled = !isTextFieldEmpty
    }
    
    var chatTextInput = String() {
        didSet {
            textViewField.text = chatTextInput
            
            enableSendButton()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Chat View"
        self.view.backgroundColor = .white
        
        initTableView(tableView: self.tableView)
        
        enableSendButton()
    }

    fileprivate func initTableView(tableView: UITableView) {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: chatBubbleCellId)
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: tableView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0),
            NSLayoutConstraint( item: tableView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: tableView, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0),
            ])
        
        view.addSubview(textViewField)
        
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: textViewField, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0),
            NSLayoutConstraint( item: textViewField, attribute: .top, relatedBy: .equal, toItem: tableView, attribute: .bottom, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: textViewField, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0),
            ])
        
        view.addSubview(sendButton)
        
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: sendButton, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0),
            NSLayoutConstraint( item: sendButton, attribute: .top, relatedBy: .equal, toItem: textViewField, attribute: .bottom, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: sendButton, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: sendButton, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0),
            
            NSLayoutConstraint(item: sendButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 45),
            ])
    }
}

extension ChatVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        
        return UITableViewCell()
    }
}

extension ChatVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension ChatVC: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if textView == textViewField {
            enableSendButton()
        }
    }
}
