//
//  Todo.swift
//  Todo
//
//  Created by yosuke.nakayama on 2020/11/04.
//

import Foundation
import RxDataSources

struct Todo {
    var id: String
    var title: String
    var description: String
    var isCompleted: Bool
    var createdAt: Date
    var updatedAt: Date
}

extension Todo:
    IdentifiableType,
    Equatable
{
    static func == (lhs: Todo, rhs: Todo) -> Bool {
        return lhs.identity == rhs.identity
    }
    
    typealias Identity = String

    var identity: String {
        return id
    }
}

struct User {
    var userId: String
}
