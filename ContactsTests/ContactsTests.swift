//
//  ContactsTests.swift
//  ContactsTests
//
//  Created by Nate Armstrong on 9/23/15.
//  Copyright © 2015 Nate Armstrong. All rights reserved.
//

import XCTest
@testable import Contacts

class ContactsTests: XCTestCase {

    var contact: Contact!
    
    override func setUp() {
        super.setUp()
        contact = Contact(name: "Nate")
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testName() {
        XCTAssertEqual("Nate Armstrong", Contact(name: "Nate Armstrong").name)
    }

    func testEmails() {
        contact.emails.append(Email(label: "home", value: "nate@example.com"))
        XCTAssertEqual(1, contact.emails.count)
    }

    func testPhones() {
        contact.phones.append(Phone(label: "home", value: "*67"))
        XCTAssertEqual(1, contact.phones.count)
    }

    func testAddresses() {
        let address = Address(label: "home", street: "123 Main", street1: "apt 53",
                               city: "New York", state: "New York", zip: "12345")
        contact.addresses.append(address)
        XCTAssertEqual(1, contact.addresses.count)
    }
    
}
