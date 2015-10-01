//
//  ViewController.swift
//  ContactsDemo
//
//  Created by Nate Armstrong on 10/1/15.
//  Copyright © 2015 Nate Armstrong. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func addContact(sender: AnyObject) {
        var contact = Contact()
        contact.emails.append(Email(label: "email", value: ""))
        contact.phones.append(Phone(label: "phone", value: ""))
        contact.addresses.append(Address(label: "address"))

        let agencyFields = [
            Field(label: "Name", value: ""),
            Field(label: "Contact Name", value: ""),
            Field(label: "Phone", value: ""),
            Field(label: "Email", value: ""),
            Field(label: "Contact Title", value: "")
        ]
        contact.subcontact = Subcontact(label: "agency", fields: agencyFields)

        let contactFields = [
            Field(label: "Name", value: ""),
            Field(label: "Title", value: ""),
            Field(label: "Phone", value: ""),
            Field(label: "Email", value: ""),
        ]
        contact.subcontacts.append(Subcontact(label: "contact", fields: contactFields))

        let form = EditContactViewController(contact: contact)
        form.title = "Add Account"
        form.sections = [.Phones, .Emails, .Addresses, .SocialProfiles, .Subcontact, .Subcontacts, .Notes]
        form.changingFieldLabelsEnabled = false
        form.infoView.primaryTextField.placeholder = "Name"
        form.infoView.secondaryTextField.placeholder = "Website"
        form.infoView.secondaryTextField.separatorHidden = true
        form.infoView.tertiaryTextField.hidden = true
        form.infoHeight = 130
        form.allowChangingRowsInSection = { section in return section == EditContactViewController.Section.Subcontacts }
        form.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: "dismissVC")
        let nav = UINavigationController(rootViewController: form)
        presentViewController(nav, animated: true, completion: nil)
    }

}

