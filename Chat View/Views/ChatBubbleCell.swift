//
//  ChatBubbleCell.swift
//  Chat View
//
//  Created by H on 09/08/2019.
//  Copyright © 2019 H. All rights reserved.
//

import UIKit

class ChatBubbleCell: TableBaseCell {
    lazy var bubbleView: BubbleView = {
        let maskView = BubbleView()
        maskView.backgroundColor = .clear
        maskView.clipsToBounds = true
        maskView.translatesAutoresizingMaskIntoConstraints = false
        return maskView
    }()
    
    fileprivate lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, ut labore et dolore magna aliqua."
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    fileprivate lazy var timestampLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10)
        label.textAlignment = .right
        label.numberOfLines = 1
        label.text = "88:88 MM"
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    fileprivate var bubbleViewLeadingConstraint: NSLayoutConstraint!
    fileprivate var bubbleViewTrailingConstraint: NSLayoutConstraint!
    fileprivate var bubbleViewWidthConstraint: NSLayoutConstraint!
    
    fileprivate var imageViewLeadingConstraint: NSLayoutConstraint!
    fileprivate var imageViewTrailingConstraint: NSLayoutConstraint!
    fileprivate var imageViewWidthConstraint: NSLayoutConstraint!
    
    fileprivate var messageLabelBottomConstraint: NSLayoutConstraint!
    fileprivate var messageLabelTrailingConstraint: NSLayoutConstraint!
    fileprivate var messageLabelTrailingConstraintAlt: NSLayoutConstraint!
    
    fileprivate var timestampLabelLeadingConstraint: NSLayoutConstraint!
    fileprivate var timestampLabelLeadingConstraintAlt: NSLayoutConstraint!
    fileprivate var timestampLabelTopConstraint: NSLayoutConstraint!
    fileprivate var timestampLabelTopConstraintAlt: NSLayoutConstraint!
    
    var width: CGFloat!
    
    var direction: ChatDirection = .incoming {
        didSet {
            bubbleView.direction = direction
            
            timestampLabel.textColor = direction == .incoming ? UIColor.black.withAlphaComponent(0.5) : .gray
            
            if direction == .outgoing {
                NSLayoutConstraint.deactivate([bubbleViewLeadingConstraint])
                NSLayoutConstraint.activate([bubbleViewTrailingConstraint])
            } else {
                NSLayoutConstraint.deactivate([bubbleViewTrailingConstraint])
                NSLayoutConstraint.activate([bubbleViewLeadingConstraint])
            }
        }
    }
    
    var cellText: String! {
        didSet {
            messageLabel.text = cellText
            
            // cellText + timestampSpacing + timestampWidth + timestampTrailing + horizontalSides + bubbleTail + bubbleLeading
            
            let horizontalSides: CGFloat = 14 * 2
            let bubbleTail: CGFloat = 4
            let bubbleLeading: CGFloat = bubbleViewLeadingConstraint.constant
            let timestampSpacing: CGFloat = 22
            let timestampWidth: CGFloat = timestampLabel.intrinsicContentSize.width
            let timestampTrailing: CGFloat = 20
            
            let contentWidth: CGFloat = messageLabel.intrinsicContentSize.width + timestampSpacing + timestampWidth + timestampTrailing + horizontalSides + bubbleTail + bubbleLeading
            
            if contentWidth > width {
                let constraintRect = CGSize(width: messageLabel.intrinsicContentSize.width, height: .greatestFiniteMagnitude)
//                let boundingBox = cellText.boundingRect(
//                    with: constraintRect,
//                    options: .usesLineFragmentOrigin,
//                    attributes: [NSAttributedString.Key.font: messageLabel.font!],
//                    context: nil)
            }
            
            updateChatBubbleConstraints(isLengthyText: contentWidth > width)
        }
    }
    
    var timestamp: String! {
        didSet {
            timestampLabel.text = timestamp
        }
    }
    
    fileprivate var maxWidth: CGFloat!
    
    override func setupCell() {
        width = 0.88 * contentView.frame.width
        
        bubbleView.addSubview(messageLabel)
        bubbleView.addSubview(timestampLabel)
        contentView.addSubview(bubbleView)
        
        messageLabelBottomConstraint = NSLayoutConstraint(item: messageLabel, attribute: .bottom, relatedBy: .equal, toItem: bubbleView, attribute: .bottom, multiplier: 1, constant: -10)
        
        messageLabelTrailingConstraint = NSLayoutConstraint(item: messageLabel, attribute: .trailing, relatedBy: .lessThanOrEqual, toItem: bubbleView, attribute: .trailing, multiplier: 1, constant: -14)
        messageLabelTrailingConstraintAlt = NSLayoutConstraint(item: messageLabel, attribute: .trailing, relatedBy: .equal, toItem: bubbleView, attribute: .trailing, multiplier: 1, constant: -14)
        
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: messageLabel, attribute: .top, relatedBy: .equal, toItem: bubbleView, attribute: .top, multiplier: 1, constant: 10),
            NSLayoutConstraint(item: messageLabel, attribute: .leading, relatedBy: .equal, toItem: bubbleView, attribute: .leading, multiplier: 1, constant: 14),
            messageLabelBottomConstraint,
            messageLabelTrailingConstraint,
            ])
        
        timestampLabelLeadingConstraint = NSLayoutConstraint(item: timestampLabel, attribute: .leading, relatedBy: .equal, toItem: messageLabel, attribute: .trailing, multiplier: 1, constant: 22)
        
        timestampLabelLeadingConstraintAlt = NSLayoutConstraint(item: timestampLabel, attribute: .leading, relatedBy: .greaterThanOrEqual, toItem: bubbleView, attribute: .leading, multiplier: 1, constant: 22)
        
        timestampLabelTopConstraint = NSLayoutConstraint(item: timestampLabel, attribute: .top, relatedBy: .equal, toItem: messageLabel, attribute: .bottom, multiplier: 1, constant: 10)
        
        timestampLabelTopConstraintAlt = NSLayoutConstraint(item: timestampLabel, attribute: .top, relatedBy: .greaterThanOrEqual, toItem: bubbleView, attribute: .top, multiplier: 1, constant: 8)
        
        NSLayoutConstraint.activate([
            timestampLabelTopConstraintAlt,
            timestampLabelLeadingConstraint,
            NSLayoutConstraint(item: timestampLabel, attribute: .bottom, relatedBy: .equal, toItem: bubbleView, attribute: .bottom, multiplier: 1, constant: -4),
            NSLayoutConstraint(item: timestampLabel, attribute: .trailing, relatedBy: .equal, toItem: bubbleView, attribute: .trailing, multiplier: 1, constant: -20),
            ])
        
        bubbleViewLeadingConstraint = NSLayoutConstraint(item: bubbleView, attribute: .leading, relatedBy: .equal, toItem: contentView, attribute: .leading, multiplier: 1, constant: 16)
        bubbleViewTrailingConstraint = NSLayoutConstraint(item: bubbleView, attribute: .trailing, relatedBy: .equal, toItem: contentView, attribute: .trailing, multiplier: 1, constant: -16)
        
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: bubbleView, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1, constant: 7),
            bubbleViewLeadingConstraint,
            NSLayoutConstraint(item: bubbleView, attribute: .bottom, relatedBy: .equal, toItem: contentView, attribute: .bottom, multiplier: 1, constant: -7),
            ])
        
        bubbleViewWidthConstraint = NSLayoutConstraint(item: bubbleView, attribute: .width, relatedBy: .lessThanOrEqual, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: width)
        
        NSLayoutConstraint.activate([bubbleViewWidthConstraint])
        
        timestampLabel.applyHuggingConstraint(isLow: false)
        
        selectionStyle = .none
        
        updateChatBubbleConstraints(isLengthyText: false)
    }
    
    fileprivate func updateChatBubbleConstraints(isLengthyText: Bool) {
        if isLengthyText {
            timestampLabelLeadingConstraint.isActive = false
            timestampLabelLeadingConstraintAlt.isActive = true
            timestampLabelTopConstraint.isActive = true
            timestampLabelTopConstraintAlt.isActive = false
            messageLabelBottomConstraint.isActive = false
            messageLabelTrailingConstraint.isActive = false
            messageLabelTrailingConstraintAlt.isActive = true
        } else {
            timestampLabelLeadingConstraint.isActive = true
            timestampLabelLeadingConstraintAlt.isActive = false
            timestampLabelTopConstraint.isActive = false
            timestampLabelTopConstraintAlt.isActive = true
            messageLabelBottomConstraint.isActive = true
            messageLabelTrailingConstraint.isActive = true
            messageLabelTrailingConstraintAlt.isActive = false
        }
    }
}
