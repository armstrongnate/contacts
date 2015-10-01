//
//  EditContactViewControllerTests.swift
//  Contacts
//
//  Created by Nate Armstrong on 9/23/15.
//  Copyright © 2015 Nate Armstrong. All rights reserved.
//

import XCTest
@testable import Contacts

class EditContactViewControllerTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testNewContactForm() {
        let contact = Contact()
        let vc = EditContactViewController(contact: contact)
        XCTAssert(vc.view != nil)
        XCTAssert(vc.infoView.primaryTextField.text!.isEmpty)
        XCTAssertEqual(4, vc.numberOfSectionsInTableView(vc.tableView))
    }

    func testFieldSections() {
        var contact = Contact()
        contact.primaryField = "Harry Potter"
        contact.phones.append(Phone(label: "personal", value: "1231231234"))
        contact.emails.append(Email(label: "muggle", value: "justamuggle@mail.com"))
        contact.emails.append(Email(label: "wizard", value: "bada$$wizard@mail.com"))
        let address = Address(
            label: "office",
            street: "Hogwarts Way",
            street1: "",
            city: "Diagon Ally",
            state: "London",
            zip: "12345")
        contact.addresses.append(address)

        let vc = EditContactViewController(contact: contact)
        XCTAssert(vc.view != nil)
        let tableView = vc.tableView

        XCTAssertEqual(2, vc.tableView(tableView, numberOfRowsInSection: 0))
        XCTAssertEqual(3, vc.tableView(tableView, numberOfRowsInSection: 1))
        XCTAssertEqual(2, vc.tableView(tableView, numberOfRowsInSection: 2))

        let phoneCell = vc.tableView(tableView,
            cellForRowAtIndexPath: NSIndexPath(forRow: 0, inSection: 0)) as! PhoneFieldTableViewCell
        XCTAssertEqual("personal", phoneCell.nameButton.titleLabel!.text)
        XCTAssertEqual("1231231234", phoneCell.valueTextField.text)
        XCTAssert(phoneCell.indicatorImageView.image != nil)
        let addPhoneCell = vc.tableView(tableView, cellForRowAtIndexPath: NSIndexPath(forRow: 1, inSection: 0))
        XCTAssertEqual("add phone", addPhoneCell.textLabel!.text)
        XCTAssertEqual(UITableViewCellEditingStyle.Delete, vc.tableView(tableView, editingStyleForRowAtIndexPath: NSIndexPath(forRow: 0, inSection: 0)))

        let emailCell = vc.tableView(tableView,
            cellForRowAtIndexPath: NSIndexPath(forRow: 0, inSection: 1)) as! EmailFieldTableViewCell
        XCTAssertEqual("muggle", emailCell.nameButton.titleLabel!.text)
        XCTAssertEqual("justamuggle@mail.com", emailCell.valueTextField.text)
        let addEmailCell = vc.tableView(tableView, cellForRowAtIndexPath: NSIndexPath(forRow: 2, inSection: 1))
        XCTAssertEqual("add email", addEmailCell.textLabel!.text)

        let addressCell = vc.tableView(tableView,
            cellForRowAtIndexPath: NSIndexPath(forRow: 0, inSection: 2)) as! AddressFieldTableViewCell
        XCTAssertEqual("office", addressCell.name)
        XCTAssertEqual("Hogwarts Way", addressCell.street.text)
        XCTAssertEqual("", addressCell.street1.text)
        XCTAssertEqual("Diagon Ally", addressCell.city.text)
        XCTAssertEqual("London", addressCell.state.text)
        XCTAssertEqual("12345", addressCell.zip.text)
        let addAddressCell = vc.tableView(tableView, cellForRowAtIndexPath: NSIndexPath(forRow: 1, inSection: 2))
        XCTAssertEqual("add address", addAddressCell.textLabel!.text)
        XCTAssertEqual(176, vc.tableView(tableView, heightForRowAtIndexPath: NSIndexPath(forRow: 0, inSection: 2)))
        XCTAssertEqual(44, vc.tableView(tableView, heightForRowAtIndexPath: NSIndexPath(forRow: 1, inSection: 2)))
    }

    class MyDelegate: EditContactViewControllerDelegate {
        var contact: Contact?
        func didSaveContact(contact: Contact) {
            self.contact = contact
        }
    }

    func testSaveCallback() {
        var contact = Contact()
        contact.phones.append(Phone(label: "test label", value: "test value"))
        let vc = EditContactViewController(contact: contact)
        let delegate = MyDelegate()
        vc.delegate = delegate
        XCTAssert(vc.view != nil)
        vc.save()
        let savedContact = delegate.contact
        XCTAssert(savedContact != nil)
        XCTAssertEqual("test label", savedContact!.phones.first!.label)
        XCTAssertEqual("test value", savedContact!.phones.first!.value)
    }

    func testDisablingAddRows() {
        var contact = Contact()
        contact.phones.append(Phone(label: "test label", value: "test value"))
        contact.addresses.append(Address(label: "address"))

        let vc = EditContactViewController(contact: contact)
        vc.allowChangingRowsInSection = { section in return false }
        XCTAssert(vc.view != nil)
        let tableView = vc.tableView

        XCTAssertEqual(1, tableView.numberOfRowsInSection(0))

        XCTAssertEqual(176, vc.tableView(tableView, heightForRowAtIndexPath: NSIndexPath(forRow: 0, inSection: 2)))
    }

    func testSelectOptions() {
        var contact = Contact()
        contact.selectOptions.append(SelectOption(label: "Type", options: ["radio", "digital"]))

        let vc = EditContactViewController(contact: contact)
        vc.allowChangingRowsInSection = { section in return false }
        XCTAssert(vc.view != nil)
        let tableView = vc.tableView

        var typeCell = vc.tableView(tableView, cellForRowAtIndexPath: NSIndexPath(forRow: 0, inSection: 3))
        XCTAssertEqual("Type", typeCell.textLabel!.text)
        XCTAssertEqual("", typeCell.detailTextLabel!.text)

        vc.contact.selectOptions[0].values = ["radio", "digital"]
        vc.tableView.reloadData()
        let indexPath = NSIndexPath(forRow: 0, inSection: 3)
        typeCell = vc.tableView(tableView, cellForRowAtIndexPath: indexPath)
        XCTAssertEqual("radio, digital", typeCell.detailTextLabel!.text)
    }

    func testNotes() {
        var contact = Contact()
        contact.notes = "These are notes"

        let vc = EditContactViewController(contact: contact)
        vc.sections = [.Notes]
        vc.tableView.reloadData()
        XCTAssert(vc.view != nil)
        let tableView = vc.tableView

        let notesCell = vc.tableView(tableView, cellForRowAtIndexPath: NSIndexPath(forRow: 0, inSection: 0)) as! NotesFieldTableViewCell
        XCTAssertEqual("Notes", notesCell.notesLabel.text)
        XCTAssertEqual("These are notes", notesCell.notesTextView.text)
    }

    func testSubcontacts() {
        var contact = Contact()
        let nameField = Field(label: "Name", value: "John")
        let titleField = Field(label: "Title", value: "")
        contact.subcontacts.append(Subcontact(label: "contact", fields: [nameField, titleField]))

        let vc = EditContactViewController(contact: contact)
        vc.sections = [.Subcontacts]
        vc.tableView.reloadData()
        XCTAssert(vc.view != nil)
        let tableView = vc.tableView

        let subcontactCell = vc.tableView(tableView, cellForRowAtIndexPath: NSIndexPath(forRow: 0, inSection: 0)) as! SubcontactFieldTableViewCell
        XCTAssertEqual("John", subcontactCell.textFields[0].text)
        XCTAssertEqual("Title", subcontactCell.textFields[1].placeholder)
    }

    func testSubcontact() {
        var contact = Contact()
        let nameField = Field(label: "Name", value: "John")
        let titleField = Field(label: "Title", value: "")
        contact.subcontact = Subcontact(label: "agent", fields: [nameField, titleField])

        let vc = EditContactViewController(contact: contact)
        vc.sections = [.Subcontact]
        vc.tableView.reloadData()
        XCTAssert(vc.view != nil)
        let tableView = vc.tableView

        let subcontactCell = vc.tableView(tableView, cellForRowAtIndexPath: NSIndexPath(forRow: 0, inSection: 0)) as! SubcontactFieldTableViewCell
        XCTAssertEqual("John", subcontactCell.textFields[0].text)
        XCTAssertEqual("Title", subcontactCell.textFields[1].placeholder)
    }

}
