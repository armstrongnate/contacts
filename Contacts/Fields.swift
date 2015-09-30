//
//  Email.swift
//  Contacts
//
//  Created by Nate Armstrong on 9/23/15.
//  Copyright © 2015 Nate Armstrong. All rights reserved.
//

public protocol ContactField {
    var label: String { get set }
}

public struct Email: ContactField {
    public var label: String
    public let value: String

    public init(label: String, value: String) {
        self.label = label
        self.value = value
    }
}

public struct Phone: ContactField {
    public var label: String
    public let value: String

    public init(label: String, value: String) {
        self.label = label
        self.value = value
    }
}

public struct Address: ContactField {
    public var label: String
    public let street: String
    public let street1: String
    public let city: String
    public let state: String
    public let zip: String

    public init(label: String, street: String, street1: String, city: String,
                state: String, zip: String) {
        self.label = label
        self.street = street
        self.street1 = street1
        self.city = city
        self.state = state
        self.zip = zip
    }

    public init(label: String) {
        self.init(label: label, street: "", street1: "", city: "", state: "", zip: "")
    }
}

public struct SelectOption: ContactField {
    public var label: String
    public var options: [String]
    public var values: [String] = []
    public var allowsMultiple = true

    public init(label: String, options: [String]) {
        self.label = label
        self.options = options
    }
}
