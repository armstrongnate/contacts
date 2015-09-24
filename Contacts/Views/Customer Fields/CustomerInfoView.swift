//
//  CustomerHeaderFields.swift
//  Rumple
//
//  Created by Nate Armstrong on 9/21/15.
//  Copyright © 2015 Rumple. All rights reserved.
//

import UIKit

class ContactInfoView: UIView {

    let height: CGFloat = 150
    let imageSize: CGFloat = 60

    lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.layer.borderColor = UIColor(red: 147/255.0, green: 149/255.0, blue: 151/255.0, alpha: 1.0).CGColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = self.imageSize / 2
        view.clipsToBounds = false
        view.contentMode = .ScaleAspectFit
        view.addConstraint(NSLayoutConstraint(
            item: view,
            attribute: .Width,
            relatedBy: .Equal,
            toItem: nil, attribute: .NotAnAttribute,
            multiplier: 1.0, constant: self.imageSize))
        view.addConstraint(NSLayoutConstraint(
            item: view,
            attribute: .Height,
            relatedBy: .Equal,
            toItem: nil, attribute: .NotAnAttribute,
            multiplier: 1.0, constant: self.imageSize))
        return view
    }()
    let primaryTextField = AddressSeparatorTextField()
    let secondaryTextField = AddressSeparatorTextField()
    let tertiaryTextField = UITextField()
    lazy var stackView: UIStackView = {
        let textFieldStack = UIStackView(arrangedSubviews:
            [self.primaryTextField, self.secondaryTextField, self.tertiaryTextField])
        textFieldStack.axis = .Vertical
        textFieldStack.distribution = .FillEqually

        let editButton = UIButton(type: .System)
        editButton.setTitle("edit", forState: .Normal)
        editButton.contentVerticalAlignment = .Top
        let imageStack = UIStackView(arrangedSubviews: [self.imageView, editButton])
        imageStack.axis = .Vertical
        imageStack.distribution = .FillProportionally
        imageStack.spacing = 2

        let stack = UIStackView(arrangedSubviews: [imageStack, textFieldStack])
        stack.distribution = .FillProportionally
        stack.spacing = 20
        return stack
    }()

    init() {
        super.init(frame: CGRectZero)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("|-20-[stackView]-20-|",
            options: NSLayoutFormatOptions(rawValue: 0),
            metrics: nil, views: ["stackView": stackView]))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-20-[stackView(150)]",
            options: NSLayoutFormatOptions(rawValue: 0),
            metrics: nil, views: ["stackView": stackView]))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
