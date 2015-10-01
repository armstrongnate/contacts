//
//  EditContactViewController.swift
//  Contacts
//
//  Created by Nate Armstrong on 9/23/15.
//  Copyright © 2015 Nate Armstrong. All rights reserved.
//

import UIKit

public protocol EditContactViewControllerDelegate {
    func didSaveContact(contact: Contact)
}

public class EditContactViewController: UITableViewController {

    public enum Section {
        case Phones, Emails, Addresses, Selects, Notes, SocialProfiles, Subcontacts, Subcontact
    }

    public var contact: Contact
    public var delegate: EditContactViewControllerDelegate?
    public lazy var infoView: ContactInfoView = {
        let infoView = ContactInfoView()
        infoView.primaryTextField.text = self.contact.primaryField
        infoView.primaryTextField.addTarget(self,
            action: "textFieldValueChanged:", forControlEvents: .EditingChanged)
        infoView.secondaryTextField.text = self.contact.secondaryField
        infoView.tertiaryTextField.text = self.contact.tertiaryField
        return infoView
    }()
    lazy var saveButton: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: "save")
    }()

    public var sections: [Section] = [.Phones, .Emails, .Addresses, .Selects]
    public var allowChangingRowsInSection: ((section: Section) -> Bool) = { section in
        return true
    }
    public var changingFieldLabelsEnabled = true
    public var infoHeight: CGFloat = 200


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
        var contact = Contact()
        contact.primaryField = infoView.primaryTextField.text
        contact.secondaryField = infoView.secondaryTextField.text
        contact.tertiaryField = infoView.tertiaryTextField.text
        for i in 0..<self.tableView(tableView, numberOfRowsInSection: 0) - 1 {
            let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: i, inSection: 0)) as! PhoneFieldTableViewCell
            let phone = Phone(label: cell.name, value: cell.value)
            contact.phones.append(phone)
        }
        delegate?.didSaveContact(contact)
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
            case .SocialProfiles: return contact.socialProfiles.map{ $0 as ContactField }
            case .Selects: return contact.selectOptions.map{ $0 as ContactField }
            case .Subcontacts: return contact.subcontacts.map{ $0 as ContactField }
            case .Notes, .Subcontact: return []
        }
    }

}

// MARK: - UITableViewDataSource
extension EditContactViewController {

    override public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sections.count
    }

    override public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = sections[section]
        switch section {
        case .Phones, .Emails, .Addresses, .SocialProfiles, .Subcontacts:
            var num = fieldsInSection(section).count
            if allowChangingRowsInSection(section: section) { num += 1 }
            return num
        case .Selects:
            return fieldsInSection(section).count
        case .Notes, .Subcontact:
            return 1
        }
    }

    override public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let section = sections[indexPath.section]

        if indexPathIsAddCell(indexPath) {
            return cellForInsertingFieldInSection(section)
        }

        switch section {
        case .Phones:
            let phone = contact.phones[indexPath.row]
            let cell = PhoneFieldTableViewCell(phone: phone)
            cell.delegate = self
            return cell
        case .Emails:
            let email = contact.emails[indexPath.row]
            let cell = EmailFieldTableViewCell(email: email)
            cell.delegate = self
            return cell
        case .SocialProfiles:
            let profile = contact.socialProfiles[indexPath.row]
            let cell = SocialProfileFieldTableViewCell(socialProfile: profile)
            cell.delegate = self
            return cell
        case .Addresses:
            let address = contact.addresses[indexPath.row]
            let cell = AddressFieldTableViewCell(address: address)
            cell.delegate = self
            return cell
        case .Selects:
            let selectOption = contact.selectOptions[indexPath.row]
            return SelectFieldTableViewCell(selectOption: selectOption)
        case .Subcontacts:
            let subcontact = contact.subcontacts[indexPath.row]
            return SubcontactFieldTableViewCell(subcontact: subcontact)
        case .Notes:
            let cell = NotesFieldTableViewCell()
            cell.notesTextView.text = contact.notes
            return cell
        case .Subcontact:
            let subcontact = Subcontact(label: "agent", fields: contact.subcontact?.fields ?? [])
            let cell = SubcontactFieldTableViewCell(subcontact: subcontact)
            return cell
        }
    }

    func cellForInsertingFieldInSection(section: Section) -> UITableViewCell {
        let name: String
        switch section {
            case .Phones: name = "phone"
            case .Emails: name = "email"
            case .Addresses: name = "address"
            case .SocialProfiles: name = "social profile"
            case .Subcontacts: name = "contact"
            case .Selects, .Notes, .Subcontact: name = ""
        }
        let cell = UITableViewCell(style: .Default, reuseIdentifier: "insertField")
        cell.textLabel!.text = "add \(name)"
        return cell
    }

}

// MARK: - UITableViewDelegate {
extension EditContactViewController {

