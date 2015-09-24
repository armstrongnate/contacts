//
//  EmailsTests.swift
//  Contacts
//
//  Created by Nate Armstrong on 9/23/15.
//  Copyright © 2015 Nate Armstrong. All rights reserved.
//

import XCTest
@testable import Contacts

class FieldsTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testEmail() {
        let email = Email(label: "home", value: "test@test.com")
        XCTAssertEqual("home", email.label)
        XCTAssertEqual("test@test.com", email.value)
    }

    func testPhone() {
        let phone = Phone(label: "work", value: "123-123-1234")
        XCTAssertEqual("work", phone.label)
        XCTAssertEqual("123-123-1234", phone.value)
    }

    func testAddress() {
        let address = Address(label: "business", street: "123 Main St",
                            street1: "suite 201", city: "St. George",
                              state: "UT", zip: "84790")
        XCTAssertEqual("business", address.label)
        XCTAssertEqual("123 Main St", address.street)
        XCTAssertEqual("suite 201", address.street1)
        XCTAssertEqual("St. George", address.city)
        XCTAssertEqual("UT", address.state)
        XCTAssertEqual("84790", address.zip)
    }

}
