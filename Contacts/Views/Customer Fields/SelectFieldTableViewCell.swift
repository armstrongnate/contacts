//
//  SelectFieldTableViewCell.swift
//  Contacts
//
//  Created by Nate Armstrong on 9/30/15.
//  Copyright © 2015 Nate Armstrong. All rights reserved.
//

import UIKit

protocol SelectFieldTableViewCellDelegate {
    func selectFieldTableViewCellWasTapped(selectFieldTableViewCell: SelectFieldTableViewCell)
}

class SelectFieldTableViewCell: UITableViewCell {

    init(selectOption: SelectOption) {
        super.init(style: .Value1, reuseIdentifier: "selectOptionCell")
        textLabel!.text = selectOption.label
        if selectOption.values.count > 0 {
            detailTextLabel!.text = selectOption.values.joinWithSeparator(", ")
        }
        else {
            detailTextLabel!.text = "Select \(selectOption.label)"
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