    override public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPathIsAddCell(indexPath) {
            return 44
        }
        switch sections[indexPath.section] {
        case .Phones, .Emails, .Selects, .SocialProfiles:
            return 44
        case .Addresses:
            return 176
        case .Notes, .Subcontacts, .Subcontact:
            return 100
        }
    }

    override public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let section = sections[indexPath.section]
        if indexPathIsAddCell(indexPath) {
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
            tableView.beginUpdates()
            CATransaction.begin()
            CATransaction.setCompletionBlock {
                self.tableView.cellForRowAtIndexPath(indexPath)!.becomeFirstResponder()
            }

            // todo: ask a delegate for these
            switch section {
            case .Phones:
                contact.phones.append(Phone(label: Phone.labelOptions().first!, value: ""))
            case .Emails:
                contact.emails.append(Email(label: Email.labelOptions().first!, value: ""))
            case .Addresses:
                contact.addresses.append(Address(label: Address.labelOptions().first!))
            case .SocialProfiles:
                contact.socialProfiles
                    .append(SocialProfile(label: SocialProfile.labelOptions().first!, value: ""))
            case .Subcontacts:
                let fields = [
                    Field(label: "Name", value: ""),
                    Field(label: "Title", value: ""),
                    Field(label: "Phone", value: ""),
                    Field(label: "Email", value: "")
                ]
                contact.subcontacts
                    .append(Subcontact(label: Subcontact.labelOptions().first!, fields: fields))
            case .Selects, .Notes, .Subcontact:
                return
            }
            tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Top)
            tableView.endUpdates()
            CATransaction.commit()
        }
        else if section == .Selects {
            let selectOption = contact.selectOptions[indexPath.row]
            let picker = LabelPickerTableViewController(labels: selectOption.options)
            picker.activeLabels = selectOption.values
            picker.delegate = self
            picker.title = selectOption.label
            navigationController?.pushViewController(picker, animated: true)
        }
        else {
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
    }

    override public func tableView(tableView: UITableView,
        editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
            if !allowChangingRowsInSection(section: sections[indexPath.section]) {
                return .None
            }
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
            switch editingStyle {
            case .Delete:
                tableView.beginUpdates()
                switch sections[indexPath.section] {
                    case .Phones: contact.phones.removeAtIndex(indexPath.row)
                    case .Emails: contact.emails.removeAtIndex(indexPath.row)
                    case .Addresses: contact.addresses.removeAtIndex(indexPath.row)
                    case .SocialProfiles: contact.socialProfiles.removeAtIndex(indexPath.row)
                    case .Subcontacts: contact.subcontacts.removeAtIndex(indexPath.row)
                    case .Selects, .Notes, .Subcontact: return
                }
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Top)
                tableView.endUpdates()
            default:
                return
            }
    }

    override public func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return indexPathIsAddCell(indexPath) || sections[indexPath.section] == .Selects
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
        return infoHeight
    }

    func indexPathIsAddCell(indexPath: NSIndexPath) -> Bool {
        let section = sections[indexPath.section]
        if !allowChangingRowsInSection(section: section) {
            return false
        }
        switch section {
        case .Phones, .Emails, .Addresses, .SocialProfiles, .Subcontacts:
            return indexPath.row == self.tableView(tableView, numberOfRowsInSection: indexPath.section) - 1
        case .Selects, .Notes, .Subcontact:
            return false
        }
    }
}

// MARK: - CustomerFieldTableViewCellDelegate
extension EditContactViewController: ContactFieldTableViewCellDelegate {

    func changeContactFieldName(customerFieldCell: ContactFieldTableViewCell) {
        guard changingFieldLabelsEnabled else {
            return
        }
        guard let indexPath = tableView.indexPathForCell(customerFieldCell) else {
            return
        }
        let section = sections[indexPath.section]
        let field = fieldsInSection(section)[indexPath.row]
        let labels = field.dynamicType.labelOptions()
        let namePicker = ContactFieldNamePickerViewController(indexPath: indexPath, labels: labels)
        namePicker.activeLabels = [field.label]
        namePicker.allowsMultipleSelection = false
        namePicker.delegate = self
        navigationController?.pushViewController(namePicker, animated: true)
    }

}

// MARK: - LabelPickerTableViewControllerDelegate
extension EditContactViewController: LabelPickerTableViewControllerDelegate {

    func labelPicker(picker: LabelPickerTableViewController, didSelectLabels labels: [String]) {
        if let fieldPicker = picker as? ContactFieldNamePickerViewController {
            let label = labels.first!
            let indexPath = fieldPicker.indexPath
            let section = sections[indexPath.section]
            switch section {
                case .Phones: contact.phones[indexPath.row].label = label
                case .Emails: contact.emails[indexPath.row].label = label
                case .Addresses: contact.addresses[indexPath.row].label = label
                case .SocialProfiles: contact.socialProfiles[indexPath.row].label = label
                case .Subcontacts: contact.subcontacts[indexPath.row].label = label
                case .Selects, .Notes, .Subcontact: return
            }
            tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .None)
        }
        else if let selectedIndexPath = tableView.indexPathForSelectedRow {
            if sections[selectedIndexPath.section] == .Selects {
                contact.selectOptions[selectedIndexPath.row].values = picker.activeLabels
                tableView.reloadRowsAtIndexPaths([selectedIndexPath], withRowAnimation: .None)
            }
        }
    }
    
}

