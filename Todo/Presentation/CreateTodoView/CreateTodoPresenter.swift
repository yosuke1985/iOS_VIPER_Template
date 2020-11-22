//
//  CreateTodoPresenter.swift
//  Todo
//
//  Created by Yosuke Nakayama on 2020/11/13.
//

import Foundation

protocol CreateTodoPresenter {
    var router: CreateTodoRouter! { get set }
    var todoUseCase: TodoUseCase! { get set }
}

final class CreateTodoPresenterImpl: CreateTodoPresenter {
    var router: CreateTodoRouter!
    var todoUseCase: TodoUseCase!
}
