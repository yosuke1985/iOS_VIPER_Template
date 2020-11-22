//
//  TodoListPresenter.swift
//  Todo
//
//  Created by Yosuke Nakayama on 2020/11/13.
//

import Foundation

// MARK: - <P>TodoListPresenter

protocol TodoListPresenter {
    var router: TodoListRouter! { get set }
    var todoUseCase: TodoUseCase! { get set }
    
    func toLoginView()
    func toTodoDetailView()
    func toCreateTodoView()
}

// MARK: - TodoListPresenterImpl

final class TodoListPresenterImpl: TodoListPresenter {
    var router: TodoListRouter!
    var todoUseCase: TodoUseCase!
    
    func toLoginView() {
        router.toLoginView()
    }
    
    func toTodoDetailView() {
        router.toTodoDetailView()
    }
    
    func toCreateTodoView() {
        router.toCreateTodoView()
    }
}
