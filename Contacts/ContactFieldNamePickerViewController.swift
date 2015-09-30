//
//  ContactFieldNamePickerViewController.swift
//  Contacts
//
//  Created by Nate Armstrong on 9/23/15.
//  Copyright © 2015 Nate Armstrong. All rights reserved.
//

import UIKit

class ContactFieldNamePickerViewController: LabelPickerTableViewController {

    var indexPath: NSIndexPath

    init(indexPath: NSIndexPath, labels: [String]) {
        self.indexPath = indexPath
        super.init(labels: labels)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
