//
//  CustomerFieldTableViewCell.swift
//  Rumple
//
//  Created by Nate Armstrong on 9/17/15.
//  Copyright © 2015 Rumple. All rights reserved.
//

import UIKit

protocol ContactFieldTableViewCellDelegate {
    func changeContactFieldName(contactFieldCell: ContactFieldTableViewCell)
}

class ContactFieldTableViewCell: UITableViewCell {

    var delegate: ContactFieldTableViewCellDelegate?
    lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .Horizontal
        stack.distribution = .Fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = 10
        stack.alignment = .Fill
        self.contentView.addSubview(stack)
        return stack
    }()
    lazy var nameButton: UIButton = {
        let button = UIButton(type: .System)
        button.sizeToFit()
        button.setContentHuggingPriority(1000, forAxis: .Horizontal)
        button.contentHorizontalAlignment = .Left
        button.addTarget(self, action: "nameTapped", forControlEvents: .TouchUpInside)
        button.titleLabel!.adjustsFontSizeToFitWidth = true
        button.titleLabel!.minimumScaleFactor = 0.5
        return button
    }()
    var name: String {
        get {
            return self.nameButton.titleLabel!.text!
        }
        set {
            nameButton.setTitle(newValue, forState: .Normal)
        }
    }
    var value: String {
        get {
            return self.valueTextField.text ?? ""
        }
        set {
            valueTextField.text = newValue
        }
    }
    lazy var valueTextField: UITextField = {
        let tf = UITextField()
        return tf
    }()
    lazy var indicatorImageView: UIImageView = {
        let image = UIImage(named: "right-chevron-light",
            inBundle: NSBundle(forClass: ContactFieldTableViewCell.self),
            compatibleWithTraitCollection: nil)
        let ind = UIImageView(image: image)
        ind.contentMode = .ScaleAspectFit
        return ind
    }()
    lazy var separator: UIView = {
        let s = UIView()
        s.backgroundColor = .lightGrayColor()
        return s
    }()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupStack()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("|-(10)-[stack]|",
            options: NSLayoutFormatOptions(rawValue: 0),
            metrics: nil, views: ["stack": stackView]))

        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[stack]|",
            options: NSLayoutFormatOptions(rawValue: 0),
            metrics: nil, views: ["stack": stackView]))

        indicatorImageView.addConstraint(NSLayoutConstraint(item: indicatorImageView,
            attribute: .Width, relatedBy: .Equal, toItem: nil,
            attribute: .NotAnAttribute, multiplier: 1.0, constant: 10))

        separator.addConstraint(NSLayoutConstraint(item: separator,
            attribute: .Width, relatedBy: .Equal, toItem: nil,
            attribute: .NotAnAttribute, multiplier: 1.0, constant: 0.5))
        
        nameButton.addConstraint(NSLayoutConstraint(item: nameButton,
            attribute: .Width, relatedBy: .Equal, toItem: nil,
            attribute: .NotAnAttribute, multiplier: 1.0, constant: 65))
    }
    
    func setupStack() {
        stackView.insertArrangedSubview(nameButton, atIndex: 0)
        stackView.insertArrangedSubview(indicatorImageView, atIndex: 1)
        stackView.insertArrangedSubview(separator, atIndex: 2)
        stackView.insertArrangedSubview(valueTextField, atIndex: 3)
    }

    func nameTapped() {
        delegate?.changeContactFieldName(self)
    }
    
    override func becomeFirstResponder() -> Bool {
        return valueTextField.becomeFirstResponder()
    }

}
