//
//  UsersDisplayInteractor.swift
//  CollectionManager
//
//  Created by David on 14/11/2018.
//  Copyright © 2018 David. All rights reserved.
//

import Foundation

protocol UsersDisplayInteractorInput {
    func fetchUsers()
}

protocol UsersDisplayInteractorOutput: class {
    func handleFetchedUsers(_ users: [User])
}

class UsersDisplayInteractor {
    
    private let usersUrlString = "https://jsonplaceholder.typicode.com/users"
    weak var output: UsersDisplayInteractorOutput!
    
    fileprivate func decodeData<T: Decodable>(_ data: Data) -> T? {
        let decoder = JSONDecoder()
        let decodedModel = try? decoder.decode(T.self, from: data)
        return decodedModel
    }
}

extension UsersDisplayInteractor: UsersDisplayInteractorInput {
    func fetchUsers() {
        guard let usersURL = URL(string: usersUrlString) else { return }
        
        let task = URLSession.shared.dataTask(with: usersURL) { [weak self] (data, _, error) in
            
            guard let self = self else { return }
            
            if let error = error {
                print("ERROR !!! \n" + error.localizedDescription)
                return
            }
            
            guard let data = data else { return }
            
            guard let users: [User] = self.decodeData(data) else { return }
            
            self.output.handleFetchedUsers(users)
        }
        
        task.resume()
    }
}
