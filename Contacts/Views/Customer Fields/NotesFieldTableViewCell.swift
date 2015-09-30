//
//  NotesFieldTableViewCell.swift
//  Contacts
//
//  Created by Nate Armstrong on 9/30/15.
//  Copyright © 2015 Nate Armstrong. All rights reserved.
//

import UIKit

class NotesFieldTableViewCell: UITableViewCell {

    lazy var notesLabel: UILabel = {
        let label = UILabel()
        label.text = "Notes"
        label.textColor = .lightGrayColor()
        label.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(label)
        return label
    }()

    lazy var notesTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(textView)
        return textView
    }()


    init() {
        super.init(style: .Default, reuseIdentifier: "notesCell")
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
            "V:|-[label]-[textView]-|",
            options: NSLayoutFormatOptions(rawValue: 0),
            metrics: nil,
            views: ["label": notesLabel, "textView": notesTextView]))
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
            "|-[label]-|",
            options: NSLayoutFormatOptions(rawValue: 0),
            metrics: nil,
            views: ["label": notesLabel]))
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
            "|-[textView]-|",
            options: NSLayoutFormatOptions(rawValue: 0),
            metrics: nil,
            views: ["textView": notesTextView]))
    }

}
