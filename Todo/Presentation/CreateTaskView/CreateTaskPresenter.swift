//
//  CreateTaskPresenter.swift
//  Todo
//
//  Created by Yosuke Nakayama on 2020/11/13.
//

import Foundation

protocol CreateTaskPresenter {
    var router: CreateTaskRouter! { get set }
    var todoUseCase: TodoUseCase! { get set }
}

final class CreateTaskPresenterImpl: CreateTaskPresenter {
    var router: CreateTaskRouter!
    var todoUseCase: TodoUseCase!
}
