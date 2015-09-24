//
//  EditContactViewController.swift
//  Contacts
//
//  Created by Nate Armstrong on 9/23/15.
//  Copyright © 2015 Nate Armstrong. All rights reserved.
//

import UIKit

let ContactFieldLabels = ["owner", "manager", "agency", "other"]

public protocol EditContactViewControllerDelegate {
    func didSaveContact(contact: Contact)
}

public class EditContactViewController: UITableViewController {

    enum Section: Int {
        case Phones = 0, Emails, Addresses

    }

    let infoHeight: CGFloat = 200

    public var contact: Contact
    public var delegate: EditContactViewControllerDelegate?
    lazy var infoView: ContactInfoView = {
        let infoView = ContactInfoView()
        infoView.primaryTextField.placeholder = "Company Name"
        infoView.primaryTextField.text = self.contact.name
        infoView.primaryTextField.addTarget(self,
            action: "textFieldValueChanged:", forControlEvents: .EditingChanged)
        infoView.secondaryTextField.placeholder = "Contact Name"
        infoView.tertiaryTextField.placeholder = "Type"
        return infoView
        }()
    lazy var saveButton: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: "save")
        }()


    public init(contact: Contact) {
        self.contact = contact
        super.init(style: .Grouped)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        tableView.editing = true
        tableView.allowsSelectionDuringEditing = true
        tableView.tableFooterView = UIView(frame: CGRectZero)
        tableView.backgroundColor = .whiteColor()
        tableView.keyboardDismissMode = .Interactive
        title = title ?? "Add Customer"

        updateSaveButton()
        navigationItem.rightBarButtonItem = saveButton
    }

    func dismissVC() {
        dismissViewControllerAnimated(true, completion: nil)
    }

    func save() {
        if let name = infoView.primaryTextField.text {
            var contact = Contact(name: name)
            contact.phones = self.contact.phones
            contact.emails = self.contact.emails
            contact.addresses = self.contact.addresses
            delegate?.didSaveContact(contact)
        }
    }

    func textFieldValueChanged(textField: UITextField) {
        if textField == infoView.primaryTextField {
            updateSaveButton()
        }
    }

    func updateSaveButton() {
        saveButton.enabled = !(infoView.primaryTextField.text?.isEmpty ?? true)
    }

    func fieldsInSection(section: Section) -> [ContactField] {
        switch section {
            case .Phones: return contact.phones.map{ $0 as ContactField }
            case .Emails: return contact.emails.map{ $0 as ContactField }
            case .Addresses: return contact.addresses.map{ $0 as ContactField }
        }
    }

}

// MARK: - UITableViewDataSource
extension EditContactViewController {

    override public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }

    override public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = Section(rawValue: section) else {
            fatalError("unknown section")
        }
        return fieldsInSection(section).count + 1 // add one for add row
    }

    override public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell: ContactFieldTableViewCell

        guard let section = Section(rawValue: indexPath.section) else {
            fatalError("unknown section")
        }

        let fields = fieldsInSection(section)
        if indexPath.row == fields.count {
            return cellForInsertingFieldInSection(section)
        }

        switch section {
        case .Phones:
            let phone = contact.phones[indexPath.row]
            cell = PhoneFieldTableViewCell(phone: phone)
        case .Emails:
            let email = contact.emails[indexPath.row]
            cell = EmailFieldTableViewCell(email: email)
        case .Addresses:
            let address = contact.addresses[indexPath.row]
            cell = AddressFieldTableViewCell(address: address)
        }
        cell.delegate = self
        return cell
    }

    func cellForInsertingFieldInSection(section: Section) -> UITableViewCell {
        let name: String
        switch section {
            case .Phones: name = "phone"
            case .Emails: name = "email"
            case .Addresses: name = "address"
        }
        let cell = UITableViewCell(style: .Default, reuseIdentifier: "insertField")
        cell.textLabel!.text = "add \(name)"
        return cell
    }

}

