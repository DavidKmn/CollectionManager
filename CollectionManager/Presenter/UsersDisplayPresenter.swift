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

    var userSection: CollectionSection = {
        let section = CollectionSection(models: nil, header: nil, footer: nil)
        section.itemSpacing = 2
        return section
    }()
    
    private let dummyUser = User(name: "David", username: "Jackovich", email: "jackovich@mail.com")
}

extension UsersDisplayPresenter: UsersDisplayViewOutput {
    
    func handleAddModelsTap() {
        
        let addToEndEditingOption = EditingOptionTestingType.addToEnd { [weak self] _ in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.view.reloadData(after: {
                    self.userSection.add(model: self.dummyUser)
                })
            }
        }
        
        let deleteLastEditingOption = EditingOptionTestingType.deleteLast { [weak self] _ in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.view.reloadData(after: {
                    _ = self.userSection.removeLast()
                })
            }
        }
        
        let deleteAllEditingOption = EditingOptionTestingType.deleteAll { [weak self] (_) in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.view.reloadData(after: {
                    self.userSection.removeAll()
                })
            }
        }
        
        
          view.displayEditingSheet(withOptions: [addToEndEditingOption, deleteLastEditingOption, deleteAllEditingOption])
    }
    
    func viewIsReady() {
        setupUserLinker()
        view.appendSection(userSection)
        interactor.fetchUsers()
    }

    
    fileprivate func setupUserLinker() {
        let userLinker = CollectionViewModelLinker<User, UserCollectionViewCell>()
        
        userLinker.onEvent.dequeue = { (context) in
            context.cell?.nameLabel.text = context.model.name + " Index: \(context.indexPath.item)"
            context.cell?.backgroundColor = .magenta
        }
        
        userLinker.onEvent.didSelect = { (context) in
            print("Did select user with email: \(context.model.email) at index: \(context.indexPath.item)")
        }
        
        view.registerUserLinker(userLinker)
    }
}

extension UsersDisplayPresenter: UsersDisplayInteractorOutput {
    func handleFetchedUsers(_ users: [User]) {
        view.reloadData(after: { [weak self] in
            guard let self = self else { return }
            self.userSection.add(models: users)
        })
    }
}
