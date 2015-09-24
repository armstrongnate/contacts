//
//  CustomerAddressFieldTableViewCell.swift
//  Rumple
//
//  Created by Nate Armstrong on 9/18/15.
//  Copyright © 2015 Rumple. All rights reserved.
//

import UIKit

class AddressFieldTableViewCell: ContactFieldTableViewCell {

    var address: Address
    lazy var street: AddressSeparatorTextField = {
        let textField = AddressSeparatorTextField()
        textField.placeholder = "Street"
        textField.startingX = -self.stackView.spacing
        return textField
    }()
    lazy var street1: AddressSeparatorTextField = {
        let textField = AddressSeparatorTextField()
        textField.placeholder = "Street"
        textField.startingX = -self.stackView.spacing
        return textField
    }()
    lazy var city: AddressSeparatorTextField = {
        let textField = AddressSeparatorTextField()
        textField.placeholder = "City"
        textField.startingX = -self.stackView.spacing
        return textField
    }()
    lazy var state: AddressRightSeparatorTextField = {
        let textField = AddressRightSeparatorTextField()
        textField.placeholder = "State"
        return textField
    }()
    lazy var zip: UITextField = {
        let textField = UITextField()
        textField.placeholder = "ZIP"
        textField.keyboardType = .NumberPad
        return textField
    }()
    lazy var innerStackView: UIStackView = {
        let stateZipStack = UIStackView(arrangedSubviews: [self.state, self.zip])
        stateZipStack.axis = .Horizontal
        stateZipStack.distribution = .FillEqually
        stateZipStack.spacing = 10
        let stack = UIStackView(arrangedSubviews: [
            self.street, self.street1, self.city, stateZipStack])
        stack.axis = .Vertical
        stack.distribution = .FillEqually
        return stack
    }()

    init(address: Address) {
        self.address = address
        super.init(style: .Default, reuseIdentifier: "addressCell")
        name = address.label
        street.text = address.street
        street1.text = address.street1
        city.text = address.city
        state.text = address.state
        zip.text = address.zip
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setupStack() {
        stackView.addArrangedSubview(nameButton)
        stackView.addArrangedSubview(indicatorImageView)
        stackView.addArrangedSubview(separator)
        stackView.addArrangedSubview(innerStackView)
    }
    
    override func becomeFirstResponder() -> Bool {
        return street.becomeFirstResponder()
    }

}

class AddressSeparatorTextField: UITextField {
    
    var startingX: CGFloat = 0
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let border = CALayer()
        let width: CGFloat = 0.5
        border.borderColor = UIColor.lightGrayColor().CGColor
        border.frame = CGRect(
            x: startingX,
            y: CGRectGetHeight(bounds) - width,
            width: CGRectGetWidth(bounds) - startingX,
            height: width)
        border.borderWidth = width
        layer.addSublayer(border)
        layer.masksToBounds = true
        clipsToBounds = false
    }

}

class AddressRightSeparatorTextField: UITextField {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let border = CALayer()
        let width: CGFloat = 0.5
        border.borderColor = UIColor.lightGrayColor().CGColor
        border.frame = CGRect(
            x: CGRectGetWidth(bounds) - width,
            y: 0,
            width: CGRectGetWidth(bounds),
            height: CGRectGetHeight(bounds))
        border.borderWidth = width
        layer.addSublayer(border)
        layer.masksToBounds = true
    }

}
