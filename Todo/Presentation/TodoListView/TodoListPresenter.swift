//
//  TodoListPresenter.swift
//  Todo
//
//  Created by Yosuke Nakayama on 2020/11/13.
//

import Foundation

protocol TodoListPresenterInjectable {
    var todoListPresenterImpl: TodoListPresenter { get }
}

extension TodoListPresenterInjectable {
    var todoListPresenterImpl: TodoListPresenter {
        return TodoListPresenterImpl()
    }
}

// MARK: - <P>TodoListPresenter

protocol TodoListPresenter {
    var todoListRouter: TodoListRouter! { get set }
    var todoListUseCase: TodoUseCase! { get set }
}

// MARK: - TodoListPresenterImpl

final class TodoListPresenterImpl: TodoListPresenter {
    var todoListRouter: TodoListRouter!
    var todoListUseCase: TodoUseCase!
}
