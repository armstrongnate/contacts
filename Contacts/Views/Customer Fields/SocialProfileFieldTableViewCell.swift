//
//  SocialProfileFieldTableViewCell.swift
//  Contacts
//
//  Created by Nate Armstrong on 9/30/15.
//  Copyright © 2015 Nate Armstrong. All rights reserved.
//

import UIKit

class SocialProfileFieldTableViewCell: ContactFieldTableViewCell {

    var socialProfile: SocialProfile

    init(socialProfile: SocialProfile) {
        self.socialProfile = socialProfile
        super.init(style: .Default, reuseIdentifier: "phoneCell")
        name = socialProfile.label
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