// MARK: - UITableViewDelegate {
extension EditContactViewController {

    override public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 2 { // address
            return 176
        }
        return 44
    }

    override public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if indexPathIsAddCell(indexPath) {
            tableView.beginUpdates()
            CATransaction.begin()
            CATransaction.setCompletionBlock {
                self.tableView.cellForRowAtIndexPath(indexPath)!.becomeFirstResponder()
            }
            guard let section = Section(rawValue: indexPath.section) else {
                fatalError("unknown section")
            }

            let label = ContactFieldLabels.first!
            switch section {
            case .Phones:
                contact.phones.append(Phone(label: label, value: ""))
            case .Emails:
                contact.emails.append(Email(label: label, value: ""))
            case .Addresses:
                contact.addresses.append(Address(label: label))
            }
            tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Top)
            tableView.endUpdates()
            CATransaction.commit()
        }
    }

    override public func tableView(tableView: UITableView,
        editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
            if indexPathIsAddCell(indexPath) {
                return .Insert
            }
            return .Delete
    }

    override public func tableView(tableView: UITableView,
        accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
            if indexPathIsAddCell(indexPath) {
                tableView.selectRowAtIndexPath(indexPath, animated: true, scrollPosition: .None)
            }
    }

    override public func tableView(tableView: UITableView,
        commitEditingStyle editingStyle: UITableViewCellEditingStyle,
        forRowAtIndexPath indexPath: NSIndexPath) {
            guard let section = Section(rawValue: indexPath.section) else {
                fatalError("unknown section")
            }
            switch editingStyle {
            case .Delete:
                tableView.beginUpdates()
                switch section {
                    case .Phones: contact.phones.removeAtIndex(indexPath.row)
                    case .Emails: contact.emails.removeAtIndex(indexPath.row)
                    case .Addresses: contact.addresses.removeAtIndex(indexPath.row)
                }
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Top)
                tableView.endUpdates()
            default:
                return
            }
    }

    override public func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return indexPathIsAddCell(indexPath)
    }

    override public func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard section == 0 else {
            return nil
        }
        return infoView
    }

    override public func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard section == 0 else {
            return 20
        }
        return self.infoHeight
    }

    func indexPathIsAddCell(indexPath: NSIndexPath) -> Bool {
        if let _ = tableView.cellForRowAtIndexPath(indexPath) as? ContactFieldTableViewCell {
            return false
        }
        return true
    }
}

// MARK: - CustomerFieldTableViewCellDelegate
extension EditContactViewController: ContactFieldTableViewCellDelegate {

    func changeContactFieldName(customerFieldCell: ContactFieldTableViewCell) {
        guard let indexPath = tableView.indexPathForCell(customerFieldCell), section = Section(rawValue: indexPath.section) else {
            fatalError("error with indexPath")
        }
        let field = fieldsInSection(section)[indexPath.row]
        let namePicker = ContactFieldNamePickerViewController(indexPath: indexPath)
        namePicker.activeLabel = field.label
        namePicker.delegate = self
        let navController = UINavigationController(rootViewController: namePicker)
        navController.navigationItem.leftBarButtonItem =
            UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: "dismissVC")
        presentViewController(navController, animated: true, completion: nil)
    }

}

// MARK: - LabelPickerTableViewControllerDelegate
extension EditContactViewController: LabelPickerTableViewControllerDelegate {

    func labelPicker(picker: LabelPickerTableViewController, didSelectLabel label: String) {
        let indexPath = (picker as! ContactFieldNamePickerViewController).indexPath
        switch Section(rawValue: indexPath.section)! {
            case .Phones: contact.phones[indexPath.row].label = label
            case .Emails: contact.emails[indexPath.row].label = label
            case .Addresses: contact.addresses[indexPath.row].label = label
        }
        tableView.reloadData()
        dismissVC()
    }
    
}

