//
//  UsersDisplayPresenter.swift
//  CollectionManager
//
//  Created by David on 14/11/2018.
//  Copyright © 2018 David. All rights reserved.
//

import Foundation

class UsersDisplayPresenter {
    
    weak var view: UsersDisplayViewInput!
    var interactor: UsersDisplayInteractor!
    
}

extension UsersDisplayPresenter: UsersDisplayViewOutput {
    func viewIsReady() {
        setupUserLinker()
        interactor.fetchUsers()
    }
    
    fileprivate func setupUserLinker() {
        let userLinker = CollectionViewModelLinker<User, UserCollectionViewCell>()
        
        userLinker.onEvent.dequeue = { (context) in
            context.cell?.nameLabel.text = context.model.name
            context.cell?.indexLabel.text = "Index: \(context.indexPath.item)"
            context.cell?.emailLabel.text = context.model.email
            context.cell?.backgroundColor = .gray
        }
        
        userLinker.onEvent.didSelect = { (context) in
            print("Did select user with email: \(context.model.email) at index: \(context.indexPath.item)")
        }
        
        view.registerUserLinker(userLinker)
    }
}

extension UsersDisplayPresenter: UsersDisplayInteractorOutput {
    func handleFetchedUsers(_ users: [User]) {
        let userSection = CollectionSection(models: users, header: nil, footer: nil)
        userSection.itemSpacing = 50
        view.appendSection(userSection)
        view.reloadData()
    }
}
