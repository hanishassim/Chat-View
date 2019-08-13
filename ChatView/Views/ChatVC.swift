//
//  ChatVC.swift
//  Chat View
//
//  Created by H on 09/08/2019.
//  Copyright © 2019 H. All rights reserved.
//

import UIKit
import NotificationCenter
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
        tv.textContainerInset = UIEdgeInsets(top: 14, left: 16, bottom: 14, right: 16)
        tv.font = UIFont.systemFont(ofSize: 14)
        tv.growingTextViewDelegate = self
        tv.backgroundColor = .white
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
        button.addTarget(self, action: #selector(sendButtonTouchUp(inside:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    fileprivate let chatBubbleCellId = "chatBubbleCell"
    fileprivate let chatService = ChatService()
    fileprivate let bubbleFooterSpacing: CGFloat = 32
    fileprivate var timer: Timer?
    fileprivate var shouldScrollToBottom: Bool = true

    fileprivate var bottomLayoutGuideTopAndGrowingTextViewBottomVeticalSpaceConstraint: NSLayoutConstraint!
    
    var chatTextInput: String! {
        didSet {
            DispatchQueue.main.async {
                self.textViewField.text = self.chatTextInput
             
                self.enableSendButton()
            }
        }
    }
    
    var chats: [Chat]? = nil {
        didSet {
            attemptToAssembleGroupedMessages(isPullToRefresh: false)
        }
    }
    
    var chatsGrouped = [[Chat]]()
    fileprivate let postRequest = APIRequest(endpoint: "users")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Chat View"
        self.view.backgroundColor = .white
        
        initTableView(tableView: self.tableView)
        
        enableSendButton()
        
        chatService.getChatList { (chats) in
            self.chats = chats.chats
        }
        
        registerKeyboardNotifications()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if shouldScrollToBottom {
            shouldScrollToBottom = false
            
            scrollToBottom(animated: false)
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
        
        bottomLayoutGuideTopAndGrowingTextViewBottomVeticalSpaceConstraint = NSLayoutConstraint(item: sendButton, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
        
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: sendButton, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0),
            NSLayoutConstraint( item: sendButton, attribute: .top, relatedBy: .equal, toItem: textViewField, attribute: .bottom, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: sendButton, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0),
            bottomLayoutGuideTopAndGrowingTextViewBottomVeticalSpaceConstraint,
            
            NSLayoutConstraint(item: sendButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 45),
            ])
    }
    
    fileprivate func enableSendButton() {
        sendButton.isEnabled = !textViewField.text.isEmpty
    }
    
    fileprivate func initTimer() {
        guard let chats = chatsGrouped.last, chats[chats.count - 1].direction == .incoming else {
            return
        }
        
        timer?.invalidate()
        
        timer = Timer.scheduledTimer(timeInterval: 6, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true)
    }
    
    @objc func sendButtonTouchUp(inside sender: Any) {
        guard let message = textViewField.text, message.count > 0 && !message.isEmpty else {
            return
        }
        
        timer?.invalidate()
        
        postRequest.save(message: message) { (result) in
            switch result {
            case .success(let chat):
                self.chats?.append(chat)
                
                self.chatTextInput = nil
                
                self.initTimer()
            case .failure(let error):
                print("An error occured \(error)")
            }
        }
    }
    
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
            self.tableView.reloadData()
            
            self.scrollToBottom(animated: true)
        }
        
        initTimer()
    }
    
    func scrollToBottom(animated: Bool) {
        view.layoutIfNeeded()
        
        tableView.setContentOffset(CGPoint(x: 0, y: tableView.contentSize.height - tableView.frame.size.height), animated: animated)
    }
    
    func bottomOffset() -> CGPoint {
        return CGPoint(x: 0, y: max(-tableView.contentInset.top, tableView.contentSize.height - tableView.bounds.size.height + tableView.contentInset.bottom))
    }
    
    fileprivate func setupHeaderView(_ section: Int) -> UIView? {
        if let firstMessageInSection = chatsGrouped[section].first, let timestamp = firstMessageInSection.generateDateFromTimestampString() {
            let label = DateHeaderLabel(text: timestamp.printDayAndDate)
            
            let containerView = UIView()
            containerView.addSubview(label)
            label.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
            label.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
            
            return containerView
        }
        return nil
    }
    
    func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        adjustContentForKeyboard(shown: true, notification: notification)
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        adjustContentForKeyboard(shown: false, notification: notification)
    }
    
    func adjustContentForKeyboard(shown: Bool, notification: Notification) {
        guard let payload = KeyboardInfo(notification) else { return }
        
        let keyboardHeight = shown ? payload.frameEnd.size.height : 0
        
        bottomLayoutGuideTopAndGrowingTextViewBottomVeticalSpaceConstraint.constant = -keyboardHeight
        
        if tableView.contentInset.bottom == keyboardHeight {
            return
        }
        
        let distanceFromBottom = bottomOffset().y - tableView.contentOffset.y
        
        var insets = tableView.contentInset
        insets.bottom = keyboardHeight
        
        UIView.animate(withDuration: payload.animationDuration, delay: 0, options: payload.animationOption, animations: {
            
            self.tableView.contentInset = insets
            self.tableView.scrollIndicatorInsets = insets
            
            if distanceFromBottom < 10 {
                self.tableView.contentOffset = self.bottomOffset()
            }
            
            self.view.layoutIfNeeded()
        }, completion: nil)
        
        if !shown {
            scrollToBottom(animated: true)
        }
    }
    
    @objc func fireTimer() {
        let chat = Chat.init(timestamp: Date().formattedDateString, direction: .incoming, message: "Are you there?")
        
        chats?.append(chat)
    }
}

extension ChatVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return chatsGrouped.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatsGrouped[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        let section = indexPath.section
        
        let cell = tableView.dequeueReusableCell(withIdentifier: chatBubbleCellId, for: indexPath) as! ChatBubbleCell
        
        cell.direction = chatsGrouped[section][row].direction
        
        let messageText = chatsGrouped[section][row].message
        
        if messageText.trimmingCharacters(in: [" "]).isEmpty {
            cell.isHidden = true
        }
        
        cell.cellText = messageText
        cell.timestamp = chatsGrouped[section][row].generateDateFromTimestampString()?.printTime()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return setupHeaderView(section)
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let lastSection = chatsGrouped.count - 1
        
        let view = UIView()
        view.isUserInteractionEnabled = false
        
        return section == lastSection ? view : nil
    }
}

extension ChatVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = cell as? ChatBubbleCell {
            cell.direction = chatsGrouped[indexPath.section][indexPath.row].direction
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let lastSection = chatsGrouped.count - 1
        
        return section == lastSection ? 50 : 0
    }
}

extension ChatVC: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if textView == textViewField {
            enableSendButton()
        }
    }
}

extension ChatVC: RSKGrowingTextViewDelegate {
    func growingTextView(_ textView: RSKGrowingTextView, didChangeHeightFrom growingTextViewHeightBegin: CGFloat, to growingTextViewHeightEnd: CGFloat) {
        scrollToBottom(animated: true)
    }
}
