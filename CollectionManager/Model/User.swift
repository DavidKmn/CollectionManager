//
//  User.swift
//  CollectionManager
//
//  Created by David on 14/11/2018.
//  Copyright © 2018 David. All rights reserved.
//

import Foundation

class User: DiffableModel, Decodable {
    var name: String
    var username: String
    var email: String
    
    init(name: String, username: String, email: String) {
        self.name = name
        self.username = username
        self.email = email
    }
}
