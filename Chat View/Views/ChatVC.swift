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
    fileprivate let chatService = ChatService()
    fileprivate let bubbleFooterSpacing: CGFloat = 16
    
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
    
    var chats: [Chat]? = nil {
        didSet {
            attemptToAssembleGroupedMessages(isPullToRefresh: false)
        }
    }
    
    var chatsGrouped = [[Chat]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Chat View"
        self.view.backgroundColor = .white
        
        initTableView(tableView: self.tableView)
        
        enableSendButton()
        
        chatService.getChatList { (chats) in
            self.chats = chats.chats
        }
    }

    fileprivate func initTableView(tableView: UITableView) {
        tableView.register(ChatBubbleCell.self, forCellReuseIdentifier: chatBubbleCellId)
        
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
    
    fileprivate func scrollToBottom(animated: Bool) {
//        guard let chatsGrouped = chatsGrouped, chatsGrouped.count > 0 else {
//            return
//        }
        tableView.reloadData()
        
        let section = chatsGrouped.count - 1
        guard chatsGrouped.indices.contains(section) else {
            return
        }
        
        let row = chatsGrouped[section].count - 1
        
        guard chatsGrouped[section].indices.contains(row) else {
            return
        }
        
        tableView.scrollToRow(at: IndexPath(row: row, section: section), at: .bottom, animated: animated)
        tableView.contentOffset.y = tableView.contentOffset.y + bubbleFooterSpacing
    }
    
//    func sendButtonTouchUp(inside sender: Any) {
//        guard let text = textViewInputMessage.text, text.count > 0 && text.isNotEmpty else {
//            return
//        }
//
//        POSTMessage(messageType: "TEXT", file: "", message: text)
//    }
    
    fileprivate func attemptToAssembleGroupedMessages(isPullToRefresh: Bool) {
        chatsGrouped.removeAll()
        
        guard let chats = chats else {
            return
        }
        
        let groupedMessages = Dictionary(grouping: chats) { (element) -> Date in
            return element.generateDateFromTimestampString()!.reduceToMonthDayYear()
        }
        
        // provide a sorting for your keys somehow
        let sortedKeys = groupedMessages.keys.sorted()
        
        sortedKeys.forEach { (key) in
            let values = groupedMessages[key]
            chatsGrouped.append(values ?? [])
        }
        
        DispatchQueue.main.async {
            self.scrollToBottom(animated: false)
        }
    }
}

extension ChatVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        guard let chatsGrouped = chatsGrouped, chatsGrouped.count > 0 else {
//            return 0
//        }
        
        return chatsGrouped[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let chatsGrouped = chatsGrouped, chatsGrouped.count > 0 else {
//            return UITableViewCell()
//        }
        
        let row = indexPath.row
        
        let chatDirection = chatsGrouped[indexPath.section][row].direction
        
        let cell = tableView.dequeueReusableCell(withIdentifier: chatBubbleCellId, for: indexPath) as! ChatBubbleCell
        
        cell.direction = chatDirection
        
        let messageText = chatsGrouped[indexPath.section][row].message
        
        if messageText.trimmingCharacters(in: [" "]).isEmpty {
            cell.isHidden = true
        }
        
        cell.cellText = messageText
        cell.timestamp = chatsGrouped[indexPath.section][row].generateDateFromTimestampString()?.printTime()
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
//        guard let chatsGrouped = chatsGrouped, chatsGrouped.count > 0 else {
//            return 0
//        }
        
        return chatsGrouped.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        guard let chatsGrouped = chatsGrouped, chatsGrouped.count > 0 else {
//            return nil
//        }
        
        if let firstMessageInSection = chatsGrouped[section].first, let timestamp = firstMessageInSection.generateDateFromTimestampString() {
            let label = DateHeaderLabel()
            label.text = timestamp.printDayAndDate()
            
            let containerView = UIView()
            containerView.addSubview(label)
            label.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
            label.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
            
            return containerView
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.isUserInteractionEnabled = false
        return view
    }
}

extension ChatVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        guard let chatsGrouped = chatsGrouped, chatsGrouped.count > 0 else {
//            return
//        }
        
        let chatDirection = chatsGrouped[indexPath.section][indexPath.row].direction
        
        if let cell = cell as? ChatBubbleCell {
            cell.direction = chatDirection
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return bubbleFooterSpacing
    }
}

extension ChatVC: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if textView == textViewField {
            enableSendButton()
        }
    }
}
