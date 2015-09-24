//
//  CustomerPhoneFieldTableViewCell.swift
//  Rumple
//
//  Created by Nate Armstrong on 9/22/15.
//  Copyright © 2015 Rumple. All rights reserved.
//

import UIKit

class PhoneFieldTableViewCell: ContactFieldTableViewCell {

    var phone: Phone

    init(phone: Phone) {
        self.phone = phone
        super.init(style: .Default, reuseIdentifier: "phoneCell")
        name = phone.label
        value = phone.value ?? ""
        valueTextField.placeholder = "Phone"
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
