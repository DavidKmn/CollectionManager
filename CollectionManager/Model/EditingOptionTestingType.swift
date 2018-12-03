//
//  EditingOption.swift
//  CollectionManager
//
//  Created by David on 18/11/2018.
//  Copyright © 2018 David. All rights reserved.
//

import Foundation

enum EditingOptionTestingType {
    typealias CompletionHandler = ((_ index: Int?) -> Void)?
    
    case addToEnd(CompletionHandler)
    case deleteLast(CompletionHandler)
    case deleteAll(CompletionHandler)
    case add(CompletionHandler)
    
    
    var actionName: String {
        switch self {
        case .addToEnd(_):
            return "Add to end"
        case .deleteLast(_):
            return "Delete last"
        case .deleteAll(_):
            return "Delete all"
        case .add(_):
            return "Add"
        }
    }
    
    var action: CompletionHandler {
        switch self {
        case .addToEnd(let handler):
            return handler
        case .deleteLast(let handler):
            return handler
        case .deleteAll(let handler):
            return handler
        case .add(let handler):
            return handler
        }
    }
}

