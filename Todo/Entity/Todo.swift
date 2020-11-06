//
//  Todo.swift
//  Todo
//
//  Created by yosuke.nakayama on 2020/11/04.
//

import Foundation

struct Todo {
    var name: String
    var deadline: Date
    var comment: String
    var assign: User
    var created: User
    var createdAt: Date
    var updatedAt: Date
}

struct User {
    var id: Int
    var name: String
    var createdAt: Date
}
