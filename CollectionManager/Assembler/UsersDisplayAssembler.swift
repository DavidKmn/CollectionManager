//
//  UsersDisplayAssembler.swift
//  CollectionManager
//
//  Created by David on 14/11/2018.
//  Copyright © 2018 David. All rights reserved.
//

import Foundation

final class UsersDisplayAssembler {
 
    class func create() -> UsersDisplayViewController {
        
        let interactor = UsersDisplayInteractor()
        let presenter = UsersDisplayPresenter()
        let view = UsersDisplayViewController()
        
        view.output = presenter
        
        presenter.view = view
        presenter.interactor = interactor
        
        interactor.output = presenter
        
        return view
    }
}
