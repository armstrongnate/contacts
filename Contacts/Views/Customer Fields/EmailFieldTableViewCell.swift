//
//  CustomerEmailFieldTableViewCell.swift
//  Rumple
//
//  Created by Nate Armstrong on 9/22/15.
//  Copyright © 2015 Rumple. All rights reserved.
//

import UIKit

class EmailFieldTableViewCell: ContactFieldTableViewCell {

    var email: Email

    init(email: Email) {
        self.email = email
        super.init(style: .Default, reuseIdentifier: "emailCell")
        name = email.label
        value = email.value ?? ""
        valueTextField.placeholder = "Email"
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
