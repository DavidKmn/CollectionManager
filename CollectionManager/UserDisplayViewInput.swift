//
//  UserViewInput.swift
//  CollectionManager
//
//  Created by David on 16/11/2018.
//  Copyright © 2018 David. All rights reserved.
//

import Foundation

protocol UsersDisplayViewInput: class {
    func appendSection(_ section: CollectionSection)
    func registerUserLinker(_ linker: CollectionViewModelLinker<User, UserCollectionViewCell>)
    func reloadData()
}
