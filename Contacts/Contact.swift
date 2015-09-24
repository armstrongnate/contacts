//
//  Contact.swift
//  Contacts
//
//  Created by Nate Armstrong on 9/23/15.
//  Copyright © 2015 Nate Armstrong. All rights reserved.
//

public struct Contact {
    public let name: String
    public var emails: [Email] = []
    public var phones: [Phone] = []
    public var addresses: [Address] = []

    public init(name: String) {
        self.name = name
    }
}
