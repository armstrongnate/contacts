//
//  Contact.swift
//  Contacts
//
//  Created by Nate Armstrong on 9/23/15.
//  Copyright © 2015 Nate Armstrong. All rights reserved.
//

public struct Contact {
    public var primaryField: String?
    public var secondaryField: String?
    public var tertiaryField: String?
    public var notes: String?
    public var emails: [Email] = []
    public var phones: [Phone] = []
    public var addresses: [Address] = []
    public var socialProfiles: [SocialProfile] = []
    public var selectOptions: [SelectOption] = []

    public init() {}
}
