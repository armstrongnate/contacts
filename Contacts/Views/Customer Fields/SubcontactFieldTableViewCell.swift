//
//  SubcontactFieldTableViewCell.swift
//  Contacts
//
//  Created by Nate Armstrong on 10/1/15.
//  Copyright © 2015 Nate Armstrong. All rights reserved.
//

import UIKit

class SubcontactFieldTableViewCell: ContactFieldTableViewCell {

    var subcontact: Subcontact
    let textFields: [UITextField]

    init(subcontact: Subcontact) {
        self.subcontact = subcontact
        self.textFields = subcontact.fields.map { field in
            let textField = UITextField()
            textField.placeholder = field.label
            textField.text = field.value
            return textField
        }
        super.init(style: .Default, reuseIdentifier: "subcontactCell")
        name = subcontact.label
        textFields.forEach { addSubview($0) }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setupStack() {
        let fieldsStack = UIStackView()
        fieldsStack.axis = .Vertical
        fieldsStack.distribution = .FillEqually
        textFields.forEach { fieldsStack.addArrangedSubview($0) }
        stackView.addArrangedSubview(nameButton)
        stackView.addArrangedSubview(indicatorImageView)
        stackView.addArrangedSubview(separator)
        stackView.addArrangedSubview(fieldsStack)
    }
}
